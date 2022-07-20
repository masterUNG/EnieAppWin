<?php

namespace App\Http\Controllers\Api\Salon;

use Cart;
use App\Models\Salon;
use App\Models\Product;
use App\Models\SalonPoint;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class SalonPointController extends Controller
{
    public function add(Request $request,Product $product)
    {
        $validated = Validator::make($request->all(),[
            'qty' => 'required|integer|min:1'
        ]);


        if($validated->fails())
        {
            return response()->json([
                'save' => false,
                'validator' => $validated->messages()
            ]);
        }

        $userID = "point-".Auth::guard('salon-api')->user()->id;

        Cart::session($userID)->add([
            'id' => $product->id,
            'name' => $product->pd_name_th,
            'price' => $product->pd_price_point,
            'quantity' => $request->qty,
            'attributes' => [
                'product_point_id' => $product->id,
                'spi_prod_name' => $product->pd_name_th,
                'spi_prod_unit' => '-',
                'spi_prod_capa' => '-',
                'spi_prod_capa_unit' => '-',
                'spi_prod_price' => $product->pd_price_salon,
                'spi_prod_point' => $product->pd_price_point,
                'spi_prod_qty' => $request->qty,
            ],
            'associatedModel' => $product
        ]);

        return response()->json([
            'save' => true,
            'message' => 'เพิ่มสินค้าลงตะกร้าเรียบร้อย',
        ]);

    }

    public function save(Request $request)
    {

        $userID = "point-".Auth::guard('salon-api')->user()->id;
        $carts = Cart::session($userID)->getContent();

        if(count($carts) == 0){
            return response()->json([
                'save' => false,
                'message' => 'คุณยังไม่ได้เลือกสินค้า กรุณาเลือกสินค้าก่อน',
            ],400);
        }

        DB::beginTransaction();
        try {

            $point_order = SalonPoint::create([
                'salon_id' => Auth::guard('salon-api')->user()->id,
                'sale_id' => Auth::guard('salon-api')->user()->sale_id,
                'sp_date_save' => date('Y-m-d H:i:s'),
                'sp_process_point' => 1,
                'sp_process_send' => 3,
                'sp_send_date' => null,
                'sp_name' => Auth::guard('salon-api')->user()->salon_name,
                'sp_phone' => Auth::guard('salon-api')->user()->salon_phone,
                'sp_address' => Auth::guard('salon-api')->user()->salon_address,
                'sp_village' => Auth::guard('salon-api')->user()->salon_village,
                'sp_alley' => Auth::guard('salon-api')->user()->salon_alley,
                'sp_road' => Auth::guard('salon-api')->user()->salon_road,
                'country_id' => Auth::guard('salon-api')->user()->country_id,
                'province_id' => Auth::guard('salon-api')->user()->province_id,
                'district_id' => Auth::guard('salon-api')->user()->district_id,
                'subdistrict_id' => Auth::guard('salon-api')->user()->subdistrict_id,
                'sp_zip_code' => Auth::guard('salon-api')->user()->salon_zip_code,
                'sp_amount_total' => 0,
                'sp_point_total' => 0,
                'sp_tracking_code' => null,
                'sender_id' => null,
                'packer_id' => null,
                'checker_id' => null,
                'sp_stock_status' => 0,
                'sp_note' => $request->note,
                'sp_employee_note' => null,
                'sp_sale_confirm' => 0,
                'sp_status_read' => 0,
                'created_by' => 1,
                'updated_by' => 1
            ]);

            $point_total = 0;
            $price_total = 0;

            foreach($carts as $item)
            {
                $point_order->items()->create([
                    'product_point_id' => $item->id,
                    'spi_prod_name' => $item->attributes->spi_prod_name,
                    'spi_prod_unit' => $item->attributes->spi_prod_unit,
                    'spi_prod_capa' => $item->attributes->spi_prod_capa,
                    'spi_prod_capa_unit' => $item->attributes->spi_prod_capa_unit,
                    'spi_prod_price' => $item->attributes->spi_prod_price,
                    'spi_prod_point' => $item->attributes->spi_prod_point,
                    'spi_prod_qty' => $item->quantity,
                    'spi_note' => null,
                    'spi_employee_note' => null,
                    'spi_total_point' => $item->quantity * $item->price,
                    'spi_total_price' => $item->quantity * $item->attributes->spi_prod_price,
                ]);

                $product = Product::findOrFail($item->id);
                $product->pd_qty = $product->pd_qty - $item->quantity;
                $product->save();

                $point_total += $item->quantity * $item->price;
                $price_total += $item->quantity * $item->attributes->spi_prod_price;
            }

            $point_order->sp_point_total = $point_total;
            $point_order->sp_amount_total = $price_total;
            $point_order->save();

            $salon = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
            $salon->salon_point = $salon->salon_point - $point_order->sp_point_total;
            $salon->save();
            
            DB::commit();
            Cart::session($userID)->clear();
            return response()->json([
                'save' => true,
                'message' => 'แลกสินค้าเรียบร้อยแล้ว',
            ],201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'save' => false,
                'message' => 'เกิดข้อผิดพลาด',
                'errors' => $e
            ],400);
        }
        
    }

}
