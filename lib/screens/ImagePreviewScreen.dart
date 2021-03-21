import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagePreviewScreen extends StatefulWidget {
  List<String> imglist;

  ImagePreviewScreen(this.imglist);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _current);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    width: double.infinity,
                    child: _buildPhotoViewGallery()),
              ),
              Container(
                margin: EdgeInsets.all(space_15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imglist.map((url) {
                    int index = widget.imglist.indexOf(url);
                    return _current == index
                        ? Container(
                            width: space_12,
                            height: space_12,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Container(
                                width: space_5,
                                height: space_5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          )
                        : Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          );
                  }).toList(),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: space_50, right: space_15),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ),
          ),
//          Positioned(
//            bottom: 10,
//            left: 10,
//            child: GestureDetector(
//              onTap: () {
////                _controller.previousPage();
//                setState(() {
//                  if(_current>0){
//                    _current = _current -1;
//                  }
//                });
//              },
//              child: Container(
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: Colors.black.withOpacity(0.2),
//                ),
//                child: Icon(
//                  Icons.arrow_left,
//                  color: Colors.white,
//                  size: space_35,
//                ),
//              ),
//            ),
//          ),
//          Positioned(
//            bottom: 10,
//            right: 10,
//            child: GestureDetector(
//              onTap: () {
////                _controller.nextPage();
//              setState(() {
//                if(_current<widget.imglist.length-1){
//                  _current = _current +1;
//                }
//              });
//              },
//              child: Container(
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: Colors.black.withOpacity(0.2),
//                ),
//                child: Icon(
//                  Icons.arrow_right,
//                  color: Colors.white,
//                  size: space_35,
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }

  PhotoViewGallery _buildPhotoViewGallery() {
    return PhotoViewGallery.builder(
      itemCount: widget.imglist.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.imglist[_current]),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
        );
      },
      enableRotation: false,
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Center(child: CircularProgressIndicator());
      },
      onPageChanged: (int index) {
        setState(() {
          _current = index;
        });
      },
      // backgroundDecoration: BoxDecoration(color: Colors.red),
      // scrollDirection: Axis.vertical,
    );
  }


}
