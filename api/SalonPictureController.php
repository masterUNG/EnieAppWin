<?php

namespace App\Http\Controllers\Api\Salon;

use Illuminate\Support\Str;
use App\Models\SalonPicture;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\ImageManagerStatic;
use App\Http\Resources\SalonPictureResource;

class SalonPictureController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {

        $salon_pictures = SalonPicture::where('salon_id',Auth::guard('salon-api')->id())->get();

        return SalonPictureResource::collection($salon_pictures);
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
        $salon_picture = new SalonPicture();

        $picture = "";

        if ($request->sp_picture) {
            $img   = ImageManagerStatic::make($request->sp_picture)->encode('png');
            $picture  = date('YmdHis').Str::random() . '.png';
            Storage::disk('salonPicture')->put($picture, $img);
        }
        
        $salon_picture->sp_picture = $picture;
        $salon_picture->salon_id = Auth::guard('salon-api')->id();
        $salon_picture->save();

        return new SalonPictureResource($salon_picture);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SalonPicture  $salonPicture
     * @return \Illuminate\Http\Response
     */
    public function show(SalonPicture $salonPicture)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SalonPicture  $salonPicture
     * @return \Illuminate\Http\Response
     */
    public function edit(SalonPicture $salonPicture)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\SalonPicture  $salonPicture
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, SalonPicture $salonPicture)
    {
        

        $picture = $salonPicture->sp_picture;

        if ($request->sp_picture) {
            $img   = ImageManagerStatic::make($request->sp_picture)->encode('png');
            $picture  = date('YmdHis').Str::random() . '.png';
            Storage::disk('salonPicture')->put($picture, $img);

            if(!empty($salonPicture->sp_picture))
            {
                @Storage::disk('salonPicture')->delete($salonService->sp_picture);
            }
        }
        
        $salonPicture->sp_picture = $picture;
        $salonPicture->salon_id = Auth::guard('salon-api')->id();
        $salonPicture->save();

        return new SalonPictureResource($salonPicture);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SalonPicture  $salonPicture
     * @return \Illuminate\Http\Response
     */
    public function destroy(SalonPicture $salonPicture)
    {
        //
    }
}
