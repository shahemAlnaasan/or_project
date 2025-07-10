import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/theme/text_theme.dart';

class CustomDropdown extends StatelessWidget {
  final bool enableSearch;
  final List<String> menuList;
  final String labelText;
  final String hintText;
  final String? initaValue;
  final String? Function(String?)? singleSelectValidator;
  final Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.menuList,
    required this.labelText,
    required this.hintText,
    this.initaValue,
    this.singleSelectValidator,
    this.enableSearch = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 380, child: _buildSingleSelectDropdown(context));
  }

  Widget _buildSingleSelectDropdown(BuildContext context) {
    return DropdownSearch<String>(
      validator: singleSelectValidator,
      items: (filter, loadProps) => menuList,
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: Icon(Icons.keyboard_arrow_down, color: context.onPrimaryColor),
          iconOpened: Icon(Icons.keyboard_arrow_up, color: context.onPrimaryColor),
        ),
      ),
      selectedItem: initaValue,
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
        constraints: BoxConstraints(maxHeight: 200),
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
          decoration: InputDecoration(
            hintText: "بحث",
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(item, style: textTheme.titleSmall!.copyWith(color: context.onPrimaryColor)),
              ),
              Divider(color: Colors.grey[500], thickness: 1, height: 1),
            ],
          );
        },
      ),
      onChanged: (String? selected) {
        if (onChanged != null) {
          onChanged!(selected);
        }
      },
    );
  }
}
