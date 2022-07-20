<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Repair;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\RepairResource;

class RepairController extends Controller
{
    public function lists(Request $request)
    {
        $repairs = Repair::where('salon_id',Auth::guard('salon-api')->user()->id)
                        ->where('rp_status','<>',0);

        if($request->statusRepair)
        {
            $repairs = $repairs
                            ->where('rp_status',1);
        }
        else 
        {
            $repairs = $repairs
                            ->where('rp_status','<>',1);
        }

        if(!empty($request->searchTerm))
        {
            $repairs = $repairs
                            ->where('id',$request->searchTerm);
        }

        $repairs = $repairs->get();

        return RepairResource::collection($repairs);
    }

    public function show(Repair $repair)
    {
        return new RepairResource($repair);
    }

    public function confirm(Request $request,Repair $repair)
    {
        $repair->rp_confirm = 1;
        $repair->save();

        return response()->json([
            'save' => true,
            'message' => 'ยืนยันข้อมูลการซ่อมเรียบร้อย'
        ],200);
    }

    public function notConfirm(Request $request,Repair $repair)
    {
        $request->validate([
            'rp_note' => 'required'
        ]);
        
        $repair->rp_confirm = 0;
        $repair->rp_note = $request->rp_note;
        $repair->save();

        return response()->json([
            'save' => true,
            'message' => 'ยืนยันข้อมูลการซ่อมเรียบร้อย'
        ],200);
    }
}
