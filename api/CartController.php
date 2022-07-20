<?php

namespace App\Http\Controllers\Api\Salon;

use App\Helpers\Helper;
use App\Models\Product;
use App\Models\Voucher;
use App\Models\SalonCart;
use Illuminate\Http\Request;
use App\Models\DiscountGroupItem;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\ProductResource;
use App\Http\Resources\VoucherResource;
use App\Http\Resources\SalonCartResource;
use Cart;

class CartController extends Controller
{
    protected function discountSalon($idProduct = 0)
    {
        if($idProduct != 0)
        {
            $product = DB::table("salon_carts")
                            ->where('user_id',Auth::guard('salon-api')->user()->id)
                            ->where('product_id',$idProduct)
                            ->first();
            $qty = DB::table("salon_carts")->select(
                        DB::raw("SUM(item_count) as qty")
                    )
                    ->where('user_id',Auth::guard('salon-api')->user()->id)
                    ->where('discount_id',$product->discount_id)
                    ->first();
            $dcg = DB::table("discount_groups")->where('id',$product->discount_id)->first();

            $discount = 0;

            if(!empty($dcg))
            {
                if($qty->qty >= 3 && $qty->qty <= 5)
                {
                    $discount = $dcg->dcg_3;
                }
                else if($qty->qty >= 6 && $qty->qty <= 11)
                {
                    $discount = $dcg->dcg_6;
                } 
                else if($qty->qty >= 12 && $qty->qty <= 23)
                {
                    $discount = $dcg->dcg_12;
                } 
                else if($qty->qty >= 24 && $qty->qty <= 35)
                {
                    $discount = $dcg->dcg_24;
                } 
                else if($qty->qty >= 36)
                {
                    $discount = $dcg->dcg_36;
                }
                else 
                {
                    $discount = 0;
                }

                DB::table("salon_carts")
                    ->where('user_id',Auth::guard('salon-api')->user()->id)
                    ->where('discount_id',$dcg->id)
                    ->update(['discount_amount' => $discount]);
                    
                return $discount;
            }
            else 
            {
                return $discount;
            }
            
        }
    }

    public function add(Request $request,Product $product)
    {
        $cart = SalonCart::where('product_id',$product->id)
                        ->where('user_id',Auth::guard('salon-api')->user()->id)
                        ->first();
                        
        $discount = DiscountGroupItem::where('product_id',$product->id)->first();
        if(empty($cart)){
            $cart                   = new SalonCart();
            $cart->user_id          = Auth::guard('salon-api')->user()->id;
            $cart->product_id       = $product->id;
            $cart->product_name     = $product->pd_name_th;
            $cart->item_count       = $request->qty;
            $cart->status           = 1;
            $cart->product_price    = $product->pd_price_salon;
            $cart->product_img      = asset('images/product/300/'.$product->pd_main_image);
            $cart->discount_id      = !empty($discount) ? $discount->discount_group_id : 0;
            $cart->discount_amount  = 0;
        }else{
            if(!$cart->product->pd_status_gift)
            {
                $cart->item_count = $cart->item_count + $request->qty;
            }
            else 
            {
                $cart->item_count = 1;
            }
            
        }

        $cart->save();

        $this->discountSalon($product->id);

        
        return [
            'save' => true,
            'cart' => new SalonCartResource($cart)
        ];
    }

    public function lists()
    {
        $product_clear = DB::table('salon_carts')->where('user_id',Auth::guard('salon-api')->user()->id)->get();
        $total = 0;
        $shipping = 0;

        foreach ($product_clear as $item) {

            $product = Product::findOrFail($item->product_id);

            $cart_product = SalonCart::where('product_id',$product->id)
                                ->where('user_id',Auth::guard('salon-api')->user()->id)
                                ->first();
            $cart_product->product_price = $product->pd_price_salon;
            $cart_product->save();

            $discount = DiscountGroupItem::where('product_id',$product->id)->first();
            if(!empty($discount))
            {
                $this->discountSalon($product->id);
            }

            if($product->pd_status != 1 || $product->pd_qty < 1 || $product->pd_show_salon != 1){
                DB::table('salon_carts')
                    ->where('user_id',Auth::guard('salon-api')->user()->id)
                    ->where('product_id',$product->id)
                    ->delete();
            }
        }

        $products = SalonCart::where('user_id',Auth::guard('salon-api')->user()->id)->get();

        foreach ($products as $item) {
            $total += ($item->product_price - $item->discount_amount) * $item->item_count;
        }

        

        if($total > 999){
            $shipping = 0;
        }else{
            $shipping = 60;
        }

        return [
            'products'  => SalonCartResource::collection($products),
            'total'     => $total,
            'shipping'  => $shipping
        ];
    }

    public function useVoucher(Voucher $voucher)
    {
        $products = SalonCart::where('user_id',Auth::guard('salon-api')->user()->id)->get();
        $total = 0;
        $shipping = 0;

        foreach ($products as $item) {
            $total += ($item->product_price - $item->discount_amount) * $item->item_count;
        }

        if($total > 999){
            $shipping = 0;
        }else{
            $shipping = 60;
        }

        if($voucher->vc_money <= ($total+$shipping)){
            return [
                'save' => true,
                'voucher' => new VoucherResource($voucher)
            ];
        }else{
            return [
                'save' => false,
                'message' => 'คุณใช้คูปองนี้ไม่ได้ ยอดสั่งซื้อต้อง '.$voucher->vc_money.' บาทขึ้นไป',
            ];
        }
    }

    public function pointLists()
    {
        $userID = "point-".Auth::guard('salon-api')->user()->id;
        $total = Cart::session($userID)->getTotal();

        $cartCollection  = Cart::session($userID)->getContent();
        $products = $cartCollection->sort();
        
        $point = Auth::guard('salon-api')->user()->salon_point;

        return response()->json([
            'products' => $products,
            'point' => $point,
            'total' => $total
        ],200);
    }
}
