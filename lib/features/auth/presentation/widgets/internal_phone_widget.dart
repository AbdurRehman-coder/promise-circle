import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/models/phone_model.dart';

class InternationalPhoneInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorText;
  final String hint;
  final void Function(PhoneNumber)? onChanged;
  final Color? focusedBorderColor;
  final Color? unfocusedBorderColor;
  final Color? errorBorderColor;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final TextStyle? hintTextStyle;
  final Color? textColor;
  final TextStyle? textStyle;
  final String? initialCountryCode;

  const InternationalPhoneInputWidget({
    super.key,
    this.controller,
    this.errorText,
    this.hint = 'Enter mobile number',
    this.onChanged,
    this.focusedBorderColor,
    this.unfocusedBorderColor,
    this.errorBorderColor,
    this.backgroundColor,
    this.hintTextColor,
    this.hintTextStyle,
    this.textColor,
    this.textStyle,
    this.initialCountryCode = 'US',
  });

  @override
  State<InternationalPhoneInputWidget> createState() =>
      _InternationalPhoneInputWidgetState();
}

class _InternationalPhoneInputWidgetState
    extends State<InternationalPhoneInputWidget> {
  late Country _selectedCountry;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.parse(widget.initialCountryCode ?? 'US');
  }

  @override
  void didUpdateWidget(InternationalPhoneInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountryCode != oldWidget.initialCountryCode) {
      _selectedCountry = Country.parse(widget.initialCountryCode ?? 'US');
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });

        final phoneNumber = PhoneNumber(
          isoCode: country.countryCode,
          dialCode: '+${country.phoneCode}',
          phoneNumber: widget.controller?.text ?? '',
        );

        widget.onChanged?.call(phoneNumber);
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: AppColors.backgroundColor,
        textStyle: AppTextStyles.bodyTextStyle,
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorText = widget.errorText;

    Color borderColor;
    if (errorText != null) {
      borderColor = widget.errorBorderColor ?? AppColors.errorColor;
    } else if (_isFocused) {
      borderColor = widget.focusedBorderColor ?? AppColors.secondaryBlueColor;
    } else {
      borderColor = widget.unfocusedBorderColor ?? Color(0xffE3E3E4);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 57,
          child: ClipRect(
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: _showCountryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountry.flagEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            '+${_selectedCountry.phoneCode}',
                            style:
                                widget.textStyle ??
                                AppTextStyles.bodyTextStyle.copyWith(
                                  color:
                                      widget.textColor ?? AppColors.blackColor,
                                ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 30, width: 1, color: AppColors.blackColor),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      minLines: 1,
                      style: (widget.textStyle ?? AppTextStyles.bodyTextStyle)
                          .copyWith(
                            color: widget.textColor ?? AppColors.blackColor,
                          ),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle:
                            (widget.hintTextStyle ??
                                    AppTextStyles.bodyTextStyle)
                                .copyWith(
                                  fontSize: 14,
                                  color:
                                      widget.hintTextColor ??
                                      const Color(0xffAAAAAE),
                                ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        errorText: null,
                        errorStyle: const TextStyle(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        isDense: true,
                        filled: false,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      onChanged: (value) {
                        final phoneNumber = PhoneNumber(
                          isoCode: _selectedCountry.countryCode,
                          dialCode: '+${_selectedCountry.phoneCode}',
                          phoneNumber: value,
                        );
                        widget.onChanged?.call(phoneNumber);
                      },
                      onTap: () {
                        setState(() {
                          _isFocused = true;
                        });
                      },
                      onTapOutside: (_) {
                        setState(() {
                          _isFocused = false;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}
