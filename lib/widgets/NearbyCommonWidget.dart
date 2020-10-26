import 'package:flutter/material.dart';
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

class CategoryListWidget extends StatelessWidget {

  CategorySearchData categoryObj;
  Function(String, String, String) onCategorySelect;

  CategoryListWidget(this.categoryObj, this.onCategorySelect);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(categoryObj!=null){
          onCategorySelect(categoryObj.category_id, categoryObj.subcategory_id, categoryObj.name);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: space_10, horizontal: space_15),
        child: Text(
          categoryObj.name,
          style: CommonStyles.getRalewayStyle(
              space_14, FontWeight.w500, Colors.black87),
        ),
      ),
    );
  }
}



