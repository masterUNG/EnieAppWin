<?php

namespace App\Http\Controllers\Api\Salon;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class ReportController extends Controller
{
    public function projects()
    {
        $projects = DB::table('salon_orders')
                        ->select(
                            'salon_projects.spj_name',
                            DB::raw('sum(salon_orders.so_net_total) as ord'),
                            DB::raw('sum(salon_payments.salon_pay_amount) as pay')
                        )
                        ->join('salon_projects','salon_projects.id','=','salon_orders.salon_project_id')
                        ->leftJoin('salon_payments','salon_payments.salon_order_id','=','salon_orders.id')
                        ->where('salon_orders.salon_id',Auth::guard('salon-api')->user()->id)
                        ->where('salon_orders.so_process_money','<>',0)
                        ->where('salon_projects.spj_status',1)
                        ->groupBy('salon_projects.spj_name')
                        ->get();
        $sum = DB::table('salon_orders')
                    ->select(
                        DB::raw('sum(salon_orders.so_net_total) as ord'),
                        DB::raw('sum(salon_payments.salon_pay_amount) as pay')
                    )
                    ->join('salon_projects','salon_projects.id','=','salon_orders.salon_project_id')
                    ->leftJoin('salon_payments','salon_payments.salon_order_id','=','salon_orders.id')
                    ->where('salon_orders.salon_id',Auth::guard('salon-api')->user()->id)
                    ->where('salon_orders.so_process_money','<>',0)
                    ->where('salon_projects.spj_status',1)
                    ->first();

        return response()->json([
            'projects' => $projects,
            'sum' => $sum
        ]);
    }
}
