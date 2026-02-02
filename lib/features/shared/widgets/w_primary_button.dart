import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool fullWidth;
  final double? height;
  final Widget? icon;
  final double borderRadius;
  final bool enabled;
  final double elevation;
  final bool iconLeading;
  final MainAxisSize mainAxisSize;
  final Color? outlinedButtonBackgroundColor;
  final Duration debounceDuration;
  final bool spaceBetween;
  final bool useOverlayLoader;
  final EdgeInsets? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.enabled = true,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.fullWidth = true,
    this.icon,
    this.borderRadius = 100,
    this.height = 56,
    this.elevation = 0,
    this.iconLeading = false,
    this.mainAxisSize = MainAxisSize.max,
    this.outlinedButtonBackgroundColor,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.useOverlayLoader = false,
    this.spaceBetween = false,
    this.padding,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  Timer? _debounceTimer;

  void _handleOnPressed() {
    FocusScope.of(context).unfocus();
    if (_debounceTimer?.isActive ?? false) return;

    widget.onPressed();

    _debounceTimer = Timer(widget.debounceDuration, () {
      _debounceTimer = null;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor =
        widget.backgroundColor ?? AppColors.primaryBlackColor;
    final effectiveTextColor = widget.textColor ?? AppColors.whiteColor;

    if (widget.isOutlined) {
      return OutlinedButton(
        onPressed: widget.isLoading ? null : _handleOnPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: widget.textColor ?? AppColors.primaryBlackColor,
          backgroundColor: widget.outlinedButtonBackgroundColor,
          disabledForegroundColor: widget.useOverlayLoader
              ? (widget.textColor ?? AppColors.primaryBlackColor).withOpacity(
                  0.6,
                )
              : null,
          side: BorderSide(
            color:
                widget.borderColor ??
                widget.backgroundColor ??
                const Color.fromARGB(255, 68, 68, 68),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
          ),
          padding:
              widget.padding ??
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          minimumSize: Size(widget.fullWidth ? double.infinity : 0, 56.h),
        ),
        child: _buildButtonContent(),
      );
    }

    return ElevatedButton(
      onPressed: widget.enabled
          ? (widget.isLoading ? null : _handleOnPressed)
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveTextColor,
        overlayColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: widget.borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
        ),
        padding:
            widget.padding ??
            EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        minimumSize: Size(
          widget.fullWidth ? double.infinity : 0,
          (widget.height ?? 56).h,
        ),
        elevation: widget.elevation,
        disabledBackgroundColor: AppColors.grey200Color,
        disabledForegroundColor: widget.isLoading && widget.useOverlayLoader
            ? effectiveTextColor
            : null,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    Widget content;
    if (widget.icon != null) {
      final textWidget = Text(
        widget.text,
        style: AppTextStyles.buttonTextStyle.copyWith(
          color:
              widget.textColor ??
              (widget.isOutlined
                  ? AppColors.primaryBlackColor
                  : AppColors.whiteColor),
        ),
      );

      // When spaceBetween is true, we don't need a fixed width spacer
      // because MainAxisAlignment.spaceBetween handles the gap.
      final spacing = widget.spaceBetween
          ? const SizedBox.shrink()
          : SizedBox(width: 8.w);

      content = Row(
        mainAxisAlignment: widget.spaceBetween
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: widget.spaceBetween
            ? MainAxisSize.max
            : widget.mainAxisSize,
        children: widget.iconLeading
            ? [widget.icon!, spacing, textWidget]
            : [textWidget, spacing, widget.icon!],
      );
    } else {
      content = Text(
        widget.text,
        style: AppTextStyles.buttonTextStyle.copyWith(color: widget.textColor),
      );
    }

    if (widget.isLoading) {
      final spinner = SizedBox(
        width: 24.w,
        height: 24.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.isOutlined
                ? (widget.backgroundColor ?? AppColors.primaryBlackColor)
                : (widget.textColor ?? Colors.white),
          ),
        ),
      );

      if (widget.useOverlayLoader) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(opacity: 0.4, child: content),
            spinner,
          ],
        );
      }

      return spinner;
    }

    return content;
  }
}
