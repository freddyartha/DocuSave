import 'dart:async';

import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/images/select_image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_box_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SelectMultipleImagesController {
  late Function(VoidCallback fn) setState;
  final List<dynamic> _imageList = [];
  List<String> removedNetwokImages = [];
  Function()? onChanged;

  SelectMultipleImagesController({this.onChanged});

  bool _required = false;
  String? _errorMessage;
  bool _isInit = false;

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    _isInit = true;
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });

    if (_required && _imageList.isEmpty) {
      setState(() {
        _errorMessage = 'field_is_required'.tr;
      });
      return false;
    }
    return true;
  }

  set value(List<dynamic> val) {
    _imageList.addAll(val);
    if (_isInit) {
      setState(() {});
    }
  }

  List<dynamic> get value {
    return _imageList;
  }

  void pickImageOptions() async {
    await SelectImageComponent.selectImageBottomSheet(
      showRemovePicture: false,
      selectCamera: () async => selectCamera(),
      selectGallery: () async => selectMultipleImages(),
    );
  }

  Future<void> selectCamera() async {
    var data = await SelectImageComponent.selectImageSource(
      source: ImageSource.camera,
      allowCrop: false,
    );
    if (data != null) {
      setState(() {
        _imageList.add(data);
        if (onChanged != null) {
          onChanged!();
        }
      });
    }
  }

  Future<void> selectMultipleImages() async {
    var data = await SelectImageComponent.selectMultipleImages(
      cropImages: false,
    );
    if (data != null) {
      setState(() {
        _imageList.addAll(data);
        if (onChanged != null) {
          onChanged!();
        }
      });
    }
  }

  void removeImage(dynamic item) {
    setState(() {
      _imageList.remove(item);
      if (item is String) {
        removedNetwokImages.add(item);
      }
      if (onChanged != null) {
        onChanged!();
      }
    });
  }

  void clearImages() {
    setState(() {
      for (var i in _imageList) {
        if (i is String) {
          removedNetwokImages.add(i);
        }
      }
      _imageList.clear();
      if (onChanged != null) {
        onChanged!();
      }
    });
  }
}

class SelectMultipleImagesComponent extends StatefulWidget {
  final SelectMultipleImagesController controller;
  final bool required;
  final String? label;
  final bool editable;
  final String? placeHolder;
  final double? marginBottom;

  const SelectMultipleImagesComponent({
    super.key,
    required this.controller,
    this.required = false,
    this.label,
    this.editable = true,
    this.placeHolder,
    this.marginBottom,
  });

  @override
  State<SelectMultipleImagesComponent> createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectMultipleImagesComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller._required = widget.required;

    return InputBoxComponent(
      label: widget.label,
      errorMessage: widget.controller._errorMessage,
      marginBottom: widget.marginBottom,
      children: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(MahasRadius.regular),
          color: MahasColors.mutedGrey,
          dashPattern: [7, 4],
        ),
        child: GestureDetector(
          onTap: () {
            if (widget.editable) widget.controller.pickImageOptions();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child:
                widget.controller._imageList.isNotEmpty
                    ? Column(
                      children: [
                        Visibility(
                          visible:
                              widget.controller._imageList.isNotEmpty &&
                              widget.editable,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ButtonComponent(
                              onTap: widget.controller.clearImages,
                              text: "Clear Images",
                              btnColor: MahasColors.red,
                              leading: Icon(
                                Icons.delete_forever_rounded,
                                color: MahasColors.white,
                              ),
                            ),
                          ),
                        ),
                        GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ...widget.controller._imageList.map(
                              (item) => GestureDetector(
                                onTap: () async {
                                  await ReusableWidgets.showImageBottomSheet(
                                    item is CroppedFile ? item.path : item,
                                    item is String ? true : false,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: MahasColors.mutedGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          MahasRadius.small,
                                        ),
                                      ),
                                      clipBehavior: Clip.hardEdge,

                                      child:
                                          item is CroppedFile
                                              ? ImageComponent(
                                                imageFromFile: item.path,
                                                boxFit: BoxFit.contain,
                                              )
                                              : ImageComponent(
                                                networkUrl: item,
                                                boxFit: BoxFit.contain,
                                              ),
                                    ),
                                    Visibility(
                                      visible: widget.editable,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap:
                                                () => widget.controller
                                                    .removeImage(item),
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MahasColors.lightgray,
                                              ),
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.editable)
                              GestureDetector(
                                onTap: widget.controller.pickImageOptions,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MahasColors.mutedGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MahasRadius.small,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                      color: MahasColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    )
                    : widget.controller._imageList.isEmpty && widget.editable
                    ? Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 35,
                          color: MahasColors.darkgray,
                        ),
                        TextComponent(
                          value: "click_to_select_images".tr,
                          fontColor: MahasColors.darkgray,
                        ),
                      ],
                    )
                    : Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_search_rounded,
                          size: 35,
                          color: MahasColors.darkgray,
                        ),
                        TextComponent(
                          value: "no_image".tr,
                          fontColor: MahasColors.darkgray,
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
