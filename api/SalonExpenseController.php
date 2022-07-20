<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\SalonExpense;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\SalonExpenseResource;

class SalonExpenseController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $expenses = SalonExpense::where('salon_id',Auth::guard('salon-api')->id());

        if(!empty($request->month)){
            $expenses = $expenses
                            ->whereMonth('se_date',$request->month);
        }

        if(!empty($request->year)){
            $expenses = $expenses
                            ->whereYear('se_date',$request->year);
        }

        $expenses = $expenses
                        ->where('se_status',1)
                        ->orderBy('id','desc')
                        ->get();

        return SalonExpenseResource::collection($expenses);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        
        $request->validate([
            'se_date'   => 'required',
            'se_name'   => 'required',
            'se_price'  => 'required|numeric',
            'se_qty'    => 'required|integer',
        ],[
            'se_date.required'  => 'กรุณากรอกวันที่',
            'se_name.required'  => 'กรุณากรอกหัวข้อ',
            'se_price.required' => 'กรุณากรอกค่าใช้จ่าย',
            'se_price.numeric'  => 'กรุณากรอกค่าใช้จ่ายเป็นตัวเลขเท่านั้น',
            'se_qty.required'   => 'กรุณากรอกจำนวน',
            'se_qty.numeric'    => 'กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น',
        ]);


        $expense = SalonExpense::create([
            'salon_id' => Auth::guard('salon-api')->id(),
            'se_date' => $request->se_date,
            'se_name' => $request->se_name,
            'se_desc' => $request->se_desc,
            'se_price' => $request->se_price,
            'se_qty' => $request->se_qty,
            'se_amount' => $request->se_price * $request->se_qty,
            'se_status' => 1,
            'created_by' => 1,
            'updated_by' => 1
        ]);

        return $expense;

        return new SalonExpenseResource($expense);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SalonExpense  $salonExpense
     * @return \Illuminate\Http\Response
     */
    public function show(SalonExpense $salonExpense)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SalonExpense  $salonExpense
     * @return \Illuminate\Http\Response
     */
    public function edit(SalonExpense $salonExpense)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\SalonExpense  $salonExpense
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, SalonExpense $salonExpense)
    {
        
        $request->validate([
            'se_date'   => 'required',
            'se_name'   => 'required',
            'se_price'  => 'required|numeric',
            'se_qty'    => 'required|integer',
        ],[
            'se_date.required'  => 'กรุณากรอกวันที่',
            'se_name.required'  => 'กรุณากรอกหัวข้อ',
            'se_price.required' => 'กรุณากรอกค่าใช้จ่าย',
            'se_price.numeric'  => 'กรุณากรอกค่าใช้จ่ายเป็นตัวเลขเท่านั้น',
            'se_qty.required'   => 'กรุณากรอกจำนวน',
            'se_qty.numeric'    => 'กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น',
        ]);

        $salonExpense->update([
            'se_date' => $request->se_date,
            'se_name' => $request->se_name,
            'se_desc' => $request->se_desc,
            'se_price' => $request->se_price,
            'se_qty' => $request->se_qty,
            'se_amount' => $request->se_price * $request->se_qty,
        ]);

        return new SalonExpenseResource($salonExpense);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SalonExpense  $salonExpense
     * @return \Illuminate\Http\Response
     */
    public function destroy(SalonExpense $salonExpense)
    {
        //
    }

    public function report(Request $request)
    {
        
        $datacount = null;
        $dataSum = null;
        $reports = [];

        if(!empty($request->month) && !empty($request->year))
        {
            $datacount = SalonExpense::where('salon_id',Auth::guard('salon-api')->id())
                                                ->whereMonth('se_date',$request->month)
                                                ->whereYear('se_date',$request->year)
                                                ->where('se_status',1)
                                                ->count();
            
            $dataSum = SalonExpense::select(
                                            DB::raw("SUM(se_amount) as sum")
                                        )
                                        ->where('salon_id',Auth::guard('salon-api')->id())
                                        ->whereMonth('se_date',$request->month)
                                        ->whereYear('se_date',$request->year)
                                        ->where('se_status',1)
                                        ->first();

            $reports = SalonExpense::where('salon_id',Auth::guard('salon-api')->id())
                                ->whereMonth('se_date',$request->month)
                                ->whereYear('se_date',$request->year)
                                ->where('se_status',1)
                                ->get();

        }

        return response()->json([
            'datacount' => $datacount,
            'dataSum' => $dataSum,
            'reports' => SalonExpenseResource::collection($reports)
        ]);
    }
}
