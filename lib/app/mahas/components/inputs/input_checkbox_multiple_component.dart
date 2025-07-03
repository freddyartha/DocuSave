import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'input_box_component.dart';

class CheckboxItem {
  dynamic id;
  String text;
  dynamic value;

  CheckboxItem({this.id, required this.text, this.value});

  CheckboxItem.autoId(String text, dynamic value, String? pngUrl)
    : this(id: ReusableStatics.idGenerator, text: text, value: value);

  CheckboxItem.simple(String value) : this.autoId(value, value, null);
}

class InputCheckboxMultipleController {
  late Function(VoidCallback fn) setState;

  List<CheckboxItem> items;
  List<CheckboxItem> listvalue = [];
  Function()? onChanged;
  bool required = false;
  String? _errorMessage;
  bool _isInit = false;

  InputCheckboxMultipleController({this.items = const [], this.onChanged});

  set setItems(List<CheckboxItem> val) {
    items = val;
  }

  List<dynamic> get value {
    return listvalue.map((item) => item.value).toList();
  }

  set value(List<dynamic> val) {
    if (val.isEmpty) {
      listvalue = [];
    } else {
      for (var v in val) {
        listvalue.addAll(items.where((e) => e.value == v));
      }
    }
    if (_isInit) {
      setState(() {});
    }
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    _isInit = true;
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (required && listvalue.isEmpty) {
      setState(() {
        _errorMessage = "select_atleast_one".tr;
      });
      return false;
    }
    return true;
  }
}

class InputCheckboxMultipleComponent extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool editable;
  final bool required;
  final InputCheckboxMultipleController controller;
  final ListTileControlAffinity position;
  final double? marginBottom;
  final double? spacing;

  const InputCheckboxMultipleComponent({
    super.key,
    this.label,
    this.labelStyle,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.position = ListTileControlAffinity.leading,
    this.marginBottom,
    this.spacing,
  });

  @override
  State<InputCheckboxMultipleComponent> createState() =>
      _InputCheckboxMultipleComponentState();
}

class _InputCheckboxMultipleComponentState
    extends State<InputCheckboxMultipleComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    widget.controller.required = widget.required;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputBoxComponent(
      label: widget.label,
      isRequired: widget.required,
      errorMessage: widget.controller._errorMessage,
      marginBottom: widget.marginBottom,
      children: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children:
              widget.controller.items.map((e) {
                final isChecked = widget.controller.listvalue.any(
                  (item) => item.value == e.value,
                );

                return CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: TextComponent(value: e.text, height: 1),
                  value: isChecked,
                  onChanged: (bool? checked) {
                    if (widget.editable) {
                      setState(() {
                        final exists = widget.controller.listvalue.any(
                          (item) => item.value == e.value,
                        );
                        if (checked == true && !exists) {
                          widget.controller.listvalue.add(e);
                        } else if (checked == false && exists) {
                          widget.controller.listvalue.removeWhere(
                            (item) => item.value == e.value,
                          );
                        }
                        if (widget.controller.onChanged != null) {
                          widget.controller.onChanged!();
                        }
                      });
                    }
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
