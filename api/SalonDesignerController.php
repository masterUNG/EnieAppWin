<?php

namespace App\Http\Controllers\Api\Salon;

use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\SalonDesigner;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\ImageManagerStatic;
use App\Http\Resources\SalonDesignerResource;

class SalonDesignerController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $designers = SalonDesigner::select('id','sd_nick_name','sd_mobile','sd_status')
                        ->where('salon_id',Auth::guard('salon-api')->user()->id);

        if(!empty($request->searchTerm))
        {
            $designers = $designers
                            ->where('sd_nick_name','LIKE',"%{$request->searchTerm}%")
                            ->orWhere('sd_first_name','LIKE',"%{$request->searchTerm}%")
                            ->orWhere('sd_mobile','LIKE',"%{$request->searchTerm}%");
        }

        if(!empty($request->status))
        {
            $designers = $designers
                            ->where('sd_status',$request->status);
        }

        $designers = $designers->get();

        return SalonDesignerResource::collection($designers);
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
            'sd_mobile' => 'required|unique:salon_designers,username',
            'password' => 'required',
            'sd_nick_name' => 'required',
            'sd_first_name' => 'required',
            'sd_last_name' => 'required',
            'sd_status' => 'required',
            'sd_address' => 'required',
            'province_id' => 'required',
            'district_id' => 'required',
            'subdistrict_id' => 'required',
            'sd_zip_code' => 'required'
        ]);

        $namePicture = "";

        if ($request->sd_picture) {
            
            $img   = ImageManagerStatic::make($request->sd_picture)->encode('jpg');
            $namePicture  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('salon')->put('like_salon/designers/'.$namePicture, $img);
        }

        $designer = SalonDesigner::create([
            'sd_code'           => $request->sd_code,
            'username'          => $request->username,
            'password'          => $request->password,
            'salon_id'          => Auth::guard('salon-api')->user()->id,
            'sd_nick_name'      => $request->sd_nick_name,
            'sd_first_name'     => $request->sd_first_name,
            'sd_last_name'      => $request->sd_last_name,
            'sd_introduce'      => $request->sd_introduce,
            'sd_mobile'         => $request->sd_mobile,
            'sd_line_id'        => $request->sd_line_id,
            'sd_note'           => $request->sd_note,
            'sd_status'         => $request->sd_status,
            'sd_picture'        => $namePicture,
            'sd_score'          => $request->sd_score,
            'sd_point'          => $request->sd_point,
            'sd_hot_designer'   => $request->sd_hot_designer,
            'sd_on_website'     => $request->sd_on_website,
            'sd_con_qty'        => $request->sd_con_qty,
            'sd_com'            => $request->sd_com,
            'sd_address'        => $request->sd_address,
            'sd_village'        => $request->sd_village,
            'sd_alley'          => $request->sd_alley,
            'sd_road'           => $request->sd_road,
            'country_id'        => $request->country_id,
            'province_id'       => $request->province_id,
            'district_id'       => $request->district_id,
            'subdistrict_id'    => $request->subdistrict_id,
            'sd_zip_code'       => $request->sd_zip_code,
        ]);

        return new SalonDesignerResource($designer);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SalonDesigner  $salonDesigner
     * @return \Illuminate\Http\Response
     */
    public function show(SalonDesigner $salonDesigner)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SalonDesigner  $salonDesigner
     * @return \Illuminate\Http\Response
     */
    public function edit(SalonDesigner $salonDesigner)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\SalonDesigner  $salonDesigner
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, SalonDesigner $salonDesigner)
    {
        $request->validate([
            'sd_mobile' => 'required|unique:salon_designers,username,'.$salonDesigner->id,
            'password' => 'required',
            'sd_nick_name' => 'required',
            'sd_first_name' => 'required',
            'sd_last_name' => 'required',
            'sd_status' => 'required',
            'sd_address' => 'required',
            'province_id' => 'required',
            'district_id' => 'required',
            'subdistrict_id' => 'required',
            'sd_zip_code' => 'required'
        ]);

        $namePicture = $salonDesigner->sd_picture;

        if ($request->sd_picture) {
            $img   = ImageManagerStatic::make($request->sd_picture)->encode('jpg');
            $namePicture  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('salon')->put('like_salon/designers/'.$namePicture, $img);
        }

        $salonDesigner->update([
            'sd_code'           => $request->sd_code,
            'username'          => $request->sd_mobile,
            'password'          => $request->password,
            'salon_id'          => Auth::guard('salon-api')->user()->id,
            'sd_nick_name'      => $request->sd_nick_name,
            'sd_first_name'     => $request->sd_first_name,
            'sd_last_name'      => $request->sd_last_name,
            'sd_introduce'      => $request->sd_introduce,
            'sd_mobile'         => $request->sd_mobile,
            'sd_line_id'        => $request->sd_line_id,
            'sd_note'           => $request->sd_note,
            'sd_status'         => $request->sd_status,
            'sd_picture'        => $namePicture,
            'sd_score'          => $request->sd_score,
            'sd_point'          => $request->sd_point,
            'sd_hot_designer'   => $request->sd_hot_designer,
            'sd_on_website'     => $request->sd_on_website,
            'sd_con_qty'        => $request->sd_con_qty,
            'sd_com'            => $request->sd_com,
            'sd_address'        => $request->sd_address,
            'sd_village'        => $request->sd_village,
            'sd_alley'          => $request->sd_alley,
            'sd_road'           => $request->sd_road,
            'country_id'        => $request->country_id,
            'province_id'       => $request->province_id,
            'district_id'       => $request->district_id,
            'subdistrict_id'    => $request->subdistrict_id,
            'sd_zip_code'       => $request->sd_zip_code,
        ]);


        return new SalonDesignerResource($salonDesigner);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SalonDesigner  $salonDesigner
     * @return \Illuminate\Http\Response
     */
    public function destroy(SalonDesigner $salonDesigner)
    {
        //
    }
}
