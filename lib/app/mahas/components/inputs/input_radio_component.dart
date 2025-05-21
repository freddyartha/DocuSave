import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'input_box_component.dart';

enum CheckboxPosition { left, right }

class RadioButtonItem {
  dynamic id;
  String text;
  dynamic value;
  String? pngUrl;

  RadioButtonItem({this.id, required this.text, this.value, this.pngUrl});

  RadioButtonItem.autoId(String text, dynamic value, String? pngUrl)
    : this(
        id: ReusableStatics.idGenerator,
        text: text,
        value: value,
        pngUrl: pngUrl,
      );

  RadioButtonItem.simple(String value) : this.autoId(value, value, null);
}

class InputRadioController {
  late Function(VoidCallback fn) setState;

  List<RadioButtonItem> items;
  RadioButtonItem? _value;
  Function(RadioButtonItem item)? onChanged;
  bool required = false;
  String? _errorMessage;
  bool _isInit = false;

  InputRadioController({this.items = const [], this.onChanged});

  void _onChanged(RadioButtonItem v, bool editable) {
    if (!editable) return;
    setState(() {
      _value = v;
      if (onChanged != null) {
        onChanged!(v);
      }
    });
  }

  set setItems(List<RadioButtonItem> val) {
    if (val.where((e) => e.value == _value?.value).isEmpty) {
      _value = null;
    }
    items = val;
  }

  dynamic get value {
    return _value?.value;
  }

  set value(dynamic val) {
    if (val == null) {
      _value = null;
    } else {
      _value = items.firstWhere((e) => e.value == val);
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
    if (required && _value == null) {
      setState(() {
        _errorMessage = "select_one".tr;
      });
      return false;
    }
    return true;
  }
}

class InputRadioComponent extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool editable;
  final bool required;
  final InputRadioController controller;
  final CheckboxPosition position;
  final double? marginBottom;
  final double? spacing;

  const InputRadioComponent({
    super.key,
    this.label,
    this.labelStyle,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.position = CheckboxPosition.left,
    this.marginBottom,
    this.spacing,
  });

  @override
  State<InputRadioComponent> createState() => _InputRadioComponentState();
}

class _InputRadioComponentState extends State<InputRadioComponent> {
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
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.controller.items.length,
          separatorBuilder:
              (context, index) => SizedBox(height: widget.spacing ?? 8),
          itemBuilder: (context, index) {
            final e = widget.controller.items[index];

            return GestureDetector(
              onTap: () => widget.controller._onChanged(e, widget.editable),
              child: Row(
                children: [
                  Visibility(
                    visible: widget.position == CheckboxPosition.left,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Radio<RadioButtonItem>(
                        value: e,
                        activeColor:
                            widget.editable == true
                                ? MahasColors.primary
                                : MahasColors.grayText,
                        groupValue: widget.controller._value,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        onChanged: (value) {
                          widget.controller._onChanged(value!, widget.editable);
                        },
                      ),
                    ),
                  ),
                  if (widget.position == CheckboxPosition.right &&
                      e.pngUrl != null &&
                      e.pngUrl != "") ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset(
                        e.pngUrl!,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                  //radio title
                  Expanded(child: TextComponent(value: e.text)),
                  //radio title
                  if (widget.position == CheckboxPosition.left &&
                      e.pngUrl != null &&
                      e.pngUrl != "") ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Image.asset(
                        e.pngUrl!,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                  Visibility(
                    visible: widget.position == CheckboxPosition.right,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Radio<RadioButtonItem>(
                        value: e,
                        activeColor: MahasColors.primary,
                        groupValue: widget.controller._value,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        onChanged: (value) {
                          widget.controller._onChanged(value!, widget.editable);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
