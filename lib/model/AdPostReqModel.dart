import 'dart:io';

class AdPostReqModel {
  String adId;
  String categoryId;
  String categoryName;
  String subCategoryId;
  String subCategoryName;
  String title;
  String price;
  String tags;
  String desc;
  String packageId;
  String address;
  String addresslat;
  String addresslng;
  String rentTypeId;
  String customFields;
  String imgPath1;
  String imgPath2;
  String imgPath3;
  File img1;
  File img2;
  File img3;

  AdPostReqModel(
      {this.adId,
      this.categoryId,
      this.subCategoryId,
      this.categoryName,
      this.subCategoryName,
      this.title,
      this.price,
      this.tags,
      this.desc,
      this.packageId,
      this.address,
      this.addresslat,
      this.addresslng,
      this.rentTypeId,
      this.customFields,
      this.imgPath1,
      this.imgPath2,
      this.imgPath3,
      this.img1,
      this.img2,
      this.img3});
}
