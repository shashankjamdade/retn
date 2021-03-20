import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rentry_new/utils/CommonStyles.dart';
import 'package:flutter_rentry_new/utils/size_config.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  List<String> imglist;
  ImagePreviewScreen(this.imglist);
  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

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
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  height:getProportionateScreenHeight(
                                      context, space_500),
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              carouselController: _controller,
                              items: widget.imglist.map((item) => Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: InteractiveViewer(
                                        child: Image.network(widget.imglist[_current]),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
//                  Align(
//                    alignment: Alignment.center,
//                    child: Container(
//                      margin: EdgeInsets.symmetric(horizontal: space_15),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          InkWell(
//                            onTap: () {
//                              _controller.previousPage();
//                            },
//                            child: Container(
//                              width: space_30,
//                              height: space_30,
//                              decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                color: Colors.black.withOpacity(0.2),
//                              ),
//                              child: Icon(
//                                Icons.arrow_left,
//                                color: Colors.white,
//                              ),
//                            ),
//                          ),
//                          InkWell(
//                            onTap: () {
//                              _controller.nextPage();
//                            },
//                            child: Container(
//                              width: space_30,
//                              height: space_30,
//                              decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                color: Colors.black.withOpacity(0.2),
//                              ),
//                              child: Icon(
//                                Icons.arrow_right,
//                                color: Colors.white,
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  )
                      ],
                    )),
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
                      margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: space_50, right: space_15),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close, color: Colors.white,)),
            ),
          ),
        ],
      ),
    );
  }


  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);

    }
  }

}
