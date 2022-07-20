<?php

namespace App\Http\Controllers\Api\Salon;

use Cart;
use App\Models\Admin;
use App\Models\Salon;
use App\Models\Branch;
use App\Models\Account;
use App\Models\Product;
use App\Models\Voucher;
use App\Models\SalonOrder;
use App\Models\PaymentType;
use Illuminate\Support\Str;
use App\Models\SalonProject;
use App\Models\SalonVoucher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Http\Resources\SalonOrderResource;
use Intervention\Image\ImageManagerStatic;

class SalonOrderController extends Controller
{
    public function save(Request $request)
    {
        $salon = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
        $admin = Admin::orderBy('id','asc')->first();
        $branch = Branch::orderBy('id','asc')->first();
        $project = SalonProject::orderBy('id','asc')->first();
        $paymentType = PaymentType::orderBy('id','asc')->first();

        $userID = "order-".Auth::guard('salon-api')->user()->id;
        $carts = DB::table('salon_carts')->where('user_id',Auth::guard('salon-api')->user()->id)->get();

        $voucher = [];
        if(!empty($request->voucher))
        {
            $voucher = Voucher::findOrFail($request->voucher);
        }

        if(count($carts) > 0)
        {
            DB::beginTransaction();
            try {
                $salon_order = SalonOrder::create([
                    'admin_id' => $admin->id,
                    'branch_id' => $branch->id,
                    'salon_id' => $salon->id,
                    'sale_id' => $salon->sale_id,
                    'salon_project_id' => $project->id,
                    'payment_type_id' => $paymentType->id,
                    'so_create_by' => 'Salon',
                    'so_date_save' => date('Y-m-d H:i:s'),
                    'so_date_due' => $paymentType->id == 2 || $paymentType->id == 5 ? date('Y-m-d H:i:s',strtotime("+1 month")) : date('Y-m-d H:i:s'),
                    'so_process_money' => 99,
                    'so_process_send' => 99,
                    'so_send_date' => null,
                    'so_name' => $salon->salon_name,
                    'so_phone' => $salon->salon_phone,
                    'so_address' => $salon->salon_address,
                    'so_village' => $salon->salon_village,
                    'so_alley' => $salon->salon_alley,
                    'so_road' => $salon->salon_road,
                    'country_id' => $salon->country_id,
                    'province_id' => $salon->province_id,
                    'district_id' => $salon->district_id,
                    'subdistrict_id' => $salon->subdistrict_id,
                    'so_zip_code' => $salon->salon_zip_code,
                    'so_total' => 0,
                    'so_net_total' => 0,
                    'so_com' => 0,
                    'so_discount' => 0,
                    'voucher_id' => $voucher->voucher_id == 0 ? null : $voucher->voucher_id,
                    'so_voucher' => $voucher->voucher_amount,
                    'so_voucher_com' => $voucher->voucher_com,
                    'so_delivery_fee' => $request->shipping,
                    'so_over_due_day' => 0,
                    'so_tracking_code' => null,
                    'sender_id' => null,
                    'packer_id' => null,
                    'checker_id' => null,
                    'so_stock_status' => 0,
                    'so_note' => $request->note,
                    'so_slip' => null,
                    'so_slip_date' => null,
                    'so_sale_confirm' => 0,
                    'so_status_read' => 0,
                    'so_save_vat' => 0,
                    'created_by' => 1,
                    'updated_by' => 1
                ]);

                $total = 0;
                $com = 0;
                $discount = 0;
                
                foreach($carts as $item)
                {
                    $product = Product::findOrFail($item->product_id);

                    $total_item = $item->product_price * $item->item_count;
                    $discount_item = $item->discount_amount * $item->item_count;
                    $com_item = (($item->product_price - $item->discount_amount) * $item->item_count) * $product->pd_com / 100;
                    
                    $salon_order->items()->create([
                        'product_id' => $product->id,
                        'product_category_id' => $product->product_category_id,
                        'soi_prod_name' => $product->pd_name_th,
                        'soi_prod_category' => $product->product_category->pdc_name_th,
                        'soi_prod_capa' => $product->pd_capacity,
                        'soi_prod_unit' => $product->pd_unit,
                        'soi_note' => null,
                        'soi_prod_price' => $item->product_price,
                        'soi_prod_qty' => $item->item_count,
                        'soi_total_amount' => ($item->product_price - $item->discount_amount) * $item->item_count,
                        'soi_prod_com' => $product->pd_com,
                        'soi_total_com' => $com_item,
                        'soi_prod_discount' => !empty($item->discount_amount) ? $item->discount_amount : 0,
                        'soi_total_discount' => $discount_item
                    ]);

                    if(!empty($product)){
                        $product->pd_qty = $product->pd_qty - $item->item_count;
                        $product->pd_sell_qty = $product->pd_sell_qty + $item->item_count;
                        $product->save();
                    }

                    if($product->pd_status_gift){
                        if(!empty($salon->gift_code))
                        {
                            DB::rollBack();
                            return response()->json([
                                'save' => false,
                                'message' => 'ร้านค้าไม่มี Gift Code'
                            ]);
                        }
                        $salon->gift_code = $product->id;
                        $salon->save();
                    }

                    $total += $total_item;
                    $com += $com_item;
                    $discount += $discount_item;
                }

                if($salon->salon_credit_limited - $salon->salon_due_total - $total < 0)
                {
                    DB::rollBack();
                    return response()->json([
                        'save' => false,
                        'message' => 'ร้านค้ามีเครดิตไม่เพียงพอ กรุณาติดต่อ Admin'
                    ]);
                }

                $salon_order->so_total = $total;
                $salon_order->so_com = $com - $voucher->voucher_com;
                $salon_order->so_discount = $discount;
                $salon_order->so_net_total = $total - $discount - $salon_order->so_voucher + $salon_order->so_delivery_fee;
                $salon_order->save();

                $salon->salon_last_order = date('Y-m-d H:i:s');
                $salon->save();

                if($voucher->voucher_id > 0){
                    $voucher = SalonVoucher::where('voucher_id',$voucher->voucher_id)->where('salon_id',$salon->id)->first();
                    $voucher->sv_status = 0;
                    $voucher->save();
                }

                DB::table('salon_carts')->where('user_id',Auth::guard('salon-api')->user()->id)->delete();

                DB::commit();

                return response()->json([
                    'save' => true,
                    'message' => 'สั่งซื้อสินค้าเรียบร้อยแล้ว',
                    'data' => new SalonOrderResource($salon_order)
                ]);
                
            } catch (\Exception $e) {
                DB::rollBack();
                return response()->json([
                    'save' => false,
                    'message' => 'เกิดข้อผิดพลาด '.$e
                ]);
            }
        }
        else 
        {
            return response()->json([
                'save' => false,
                'message' => 'ไม่มีสินค้าในตะกร้า'
            ]);
        }
    }

