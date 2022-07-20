<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Voucher;
use App\Models\SalonVoucher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\VoucherResource;
use App\Http\Resources\SalonVoucherResource;

class VoucherController extends Controller
{
    public function lists()
    {
        $meVouchers = SalonVoucher::select('voucher_id')
                        ->where('salon_id',Auth::guard('salon-api')->user()->id)
                        ->limit(50)
                        ->pluck('voucher_id');

        $vouchers = Voucher::where('vc_status',1)
                        ->where('vc_type',2)
                        ->where('vc_start_date','<',Date('Y-m-d H:i:s'))
                        ->where('vc_expire_date','>',Date('Y-m-d H:i:s'))
                        ->get();
        
        return [
            'salon_vouchers'    => $meVouchers,
            'vouchers'          => VoucherResource::collection($vouchers)
        ];
    }

    public function collect(Voucher $voucher)
    {
        $voucherData = DB::table('salon_vouchers')
                        ->where('voucher_id',$voucher->id)
                        ->where('salon_id',Auth::guard('salon-api')->user()->id)
                        ->first();
        if(!empty($voucherData)){
            return [
                'save' => false,
                'message' => 'คุณมีคูปองนี้แล้ว'
            ];
        }

        $salonVoucher = new SalonVoucher();
        $salonVoucher->salon_id = Auth::guard('salon-api')->user()->id;
        $salonVoucher->voucher_id = $voucher->id;
        $salonVoucher->sv_status = 1;
        $salonVoucher->save();

        return [
            'save'          => true,
            'message'       => 'คุณเก็บคูปองเรียบร้อยแล้ว',
            'voucher'       => $voucher,
            'salonVoucher'  => $salonVoucher
        ];
    }

    public function history(Request $request)
    {

        $vouchers = SalonVoucher::select('salon_vouchers.*')
                        ->join('vouchers','salon_vouchers.voucher_id','=','vouchers.id')
                        ->where('salon_id',Auth::guard('salon-api')->user()->id);

        if($request->status == 0){
            $vouchers = $vouchers
                            ->where('sv_status',1)
                            ->where('vc_expire_date','>',Date('Y-m-d H:i:s'));
        }else{
            $vouchers = $vouchers
                            ->where(function($query){
                                return $query
                                        ->where('sv_status',0)
                                        ->orWhere('vc_expire_date','<',Date('Y-m-d H:i:s'));
                            });
                            
        }
        
        $vouchers = $vouchers
                        ->orderBy('id','desc')
                        ->get();

        return SalonVoucherResource::collection($vouchers);
    }
}
