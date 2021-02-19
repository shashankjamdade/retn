import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/model/google_places_res.dart';
import 'package:flutter_rentry_new/model/location_search_response.dart';
import 'package:flutter_rentry_new/model/search_sub_category_response.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';



class LocationCityListWidget extends StatelessWidget {

  SearchLocationData locationData;
  Function(String, String, String) onLocationSelect;

  LocationCityListWidget(this.locationData, this.onLocationSelect);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(locationData!=null){
          onLocationSelect(locationData.lat, locationData.lng, locationData.name);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: space_10, horizontal: space_15),
        child: Text(
          locationData.name,
          style: CommonStyles.getRalewayStyle(
              space_14, FontWeight.w500, Colors.black87),
        ),
      ),
    );
  }
}

class GooglePlaceListWidget extends StatelessWidget {

  Predictions locationData;
  Function(Predictions) onLocationSelectedFromGoogle;

  GooglePlaceListWidget(this.locationData, this.onLocationSelectedFromGoogle);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(locationData!=null){
          debugPrint("MY_PLACE_SELECT-->> ${locationData?.place_id}");
          onLocationSelectedFromGoogle(locationData);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: space_10, horizontal: space_15),
        child: Text(
//          "${locationData?.description}",
          locationData!=null && locationData.structured_formatting!=null && locationData.structured_formatting.main_text!=null ?locationData.structured_formatting.main_text:"1",
          style: CommonStyles.getRalewayStyle(
              space_14, FontWeight.w500, Colors.black87),
        ),
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {

  CategorySearchData categoryObj;
  Function(String, String, String, String, String) onCategorySelect;

  CategoryListWidget(this.categoryObj, this.onCategorySelect);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(categoryObj!=null){
          onCategorySelect(categoryObj.category_id, categoryObj.subcategory_id, categoryObj.category_name, categoryObj.subcategory_name, categoryObj.ads_title);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: space_10, horizontal: space_15),
        child: Text(
          categoryObj?.ads_title!=null? categoryObj?.ads_title: categoryObj.subcategory_name!=null? categoryObj.subcategory_name:categoryObj.category_name,
          style: CommonStyles.getRalewayStyle(
              space_14, FontWeight.w500, Colors.black87),
        ),
      ),
    );
  }
}



