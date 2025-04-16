import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'input_box_component.dart';

class DropdownItem {
  String text;
  dynamic value;

  DropdownItem({required this.text, this.value});

  DropdownItem.init(String? text, dynamic value)
    : this(text: text ?? "", value: value);

  DropdownItem.simple(String? value) : this.init(value, value);
}

class InputDropdownController {
  GlobalKey<FormState>? _key;
  late Function(VoidCallback fn) setState;

  DropdownItem? _value;
  List<DropdownItem> items;
  Function(DropdownItem? value)? onChanged;
  bool _isInit = false;

  late bool _required = false;

  dynamic get value {
    return _value?.value;
  }

  String? get text {
    return _value?.text;
  }

  set value(dynamic val) {
    if (items.where((e) => e.value == val).isEmpty) {
      _value = null;
    } else {
      _value = items.firstWhere((e) => e.value == val);
    }
    if (_isInit) {
      setState(() {});
    }
  }

  set setItems(List<DropdownItem> val) {
    var selectedItemOld = _value;
    _value = null;
    items = val;

    if (selectedItemOld != null) {
      _value = items.firstWhereOrNull((e) => e.value == selectedItemOld.value);
    }
  }

  InputDropdownController({this.items = const [], this.onChanged});

  void _rootOnChanged(e) {
    _value = e;
    if (onChanged != null) {
      onChanged!(e);
    }
    if (_isInit) {
      setState(() {});
    }
  }

  String? _validator(v) {
    if (_required && v == null) {
      return 'The field is required';
    }
    return null;
  }

  bool get isValid {
    bool? valid = _key?.currentState?.validate();
    if (valid == null) {
      return true;
    }
    return valid;
  }

  void _init(Function(VoidCallback fn) setStateX, bool requiredX) {
    setState = setStateX;
    _required = requiredX;
    _isInit = true;

    if (requiredX) {
      _key = GlobalKey<FormState>();
    }
  }
}

class InputDropdownComponent extends StatefulWidget {
  final String? label;
  final String? placeHolder;
  final double? marginBottom;
  final bool required;
  final bool editable;
  final InputDropdownController controller;
  final Radius? borderRadius;
  final bool hasBorder;
  final EdgeInsetsGeometry? padding;

  const InputDropdownComponent({
    super.key,
    this.label,
    this.placeHolder,
    this.marginBottom,
    this.editable = true,
    required this.controller,
    this.required = false,
    this.borderRadius,
    this.hasBorder = true,
    this.padding,
  });

  @override
  State<InputDropdownComponent> createState() => _InputDropdownComponentState();
}

class _InputDropdownComponentState extends State<InputDropdownComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    }, widget.required);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      isDense: true,
      filled: true,
      hoverColor: MahasColors.white,
      fillColor:
          widget.hasBorder
              ? MahasColors.black.withValues(alpha: widget.editable ? .01 : .07)
              : MahasColors.grayText,
      contentPadding:
          widget.padding ?? const EdgeInsets.fromLTRB(10, 12, 10, 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          widget.borderRadius ?? Radius.circular(MahasRadius.regular),
        ),
        borderSide:
            widget.hasBorder
                ? BorderSide(color: MahasColors.mutedGrey)
                : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          widget.borderRadius ?? Radius.circular(MahasRadius.regular),
        ),
        borderSide:
            widget.hasBorder
                ? BorderSide(color: MahasColors.mutedGrey)
                : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          widget.borderRadius ?? Radius.circular(MahasRadius.regular),
        ),
        borderSide:
            widget.hasBorder
                ? BorderSide(color: MahasColors.mutedGrey)
                : BorderSide.none,
      ),
      prefixStyle: TextStyle(color: MahasColors.white.withValues(alpha: 0.6)),
      suffixIconConstraints: const BoxConstraints(minHeight: 30, minWidth: 30),
    );

    final dropdownButton = DropdownButtonFormField(
      dropdownColor: MahasColors.white,
      decoration: decoration,
      isExpanded: true,
      focusColor: Colors.transparent,
      validator: widget.controller._validator,
      value: widget.controller._value,
      onChanged: widget.editable ? widget.controller._rootOnChanged : null,
      hint: TextComponent(
        value: widget.placeHolder ?? "Select",
        isMuted: true,
        fontColor: MahasColors.mutedGrey,
      ),
      items:
          widget.controller.items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: TextComponent(value: e.text),
                ),
              )
              .toList(),
    );

    return InputBoxComponent(
      label: widget.label,
      isRequired: widget.required,
      marginBottom: widget.marginBottom,
      childText: widget.controller._value?.text ?? "",
      children:
          widget.editable
              ? widget.required
                  ? Form(key: widget.controller._key, child: dropdownButton)
                  : dropdownButton
              : null,
    );
  }
}
