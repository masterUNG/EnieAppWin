<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\SalonJob;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Http\Resources\SalonJobResource;
use Intervention\Image\ImageManagerStatic;

class SalonJobController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $pictures = SalonJob::where('salon_id',Auth::guard('salon-api')->id())->get();

        return SalonJobResource::collection($pictures);
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
        if ($request->sj_picture) {
            
            $img   = ImageManagerStatic::make($request->sj_picture)->encode('jpg');
            $name  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('job')->put($name, $img);

            $salonJob = SalonJob::create([
                'salon_id' => Auth::guard('salon-api')->id(),
                'sj_picture' => $name,
            ]);

            return new SalonJobResource($salonJob);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SalonJob  $salonJob
     * @return \Illuminate\Http\Response
     */
    public function show(SalonJob $salonJob)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SalonJob  $salonJob
     * @return \Illuminate\Http\Response
     */
    public function edit(SalonJob $salonJob)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\SalonJob  $salonJob
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, SalonJob $salonJob)
    {
        if ($request->sj_picture) {
            $img   = ImageManagerStatic::make($request->sj_picture)->encode('jpg');
            $name  = date('YmdHis').Str::random() . '.jpg';
            Storage::disk('job')->put($name, $img);

            if(!empty($salonJob->sj_picture))
            {
                @Storage::disk('job')->delete($salonJob->sj_picture);
            }

            $salonJob->update([
                'sj_picture' => $name,
            ]);

            return new SalonJobResource($salonJob);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SalonJob  $salonJob
     * @return \Illuminate\Http\Response
     */
    public function destroy(SalonJob $salonJob)
    {
        //
    }
}