    public function savePromotion(Request $request)
    {
        $salon = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
        $admin = Admin::orderBy('id','asc')->first();
        $branch = Branch::orderBy('id','asc')->first();
        $project = SalonProject::orderBy('id','asc')->first();
        $paymentType = PaymentType::orderBy('id','asc')->first();

        $userID = "promotion-".Auth::guard('salon-api')->user()->id;
        $carts = Cart::session($userID)->getContent();

        if(count($carts) > 0)
        {
            DB::beginTransaction();
            try {
                $salon_order = SalonOrder::create([
                    'admin_id' => $admin->id,
                    'branch_id' => $branch->id,
                    'salon_id' => $salon->id,
                    'sale_id' => $salon->sale_id,
                    'salon_project_id' => 19,
                    'payment_type_id' => $paymentType->id,
                    'so_create_by' => 'Salon',
                    'so_date_save' => date('Y-m-d H:i:s'),
                    'so_date_due' => $paymentType->id == 2 || $paymentType->id == 5 ? date('Y-m-d H:i:s',strtotime("+1 month")) : date('Y-m-d H:i:s'),
                    'so_process_money' => 99,
                    'so_process_send' => 99,
                    'so_send_date' => null,
                    'so_name' => $salon->salon_name,
                    'so_phone' => $salon->salon_phone,
                    'so_address' => $salon->salon_address,
                    'so_village' => $salon->salon_village,
                    'so_alley' => $salon->salon_alley,
                    'so_road' => $salon->salon_road,
                    'country_id' => $salon->country_id,
                    'province_id' => $salon->province_id,
                    'district_id' => $salon->district_id,
                    'subdistrict_id' => $salon->subdistrict_id,
                    'so_zip_code' => $salon->salon_zip_code,
                    'so_total' => 0,
                    'so_net_total' => 0,
                    'so_com' => 0,
                    'so_discount' => 0,
                    'so_voucher' => 0,
                    'so_delivery_fee' => 0,
                    'so_over_due_day' => 0,
                    'so_tracking_code' => null,
                    'sender_id' => null,
                    'packer_id' => null,
                    'checker_id' => null,
                    'so_stock_status' => 0,
                    'so_note' => $request->note,
                    'so_slip' => null,
                    'so_slip_date' => null,
                    'so_sale_confirm' => 0,
                    'so_status_read' => 0,
                    'so_save_vat' => 0,
                    'created_by' => 1,
                    'updated_by' => 1
                ]);

                $total = 0;
                $com = 0;
                $discount = 0;
                $discount_extra = 0;
                $promotion_type = null;

                foreach($carts as $item)
                {
                    $salon_order->items()->create([
                        'product_id' => $item->attributes->product_id,
                        'product_category_id' => $item->attributes->product_category_id,
                        'soi_prod_name' => $item->attributes->soi_prod_name_th,
                        'soi_prod_category' => $item->attributes->soi_prod_category,
                        'soi_prod_capa' => $item->attributes->soi_prod_capa,
                        'soi_prod_unit' => $item->attributes->soi_prod_unit,
                        'soi_note' => null,
                        'soi_prod_price' => $item->price,
                        'soi_prod_qty' => $item->quantity,
                        'soi_total_amount' => $item->attributes->soi_total_amount * $item->quantity,
                        'soi_prod_com' => $item->attributes->soi_prod_com,
                        'soi_total_com' => $item->price * ($item->attributes->soi_prod_com / 100),
                        'soi_prod_discount' => $item->attributes->soi_prod_discount,
                        'soi_total_discount' => $item->attributes->soi_total_discount
                    ]);

                    $total += $item->price * $item->quantity;
                    $com += ($item->price*$item->quantity)  * ($item->attributes->soi_prod_com / 100);
                    $discount += 0;
                    $promotion_type = $item->attributes->promotion_type_id;
                }

                if($salon->salon_credit_limited - $salon->salon_due_total - $total < 0)
                {
                    DB::rollBack();
                    return response()->json([
                        'save' => false,
                        'error' => "เครดิตไม่เพียงพอกรุณาติดต่อ แอดมิน"
                    ]);
                }

                $salon_order->so_total = $total;
                $salon_order->so_com = $com;
                $salon_order->so_discount = $discount;
                $salon_order->so_net_total = $total - $discount - $salon_order->so_voucher;
                $salon_order->promotion_type_id = $promotion_type;
                $salon_order->save();
                DB::commit();
                Cart::session($userID)->clear();
                return response()->json([
                    'save' => true,
                    'data' => new SalonOrderResource($salon_order)
                ]);
            } catch (\Exception $e) {
                DB::rollBack();
                return response()->json([
                    'save' => false,
                    'error' => "เกิดข้อผิดพลาด กรุณาลองอีกครั้งในภายหลัง"
                ]);
            }
        }
        else
        {
            return response()->json([
                'save' => false,
                'error' => "ไม่มีสินค้าในตะกร้า กรุณาเลือกสินค้าก่อน"
            ]);
        }
    }

