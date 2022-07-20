<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\HdJob;
use App\Models\Province;
use App\Models\HdPosition;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\HdJobResource;
use App\Http\Resources\ProvinceResource;
use App\Http\Resources\HdPositionResource;

class HdjobController extends Controller
{
    public function lists(Request $request)
    {
        $lists = HdJob::where('salon_id',Auth::guard('salon-api')->id())
                    ->where('hd_job_status',$request->status)
                    ->orderBy('created_at','desc')
                    ->get();

        return HdJobResource::collection($lists);
    }

    public function show(HdJob $hd_job)
    {
        return new HdJobResource($hd_job);
    }

    public function store(Request $request)
    {
        $request->validate([
            'hd_position_id'    => 'required',
            'hd_job_salary'     => 'required',
            'hd_job_status'     => 'required',
        ]);

        $hdJob = HdJob::create(
            [
                'salon_id'          => Auth::guard('salon-api')->id(),
                'hd_position_id'    => $request->hd_position_id,
                'hd_job_salary'     => $request->hd_job_salary,
                'hd_job_status'     => $request->hd_job_status,
                'hd_job_desc'       => $request->hd_job_desc,
                'hd_job_address'    => $request->hd_job_address,
                'subdistrict_id'    => $request->subdistrict_id,
                'district_id'       => $request->district_id,
                'province_id'       => $request->province_id,
                'hd_job_zip_code'   => $request->hd_job_zip_code,
            ]
            );

        return new HdJobResource($hdJob);
    }

    public function cancel(HdJob $hd_job)
    {
        $hd_job->hd_job_status = 0;
        $hd_job->save();

        return new HdJobResource($hd_job);
    }

    public function update(Request $request, HdJob $hd_job)
    {
        $request->validate([
            'hd_position_id'    => 'required',
            'hd_job_salary'     => 'required',
            'hd_job_status'     => 'required',
        ]);

        $hd_job->update([
                'hd_position_id'    => $request->hd_position_id,
                'hd_job_salary'     => $request->hd_job_salary,
                'hd_job_status'     => $request->hd_job_status,
                'hd_job_desc'       => $request->hd_job_desc,
                'hd_job_address'    => $request->hd_job_address,
                'subdistrict_id'    => $request->subdistrict_id,
                'district_id'       => $request->district_id,
                'province_id'       => $request->province_id,
                'hd_job_zip_code'   => $request->hd_job_zip_code,
        ]);

        return new HdJobResource($hd_job);
    }

    public function all(Request $request)
    {
        $hd_jobs = HdJob::select(
                    'hd_jobs.id',
                    'hd_jobs.hd_job_desc',
                    'hd_jobs.hd_job_salary',
                    'hd_positions.hd_posi_name',
                    'salons.salon_name',
                    'salons.salon_phone',
                    'salons.salon_address',
                    'salons.salon_village',
                    'salons.salon_alley',
                    'salons.salon_road',
                    'provinces.province_name_th',
                    'districts.district_name_th',
                    'sub_districts.sub_district_name_th',
                    'salons.salon_zip_code',
                    'hd_jobs.created_at'
                )
                ->join('hd_positions','hd_jobs.hd_position_id','=','hd_positions.id')
                ->join('salons','hd_jobs.salon_id','=','salons.id')
                ->leftJoin('provinces','hd_jobs.province_id','=','provinces.id')
                ->leftJoin('districts','hd_jobs.district_id','=','districts.id')
                ->leftJoin('sub_districts','hd_jobs.subdistrict_id','=','sub_districts.id')
                ->where('hd_job_status',1);

        if($request->searchTerm)
        {
        $searchTerm = $request->searchTerm;

        $hd_jobs = $hd_jobs
                        ->where(function($query) use ($searchTerm){
                            return $query
                                        ->where('hd_posi_name','LIKE',"%{$searchTerm}%")
                                        ->orWhere('province_name_th','LIKE',"%{$searchTerm}%")
                                        ->orWhere('district_name_th','LIKE',"%{$searchTerm}%")
                                        ->orWhere('hd_job_salary','LIKE',"%{$searchTerm}%");
                        });
        }

        if($request->province)
        {
            $hd_jobs = $hd_jobs
                        ->where('salons.province_id',$request->province);
        }

        if($request->position)
        {
            $hd_jobs = $hd_jobs
                        ->where('hd_jobs.hd_position_id',$request->position);
        }

        $hd_jobs = $hd_jobs
                    ->orderBy('hd_jobs.created_at','desc')
                    ->paginate(100);

        $positions = HdPosition::where('hd_posi_status',1)->orderBy('hd_posi_name','asc')->get();

        $provinces = Province::where('province_status',1)->orderBy('province_name_th','asc')->get();

        return response()->json([
            'hd_jobs' => HdJobResource::collection($hd_jobs),
            'positions' => HdPositionResource::collection($positions),
            'provinces' => ProvinceResource::collection($provinces)
        ]);
    }
}