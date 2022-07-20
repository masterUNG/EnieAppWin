<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\SalonEvent;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\SalonEventPerson;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use App\Http\Resources\SalonEventResource;
use Intervention\Image\ImageManagerStatic;
use App\Http\Resources\SalonEventPersonResource;

class SalonEventController extends Controller
{

    public function lists()
    {
        $events = SalonEvent::where('sev_status',1)->get();

        return SalonEventResource::collection($events);
    }

    public function show(SalonEvent $salon_event)
    {
        return new SalonEventResource($salon_event);
    }

    public function persons()
    {
        $persons = SalonEventPerson::where('salon_id',Auth::guard('salon-api')->id())->orderBy('id','desc')->get();

        return SalonEventPersonResource::collection($persons);
    }

    public function register(Request $request,SalonEvent $salon_event)
    {
        $validator = Validator::make($request->all(),[
            'salon_event_day_id' => 'required',
            'sevp_name' => 'required'
        ],[
            'salon_event_day_id.required' => 'กรุณาเลือกรอบการอบรม',
            'sevp_name.required' => 'กรุณากรอกชื่อในใบประกาศ'
        ]);
        
        if($validator->fails()){
            return response([
                'error' => $validator->errors()->all()
            ]);
        }

        $sevp                       = new SalonEventPerson();
        $sevp->salon_event_id       = $salon_event->id;
        $sevp->salon_id             = Auth::guard('salon-api')->id();
        $sevp->tech_id              = $salon_event->tech_id;
        $sevp->salon_event_day_id   = $request->salon_event_day_id;
        $sevp->sevp_note            = $request->sevp_note;
        $sevp->sevp_name            = $request->sevp_name;
        $sevp->sevp_fee             = $salon_event->sev_fee;
        $sevp->sevp_process         = $salon_event->sev_fee > 0 ? 3 : 1;
        $sevp->sevp_status          = 1;
        $sevp->save();

        

        return response([
            'save' => true,
            'message' => 'คุณสมัครการอบรมเรียบร้อยแล้ว',
            'data' => new SalonEventPersonResource($sevp)
        ]);
    }

    public function uploadSlip(Request $request,SalonEventPerson $salon_event_person)
    {
        $validator = Validator::make($request->all(),[
            'sevp_slip' => 'required|image',
            'sevp_pay_day' => 'required',
            'sevp_pay_time' => 'required'
        ],[
            'sevp_slip.required' => 'กรุณาเลือกรูป',
            'sevp_pay_day.required' => 'กรุณากรอกวันที่',
            'sevp_pay_time.required' => 'กรุณากรอกเวลา',
        ]);
        
        if($validator->fails()){
            return response([
                'error' => $validator->errors()->all()
            ]);
        }

        if (!$request->has('sevp_slip')) {
            return response()->json([
                'save' => false,
                'message' => 'คุณไม่ได้เลือกไฟล์ภาพ'
            ]);
        }

        $img   = ImageManagerStatic::make($request->sevp_slip)->encode('jpg');
        $name  = date('YmdHis').Str::random() . '.jpg';
        Storage::disk('slip')->makeDirectory($salon_event_person->salon_id,777);
        Storage::disk('slip')->put($salon_event_person->salon_id.'/'.$name, $img);

        $salon_event_person->sevp_slip = $name;
        $salon_event_person->sevp_pay_day = $request->sevp_pay_day;
        $salon_event_person->sevp_pay_time = $request->sevp_pay_time;
        $salon_event_person->sevp_process = 2;
        $salon_event_person->save();

        return response()->json([
            'save' => true,
            'title' => 'อัพโหลดสลิปเงินเรียบร้อย',
        ]);
    }
}