    public function bank(SalonOrder $salon_order)
    {
        return response()->json([
            'order' => new SalonOrderResource($salon_order),
            'bank' => Account::where('account_show_salon',1)->where('account_status',1)->orderBy('account_seq','asc')->get()
        ]);
    }

    public function uploadSlip(Request $request,SalonOrder $salon_order)
    {
        if (!$request->has('slip')) {
            return response()->json([
                'save' => false,
                'message' => 'คุณไม่ได้เลือกไฟล์ภาพ'
            ]);
        }

        $img   = ImageManagerStatic::make($request->file('slip'))->encode('jpg');
        $name  = date('YmdHis').Str::random() . '.jpg';
        Storage::disk('slip')->makeDirectory($salon_order->salon_id,777);
        Storage::disk('slip')->put($salon_order->salon_id.'/'.$name, $img);

        $salon_order->so_slip = $name;
        $salon_order->so_slip_date = date('Y-m-d H:i:s');
        $salon_order->save();

        return response()->json([
            'save' => true,
            'message' => 'บันทึกข้อมูลสลิปสั่งซื้อสินค้าเรียบร้อย',
            'data' => new SalonOrderResource($salon_order)
        ]);
    }

    public function payments(Request $request)
    {
        $order_lists = SalonOrder::where('salon_id',Auth::guard('salon-api')->user()->id);


        if($request->statusOrd)
        {
            $order_lists = $order_lists
                                ->where('so_process_money',1);
        }
        else 
        {
            $order_lists = $order_lists
                                ->where(function($query){
                                    return $query
                                                ->where('so_process_money','<>',1)
                                                ->where('so_process_money','<>',0);
                                });
        }

        if(!empty($request->searchTerm))
        {
            $order_lists = $order_lists
                                ->where('id',$request->searchTerm);
        }


        $order_lists = $order_lists
                            ->orderBy('id','desc')
                            ->get();

        return response()->json([
            'statusOrd' => $request->statusOrd,
            'data' => SalonOrderResource::collection($order_lists)
        ]);
    }

    public function lists(Request $request)
    {
        $order_lists = SalonOrder::where('salon_id',Auth::guard('salon-api')->user()->id)
                            ->where('so_process_send',$request->processSend)
                            ->orderBy('id','desc')
                            ->get();
        
        return response()->json([
            'processSend' => 99,
            'data' => SalonOrderResource::collection($order_lists)
        ]);
    }
}
