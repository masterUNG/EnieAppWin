<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Salon;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Intervention\Image\ImageManagerStatic;

class SalonAuthController extends Controller
{

    public function login(Request $request)
    {
        //dd($request->all());
        $validator = Validator::make($request->all(),[
            'username' => 'required',
            'password' => 'required'
        ]);

        if($validator->fails()){
            return response([
                'error' => $validator->errors()->all()
            ]);
        }

        if(auth()->guard('salon')->attempt(['username' => $request->username,'password' => $request->password])){
            
            config(['auth.guards.api.provider' => 'salon']);

            $salon = Salon::select('salons.*')->find(auth()->guard('salon')->user()->id);
            
            $success = $salon;
            
            $success['token'] = $salon->createToken('SalonApp',['salon'])->accessToken;
            

            return response()->json([$success,200])->header('Content-Type','text/javascript; charset=utf-8');
        }
        else 
        {
            
            return response()->json(['error' => ['Username and Password are wrong.']],200);
        }
    }

    public function register(Request $request)
    {

        //dd($request->all());

        // $request->validate([
        //     'salon_name' => 'required|unique:salons,salon_name',
        //     'salon_phone' => 'required|unique:salons,username',
        //     'password' => 'required',
        //     'salon_address' => 'required',
        //     'province_id' => 'required',
        //     'district_id' => 'required',
        //     'subdistrict_id' => 'required',
        //     'salon_zip_code' => 'required'
        // ],[
        //     'salon_name.required' => 'กรุณากรอกชื่อร้าน',
        //     'salon_name.unique' => 'ชื่อร้านซ้ำ',
        //     'salon_phone.required' => 'กรุณากรอกเบอร์โทรศัพท์',
        //     'salon_phone.unique' => 'เบอร์โทรศัพท์ซ้ำ',
        //     'password.required' => 'กรุณากรอกรหัสผ่าน',
        //     'salon_address.required' => 'กรุณากรอกที่อยู่',
        //     'province_id.required' => 'กรุณาเลือกจังหวัด',
        //     'district_id.required' => 'กรุณาเลือกอำเภอ',
        //     'subdistrict_id.required' => 'กรุณาเลือกตำบล',
        //     'salon_zip_code.required' => 'กรุณากรอกรหัสไปรษณีย์'
        // ]);

        //dd($request->all());

        $salon = Salon::create([
            'salon_gen' => 0,
            'salon_id_card' => $request->salon_id_card,
            'username' => $request->salon_phone,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'sale_id' => 1,
            'salon_type' => 1,
            'salon_contract_name' => '-',
            'salon_web_code' => '-',
            'salon_name' => $request->salon_name,
            'salon_phone' => $request->salon_phone,
            'salon_phone2' => '-',
            'salon_address' => $request->salon_address,
            'salon_village' => $request->salon_village,
            'salon_alley' => $request->salon_alley,
            'salon_road' => $request->salon_road,
            'country_id' => 1,
            'province_id' => $request->province_id,
            'district_id' => $request->district_id,
            'subdistrict_id' => $request->subdistrict_id,
            'salon_zip_code' => $request->salon_zip_code,
            'salon_credit_limited' => 10000,
            'salon_due_total' => 0,
            'salon_order_total' => 0,
            'salon_pay_total' => 0,
            'salon_point' => 0,
            'salon_scope' => 0,
            'salon_qty' => 0,
            'salon_last_order' => null,
            'salon_avatar' => null,
            'salon_logo' => null,
            'salon_main_picture' => null,
            'salon_slogan' => null,
            'salon_keyword' => null,
            'salon_line_id' => $request->salon_line_id,
            'salon_facebook' => null,
            'salon_ig' => null,
            'salon_youtube' => null,
            'salon_url' => null,
            'salon_latitude' => null,
            'salon_longitude' => null,
            'salon_open_time' => null,
            'salon_close_time' => null,
            'salon_status' => 1,
            'salon_hot' => 0,
            'salon_on_website' => 0,
            'salon_token_line' => null,
            'salon_persuader' => $request->salon_persuader,
            'created_by' => 1,
            'updated_by' => 1
        ]);

        $name = "";

        if ($request->salon_main_picture) {
            
            $img   = ImageManagerStatic::make($request->salon_main_picture)->encode('jpg');
            $name  = date('YmdHis').Str::random() . '.jpg';
            
            Storage::disk('salon')->makeDirectory('main/'.$salon->id,777);
            Storage::disk('salon')->put('main/'.$salon->id.'/'.$name, $img);
        }

        $salon->salon_main_picture = $name;
        $salon->salon_web_code = sprintf("A%05s",$salon->id);
        $salon->save();

        //dd($salon);

		echo "true";


    }

    public function getUserWhereUser(Request $request)
    {
        //dd($request->all());

        $salon = DB::table('salons')->where('username',$request->username)->get();

        return response()->json($salon)->header('Content-Type','text/javascript; charset=utf-8');
    }
}
