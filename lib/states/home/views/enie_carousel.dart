import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:enie/models/salon_banner_model.dart';
import 'package:enie/models/salon_event_model.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_image.dart';
import 'package:enie/widgets/show_progress.dart';
import 'package:enie/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:enie/package/carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:sajilo_dokan/package/carousel.dart';
class EnieCarousel extends StatefulWidget {
  const EnieCarousel({Key? key}) : super(key: key);
  @override
  State<EnieCarousel> createState() => _EnieCarouselState();
}

class _EnieCarouselState extends State<EnieCarousel> {
  bool load = true;
  bool? haveData;

  List<SalonBannerModel> bannerModels = [];
  List<SalonEventModel> eventModels = [];

  @override
  void initState() {
    loadValueFromApi();
    loadValueFromApi2();
  }

  Future<Null> loadValueFromApi() async {
    if (bannerModels.length != 0) {
      bannerModels.clear();
    } else {}
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print('### token ===>> $token');

    String apiGetSalonBanner =
        'https://office.fantasy.co.th/api/salon/slide-banner';
    await Dio()
        .get(
      apiGetSalonBanner,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    )
        .then((value) {
      print('value ==> $value');

      // Have Data
      for (var item in json.decode(value.data)) {
        SalonBannerModel model = SalonBannerModel.fromMap(item);

        print('name Product ==>> ${model.sb_picture}');

        setState(() {
          load = false;
          haveData = true;
          bannerModels.add(model);
        });
      }
    });
  }

  Future<Null> loadValueFromApi2() async {
    if (eventModels.length != 0) {
      eventModels.clear();
    } else {}
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print('### token ===>> $token');

    String apiGetSalonEvent =
        'https://office.fantasy.co.th/api/salon/slide-event';
    await Dio()
        .get(
      apiGetSalonEvent,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    )
        .then((value2) {
      print('value ==> $value2');

      // Have Data
      for (var item in json.decode(value2.data)) {
        SalonEventModel model = SalonEventModel.fromMap(item);

        print('name Event ==>> ${model.sev_picture}');

        setState(() {
          load = false;
          haveData = true;
          eventModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 400,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 4),
          autoPlayAnimationDuration: Duration(milliseconds: 1500),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: bannerModels.length,
        itemBuilder: (context, index, realIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        'https://office.fantasy.co.th/images/salon-banner/' +
                            bannerModels[index].sb_picture,
                    placeholder: (context, url) => ShowProgress(),
                    errorWidget: (context, url, error) => ShowImage(
                      path: 'images/salon_picture.png',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
