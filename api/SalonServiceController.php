<?php

namespace App\Http\Controllers\Api\Salon;

use Illuminate\Support\Str;
use App\Models\SalonService;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\ImageManagerStatic;
use App\Http\Resources\SalonServiceResource;

class SalonServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $services = SalonService::where('salon_id',Auth::guard('salon-api')->user()->id);

        if(!empty($request->searchTerm)){
            $services = $services
                            ->where('sv_name','LIKE',"%{$request->searchTerm}%");
        }

        if($request->process == 1){
            $services = $services
                            ->where('sv_status',1);
        }else{
            $services = $services
                            ->where('sv_status',0);
        }

        $services = $services
                        ->orderBy('id','DESC')
                        ->get();
        return SalonServiceResource::collection($services);
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
            'slsv_category_id' => 'required|integer',
            'sv_date' => 'required',
            'sv_name' => 'required',
            'sv_price_orq' => 'required|integer',
            'sv_price' => 'required|integer',
            'sv_designer_com' => 'required|integer',
            'sv_status' => 'required|integer',
            'sv_pro_show' => 'required|integer',
            'sv_pro_enie' => 'required|integer',
            'sv_on_like' => 'required|integer',
        ],[
            'slsv_category_id.required' => 'กรุณาเลือกประเภท',
            'slsv_category_id.integer' => 'กรุณาเลือกประเภทที่มีให้เท่านั้น',
            'sv_date.required' => 'กรุณากรอก วันที่',
            'sv_name.required' => 'กรุณากรอก ชื่อ',
            'sv_price_orq.required' => 'กรุณากรอกจำนวนเงิน',
            'sv_price_orq.integer' => 'กรุณากรอกจำนวนเงินเป็นตัวเลขเท่านั้น',
            'sv_price.required' => 'กรุณากรอกจำนวนเงิน',
            'sv_price.integer' => 'กรุณากรอกจำนวนเงินเป็นตัวเลขเท่านั้น',
            'sv_designer_com.required' => 'กรุณากรอกค่าคอมมิชชั่น',
            'sv_designer_com.integer' => 'กรุณากรอกค่าคอมมิชชั่นเป็นตัวเลขเท่านั้น',
            'sv_status.required' => 'กรุณาเลือกสถานะ',
            'sv_status.integer' => 'กรุณาเลือกสถานะที่มีให้เท่านั้น',
            'sv_pro_show.required' => 'กรุณาเลือกสถานะโปรประจำร้าน',
            'sv_pro_show.integer' => 'กรุณาเลือกสถานะโปรประจำร้านที่มีให้เท่านั้น',
            'sv_pro_enie.required' => 'กรุณาเลือกสถานะโปรประจำเดือน',
            'sv_pro_enie.integer' => 'กรุณาเลือกสถานะโปรประจำเดือนที่มีให้เท่านั้น',
            'sv_on_like.required' => 'กรุณาเลือกสถานะแสดง Like Salon ',
            'sv_on_like.integer' => 'กรุณาเลือกสถานะแสดง Like Salon ที่มีให้เท่านั้น',
        ]);

        $namePicture = "";

        if ($request->sv_picture) {
            $img   = ImageManagerStatic::make($request->sv_picture)->encode('jpg');
            $namePicture  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('service')->makeDirectory(Auth::guard('salon-api')->id(),777);
            Storage::disk('service')->put(Auth::guard('salon-api')->id().'/'.$namePicture, $img);
        }

        $salonService = new SalonService();

        $salonService->slsv_category_id = $request->slsv_category_id;
        $salonService->salon_id = Auth::guard('salon-api')->id();
        $salonService->sv_date = $request->sv_date;
        $salonService->sv_name = $request->sv_name;
        $salonService->sv_price_orq = $request->sv_price_orq;
        $salonService->sv_price = $request->sv_price;
        $salonService->sv_designer_com = $request->sv_designer_com;
        $salonService->sv_picture = $namePicture;
        $salonService->sv_attend_qty = $request->sv_attend_qty;
        $salonService->sv_status = $request->sv_status;
        $salonService->sv_pro_show = $request->sv_pro_show;
        $salonService->sv_pro_enie = $request->sv_pro_enie;
        $salonService->sv_on_like = $request->sv_on_like;
        $salonService->created_by = 1;
        $salonService->updated_by = 1;
        $salonService->save();
        
        return new SalonServiceResource($salonService);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SalonService  $salonService
     * @return \Illuminate\Http\Response
     */
    public function show(SalonService $salonService)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SalonService  $salonService
     * @return \Illuminate\Http\Response
     */
    public function edit(SalonService $salonService)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\SalonService  $salonService
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, SalonService $salonService)
    {
        $request->validate([
            'slsv_category_id' => 'required|integer',
            'sv_date' => 'required',
            'sv_name' => 'required',
            'sv_price_orq' => 'required|integer',
            'sv_price' => 'required|integer',
            'sv_designer_com' => 'required|integer',
            'sv_status' => 'required|integer',
            'sv_pro_show' => 'required|integer',
            'sv_pro_enie' => 'required|integer',
            'sv_on_like' => 'required|integer',
        ],[
            'slsv_category_id.required' => 'กรุณาเลือกประเภท',
            'slsv_category_id.integer' => 'กรุณาเลือกประเภทที่มีให้เท่านั้น',
            'sv_date.required' => 'กรุณากรอก วันที่',
            'sv_name.required' => 'กรุณากรอก ชื่อ',
            'sv_price_orq.required' => 'กรุณากรอกจำนวนเงิน',
            'sv_price_orq.integer' => 'กรุณากรอกจำนวนเงินเป็นตัวเลขเท่านั้น',
            'sv_price.required' => 'กรุณากรอกจำนวนเงิน',
            'sv_price.integer' => 'กรุณากรอกจำนวนเงินเป็นตัวเลขเท่านั้น',
            'sv_designer_com.required' => 'กรุณากรอกค่าคอมมิชชั่น',
            'sv_designer_com.integer' => 'กรุณากรอกค่าคอมมิชชั่นเป็นตัวเลขเท่านั้น',
            'sv_status.required' => 'กรุณาเลือกสถานะ',
            'sv_status.integer' => 'กรุณาเลือกสถานะที่มีให้เท่านั้น',
            'sv_pro_show.required' => 'กรุณาเลือกสถานะโปรประจำร้าน',
            'sv_pro_show.integer' => 'กรุณาเลือกสถานะโปรประจำร้านที่มีให้เท่านั้น',
            'sv_pro_enie.required' => 'กรุณาเลือกสถานะโปรประจำเดือน',
            'sv_pro_enie.integer' => 'กรุณาเลือกสถานะโปรประจำเดือนที่มีให้เท่านั้น',
            'sv_on_like.required' => 'กรุณาเลือกสถานะแสดง Like Salon ',
            'sv_on_like.integer' => 'กรุณาเลือกสถานะแสดง Like Salon ที่มีให้เท่านั้น',
        ]);

        $namePicture = $salonService->sv_picture;

        if ($request->sv_picture) {
            $img   = ImageManagerStatic::make($request->sv_picture)->encode('jpg');
            $namePicture  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('service')->makeDirectory(Auth::guard('salon-api')->id(),777);
            Storage::disk('service')->put(Auth::guard('salon-api')->id().'/'.$namePicture, $img);

            if($salonService->id > 0 && !empty($salonService->sv_picture))
            {
                @Storage::disk('service')->delete(Auth::guard('salon-api')->id().'/'.$salonService->sv_picture);
            }
        }

        $salonService->slsv_category_id = $request->slsv_category_id;
        $salonService->sv_date = $request->sv_date;
        $salonService->sv_name = $request->sv_name;
        $salonService->sv_price_orq = $request->sv_price_orq;
        $salonService->sv_price = $request->sv_price;
        $salonService->sv_designer_com = $request->sv_designer_com;
        $salonService->sv_picture = $namePicture;
        $salonService->sv_attend_qty = $request->sv_attend_qty;
        $salonService->sv_status = $request->sv_status;
        $salonService->sv_pro_show = $request->sv_pro_show;
        $salonService->sv_pro_enie = $request->sv_pro_enie;
        $salonService->sv_on_like = $request->sv_on_like;
        $salonService->save();

        return new SalonServiceResource($salonService);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SalonService  $salonService
     * @return \Illuminate\Http\Response
     */
    public function destroy(SalonService $salonService)
    {
        //
    }
}
