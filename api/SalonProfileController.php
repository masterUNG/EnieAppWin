<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Salon;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Http\Resources\SalonResource;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\ImageManagerStatic;

class SalonProfileController extends Controller
{
    public function changePassword(Request $request)
    {
        $user = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
        $request->validate([
            'passwordOld' => 'required|min:4',
            'passwordNew' => 'required|min:4'
        ]);

        if (!(Hash::check($request->passwordOld, $user->password))) {
            return response()->json([
                "message" => "The given data was invalid.",
                "errors" => [
                    "passwordOld" => [
                        "รหัสผ่านเดิมไม่ตรงกับระบบ กรุณาลองใหม่อีกครั้ง"
                    ],
                ]
            ]);
        }

        if(strcmp($request->passwordOld, $request->passwordNew) == 0){
            return response()->json([
                "message" => "The given data was invalid.",
                "errors" => [
                    "passwordNew" => [
                        "รหัสผ่านใหม่ และ รหัสผ่านเดิม ไม่ควรเหมือนกัน กรุณาเปลี่ยนรหัส"
                    ],
                ]
            ]);
        }


        //Change Password
        $user->password = Hash::make($request->passwordNew);
        $user->save();

        Auth::guard('salon-api')->user()->token()->revoke();


        return response()->json([
            'save' => true,
            'message' => 'แก้ไขรหัสผ่านเรียบร้อย',
        ]);
    }

    public function update(Request $request)
    {
        
        $request->validate([
            'salon_name' => 'required',
            'salon_contract_name' => 'required',
            'salon_address' => 'required',
            'province_id' => 'required',
            'district_id' => 'required',
            'subdistrict_id' => 'required',
            'salon_zip_code' => 'required'
        ]);
        
        $salon = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
        $salon->salon_contract_name = $request->salon_contract_name;
        $salon->salon_name = $request->salon_name;
        $salon->salon_address = $request->salon_address;
        $salon->salon_village = $request->salon_village;
        $salon->salon_alley = $request->salon_alley;
        $salon->salon_road = $request->salon_road;
        $salon->province_id = $request->province_id;
        $salon->district_id = $request->district_id;
        $salon->subdistrict_id = $request->subdistrict_id;
        $salon->salon_zip_code = $request->salon_zip_code;
        $salon->save();

        return response()->json([
            'save' => true,
            'data' => new SalonResource($salon)
        ]);
    }

    public function picture(Request $request)
    {
        if (!$request->salon_logo) {
            return null;
        }

        $img   = ImageManagerStatic::make($request->salon_logo)->encode('png');
        $name  = date('YmdHis').Str::random() . '.png';
        Storage::disk('logo')->put($name, $img);
        

        $salon = Salon::findOrFail(Auth::guard('salon-api')->user()->id);
        $salon->salon_logo = $name;
        $salon->save();

        return response()->json([
            'save' => true,
            'data' => new SalonResource($salon)
        ]);
    }
}
