import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/theme/text_theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final bool enableSearch;
  final List<T> menuList;
  final String labelText;
  final String hintText;
  final T? initaValue;
  final String? Function(T?)? singleSelectValidator;
  final Function(T?)? onChanged;
  final double menuMaxHeight;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;

  const CustomDropdown({
    super.key,
    required this.menuList,
    required this.labelText,
    required this.hintText,
    this.initaValue,
    this.singleSelectValidator,
    this.enableSearch = false,
    this.onChanged,
    this.menuMaxHeight = 200,
    this.itemAsString,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 380, child: _buildSingleSelectDropdown(context));
  }

  Widget _buildSingleSelectDropdown(BuildContext context) {
    return DropdownSearch<T>(
      compareFn: compareFn,
      validator: singleSelectValidator,
      items: (filter, loadProps) => menuList,
      selectedItem: initaValue,
      itemAsString: itemAsString,
      onChanged: onChanged,
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: Icon(Icons.keyboard_arrow_down, color: context.onPrimaryColor),
          iconOpened: Icon(Icons.keyboard_arrow_up, color: context.onPrimaryColor),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        isHovering: true,
        baseStyle: textTheme.titleSmall!.copyWith(color: context.onPrimaryColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: context.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.onPrimaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.error),
          ),
          errorStyle: textTheme.labelSmall!.copyWith(color: context.error, height: 0.8),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: textTheme.titleSmall!.copyWith(color: context.colorScheme.onSurface.withAlpha(200)),
          hintText: hintText,
          hintStyle: textTheme.titleSmall!.copyWith(color: context.colorScheme.onSurface.withAlpha(200), fontSize: 14),
          labelStyle: textTheme.titleSmall!.copyWith(color: context.colorScheme.onSurface.withAlpha(200), fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      popupProps: PopupProps.menu(
        constraints: BoxConstraints(maxHeight: menuMaxHeight),
        containerBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.onPrimaryColor, width: 1.2),
              borderRadius: BorderRadius.circular(8),
              color: context.primaryColor,
            ),
            child: child,
          );
        },
        menuProps: MenuProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 1.2),
          ),
        ),
        showSearchBox: enableSearch,
        searchFieldProps: TextFieldProps(
          cursorColor: context.onPrimaryColor,
          decoration: InputDecoration(
            focusColor: context.onPrimaryColor,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.onPrimaryColor)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.onPrimaryColor)),
            hintText: "بحث",
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          final display = itemAsString != null ? itemAsString!(item) : item.toString();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(display, style: textTheme.titleSmall!.copyWith(color: context.onPrimaryColor)),
              ),
              Divider(color: Colors.grey[500], thickness: 1, height: 1),
            ],
          );
        },
      ),
    );
  }
}
