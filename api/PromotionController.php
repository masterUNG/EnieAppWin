<?php

namespace App\Http\Controllers\Api\Salon;

use Cart;
use App\Models\Promotion;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\PromotionResource;

class PromotionController extends Controller
{
    public function recommend()
    {
        $promotion_recommends = Promotion::where('pm_status',1)
                                    ->where('pm_pro1',1)
                                    ->orderBy('pm_seq','asc')
                                    ->limit(10)
                                    ->get();
        
        return PromotionResource::collection($promotion_recommends);
    }

    public function set()
    {
        $promotion_sets = Promotion::where('pm_status',1)
                                ->where('pm_pro2',1)
                                ->orderBy('pm_seq','asc')
                                ->limit(10)
                                ->get();

        return PromotionResource::collection($promotion_sets);
    }

    public function all()
    {
        $promotions = Promotion::where('pm_status',1)->orderBy('pm_seq','asc')->get();

        return PromotionResource::collection($promotions);
    }

    public function lists()
    {
        $promotions = Promotion::where('pm_status',1)->orderBy('pm_seq','asc')->get();

        return PromotionResource::collection($promotions);
    }

    public function show(Promotion $promotion)
    {
        return new PromotionResource($promotion);
    }

    public function addCart(Promotion $promotion)
    {
        $userID = "promotion-".Auth::guard('salon-api')->user()->id;
        Cart::session($userID)->clear();

        foreach($promotion->items as $item)
        {
            
            Cart::session($userID)->add([
                'id' => $item->id,
                'name' => $item->pmi_prod_name,
                'price' => $item->pmi_total_price,
                'quantity' => $item->pmi_prod_qty,
                'attributes' => [
                    'promotion_type_id' => $promotion->promotion_type_id,
                    'promotion_id' => $promotion->id,
                    'product_id' => $item->product_id,
                    'product_category_id' => $item->product->product_category_id,
                    'soi_prod_name_th' => $item->pmi_prod_name,
                    'soi_prod_category' => $item->product->product_category->pdc_name_th,
                    'soi_prod_unit' => $item->product->pd_unit,
                    'soi_prod_capa' => $item->product->pd_capacity,
                    'soi_prod_qty' => $item->pmi_prod_qty,
                    'soi_total_amount' => $item->pmi_total_price,
                    'soi_prod_com' => $item->product->pd_com,
                    'soi_total_com' => $item->pmi_total_price * ($item->pmi_com / 100),
                    'soi_prod_discount' => $item->pmi_prod_discount,
                    'soi_total_discount' => $item->pmi_prod_discount * $item->pmi_prod_qty
                ],
            ]);
        }

        $carts = Cart::session($userID)->getContent();

        return $carts;
    }
}
