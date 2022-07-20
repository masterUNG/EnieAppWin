<?php

namespace App\Http\Controllers\Api\Salon;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SalonDashboardController extends Controller
{
    public function index()
    {
        return response([
            'message' => 'Hello Salon Api'
        ]);
    }
}
