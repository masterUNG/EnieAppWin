<?php

namespace App\Http\Controllers\Api\Salon;

use App\Models\Product;
use App\Models\ProductNear;
use Illuminate\Http\Request;
use App\Models\DiscountGroup;
use App\Models\ProductSeries;
use App\Models\ProductCategory;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\ProductResource;
use App\Http\Resources\DiscountGroupResource;
use App\Http\Resources\ProductSeriesResource;
use App\Http\Resources\ProductCategoryResource;

class ProductController extends Controller
{
    //
    public function hot()
    {
        $product_hots = Product::where('pd_show_salon',1)
                            ->where('pd_hot',1)
                            ->orderBy('pd_seq','asc')
                            ->limit(10)
                            ->get(); 

        return ProductResource::collection($product_hots);
    }

    public function best()
    {
        $product_bests = Product::where('pd_show_salon',1)
                            ->where('pd_best',1)
                            ->orderBy('pd_seq','asc')
                            ->limit(10)
                            ->get();

        return ProductResource::collection($product_bests);
    }

    public function discount()
    {
        $product_discount = DiscountGroup::where('dcg_show_salon',1)->get();

        return DiscountGroupResource::collection($product_discount);
    }
    
    public function category()
    {
        $product_categories = ProductCategory::where('pdc_show_salon',1)
                                    ->where('pdc_status',1)
                                    ->orderBy('pdc_seq','asc')
                                    ->get();
        return ProductCategoryResource::collection($product_categories);
    }

    public function series(ProductCategory $product_category)
    {
        $product_series = ProductSeries::where('product_category_id',$product_category->id)
                                ->where('psr_on_salon',1)
                                ->where('psr_status',1)
                                ->orderBy('psr_seq','asc')
                                ->get();

        return ProductSeriesResource::collection($product_series);
    }

    public function lists(ProductSeries $product_series)
    {
        $products = Product::where('pd_status',1)
                        ->where('pd_show_salon',1)
                        ->where('product_series_id',$product_series->id)
                        // ->where('id','<>',Auth::guard('salon')->user()->gift_code)
                        ->where('pd_qty','>',0)
                        ->orderBy('pd_seq','asc')
                        ->get();

        return ProductResource::collection($products);
    }

    public function neary(Product $product)
    {
        $products = ProductNear::select(
                        'products.*'
                    )
                    ->join('products','products.id','=','product_nears.near_id')
                    ->where('product_nears.product_id',$product->id)
                    ->where('products.pd_status',1)
                    ->where('products.pd_qty','>',0)
                    ->orderBy('products.pd_seq','asc')
                    ->get();
        
        return ProductResource::collection($products);
    }

    public function show(Product $product)
    {
        return new ProductResource($product);
    }

    public function pointList()
    {
        $products = Product::where('pd_show_point',1)
                        ->where('pd_qty','>',0)
                        ->orderBy('pd_price_point','asc')
                        ->get();

        return ProductResource::collection($products);
    }

    public function pointShow(Product $product)
    {
        return new ProductResource($product);
    }

    public function all(Request $request)
    {
        $products = Product::where('pd_status',1)
                        ->where('pd_show_salon',1)
                        ->where('pd_qty','>',0);

        if(!empty($request->searchTerm)){
            $products = $products
                            ->where('pd_name_th','LIKE',"%{$request->searchTerm}%");
        }
                        

        if($request->category > 0){
            $request->series = ProductSeries::where('product_category_id',$request->category)
                                ->where('psr_status',1)
                                ->where('psr_on_salon',1)
                                ->orderBy('psr_seq','asc')
                                ->get();
            $products = $products 
                            ->where('product_category_id',$request->category);
        }

        if($request->se > 0){
            $products = $products 
                            ->where('product_series_id',$request->se);
        }

        $products = $products
                        // ->orderBy('pd_seq','asc')
                        // ->orderBy('pd_popularity','desc')
                        ->orderBy('pd_sell_qty','desc')
                        ->limit(50)
                        ->get();

        $categories =  ProductCategory::where('pdc_status',1)
                            ->where('pdc_show_salon',1)
                            ->orderBy('pdc_seq','asc')
                            ->get();

        return [
            'categories' => ProductCategoryResource::collection($categories),
            'products' => ProductResource::collection($products)
        ];
    }

    public function allShow(Product $product)
    {
        $products = ProductNear::select(
                        'products.*'
                    )
                    ->join('products','products.id','=','product_nears.near_id')
                    ->where('product_nears.product_id',$product->id)
                    ->where('products.pd_status',1)
                    ->where('products.pd_qty','>',0)
                    ->orderBy('products.pd_seq','asc')
                    ->get();

        return [
            'product' => new ProductResource($product),
            'neary' => ProductResource::collection($products)
        ];
    }
}
