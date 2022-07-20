<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Province;
use App\Http\Controllers\Controller;
use App\Models\District;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class AddressController extends Controller
{

    public function ProvinceAll()
    {
        $data = DB::table("provinces")
        ->where('province_status',1)
        ->get();
        return response()->json($data)->header('Content-Type','text/javascript; charset=utf-8');
    }

    public function DistrictByProvince(Request $request)
    {
        $province = Province::findOrFail($request->id);

        $data = DB::table("districts")
        ->select('id','district_code','district_name_th','district_name_en','district_status','province_id')
        ->where('district_status',1)
        ->where('districts.province_id' , $province->id)
        ->get();

        return response()->json($data)->header('Content-Type','text/javascript; charset=utf-8');
    }

    public function SubDistrictByDistrict(Request $request)
    {
        $district = District::findOrFail($request->id);

        $data = DB::table("sub_districts")
        ->select('id','sub_district_code','sub_district_name_th','sub_district_name_en','sub_district_status','sub_district_zip_code','district_id')
        ->where('sub_district_status',1)
        ->where('sub_districts.district_id' , $district->id)
        ->get();

        return response()->json($data)->header('Content-Type','text/javascript; charset=utf-8');
    }
}
