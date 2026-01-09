import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../domain/models/common.dart';

class GenderFormField extends FormField<String> {

  GenderFormField({
    super.key,
    super.onSaved,
    super.validator,
    String initialValue = '',
    bool enabled = true,
    AutovalidateMode? autoValidateMode,
    List<Gender> genders =  Gender.values,
  }) : super(
      initialValue: initialValue,
      autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
      builder: (FormFieldState<String> state) {
        return ToggleButtons(
          direction: Axis.horizontal,
          onPressed: enabled ? (int index) {
            state.didChange(_identifyGender(index));
          } : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.red[700],
          selectedColor: Colors.white,
          fillColor: Colors.lightBlueAccent,
          color: Colors.red[400],
          constraints: const BoxConstraints(
            minHeight: 30.0,
            minWidth: 80.0,
          ),
          isSelected: _selectedGenders(genders, state.value),
          children: genders.map((e) => Text(e.name)).toList(),
        );
      }
  );

  static List<bool> _selectedGenders(List<Gender> genders, String? value) {
    return genders.map((e) => e.name.toLowerCase() == value).toList();
  }
  static String _identifyGender(int index) {
    return Gender.values[index].name;
  }
}


class DropDownSearchFormField<T> extends FormField<T> {
  DropDownSearchFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    AutovalidateMode? autoValidateMode,
    required List<T> items,
    required String label,
    String? hint,
    ValueChanged<T?>? onChanged,
    DropdownSearchFilterFn<T>? filterFn,
    DropdownSearchItemAsString<T>? itemAsString,
    DropdownSearchCompareFn<T>? compareFn,
    bool enabled = true,
  }) : super(
      autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
      builder: (FormFieldState<T> state) {
        return DropdownSearch<T>(
          popupProps: PopupProps.menu(
            showSelectedItems: true, 
            showSearchBox: true,
          ),
          items: (filter, infiniteScrollProps) async => items,
          itemAsString: itemAsString,
          enabled: enabled,
          compareFn: compareFn,
          suffixProps: DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(
              isVisible: true,
              icon: Icon(Icons.clear, size: 12, color: Colors.red),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: label,
              errorStyle: TextStyle(color: Colors.red),
              errorText: state.hasError ? state.errorText : null,
            ),
          ),
          onChanged: (value) {
            state.didChange(value);
            if (onChanged != null) {
              onChanged(value);
            }
          },
          selectedItem: initialValue,
        );
      },
  );
}

class CheckboxFormField extends FormField<bool> {
  final bool isEnabled;
  
  CheckboxFormField({
    super.key,
    Widget? title,
    super.onSaved,
    super.validator,
    this.isEnabled = true,
    bool super.initialValue = false,
    bool autoValidate = false})
  : super(
      enabled: isEnabled,
      builder: (FormFieldState<bool> state) {
        return CheckboxListTile(
          dense: state.hasError,
          title: title,
          value: state.value,
          enabled: state.widget.enabled,
          onChanged: state.didChange,
          subtitle: state.hasError ? Builder(
            builder: (BuildContext context) => Text(
              state.errorText ?? "",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error),
            ),
          ) : null,
          controlAffinity: ListTileControlAffinity.leading,
        );
      });
}
