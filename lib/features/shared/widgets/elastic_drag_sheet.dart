import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class ElasticDragSheet extends StatefulWidget {
  final Widget Function(BuildContext context, ScrollPhysics physics) builder;
  final double closeThreshold;
  final double velocityThreshold;
  final double dragResistance;

  const ElasticDragSheet({
    super.key,
    required this.builder,
    this.closeThreshold = 0.4,
    this.velocityThreshold = 800.0,
    this.dragResistance = 0.8,
  });

  @override
  State<ElasticDragSheet> createState() => _ElasticDragSheetState();
}

class _ElasticDragSheetState extends State<ElasticDragSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<double> _dragOffsetNotifier = ValueNotifier(0.0);

  double _accumulatedOverscroll = 0.0;
  final double _activationThreshold = 30.0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _controller.addListener(() {
      _dragOffsetNotifier.value = _controller.value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dragOffsetNotifier.dispose();
    super.dispose();
  }

  void _snapBack(double velocity) {
    _accumulatedOverscroll = 0.0;
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 170, damping: 20),
      _dragOffsetNotifier.value,
      0.0,
      velocity,
    );
    _controller.animateWith(simulation);
  }

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final Widget staticContent = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // === 1. STRICT GUARD CLAUSE ===
        // If the content is NOT at the very top (pixels > 0),
        // we are in "Scrolling Mode".
        // Absolutely forbid any sheet movement and reset all buffers.
        if (notification.metrics.pixels > 0) {
          if (_accumulatedOverscroll != 0.0) _accumulatedOverscroll = 0.0;
          if (_dragOffsetNotifier.value != 0.0) {
            // Use local value update to avoid notifying listeners during build if possible
            // but here we need to ensure visual reset:
            if (!_controller.isAnimating) _dragOffsetNotifier.value = 0.0;
          }
          return false;
        }

        // === 2. OVERSCROLL (Pulling Down at Top) ===
        if (notification is OverscrollNotification) {
          if (notification.overscroll < 0 && notification.dragDetails != null) {
            if (_controller.isAnimating) _controller.stop();

            // Accumulate value
            _accumulatedOverscroll -= notification.overscroll;

            // Only move visually if we passed the buffer
            if (_accumulatedOverscroll > _activationThreshold) {
              double visualDelta =
                  (_accumulatedOverscroll - _activationThreshold) *
                  widget.dragResistance;
              _dragOffsetNotifier.value = visualDelta;
            }
          }
        }
        // === 3. SCROLL UPDATE (Pushing Back Up) ===
        else if (notification is ScrollUpdateNotification) {
          // We only care about ScrollUpdate if the sheet is ALREADY moved.
          // Otherwise, normal scrolling handles it (caught by Guard Clause above).
          if (_dragOffsetNotifier.value > 0 &&
              notification.dragDetails != null) {
            // User is pushing the sheet back up
            if (notification.scrollDelta != null) {
              if (_controller.isAnimating) _controller.stop();

              _accumulatedOverscroll -= notification.scrollDelta!;

              if (_accumulatedOverscroll > _activationThreshold) {
                double visualDelta =
                    (_accumulatedOverscroll - _activationThreshold) *
                    widget.dragResistance;
                _dragOffsetNotifier.value = visualDelta;
              } else {
                _dragOffsetNotifier.value = 0.0;
                _accumulatedOverscroll = 0.0;
              }
            }
          }
        }
        // === 4. DRAG END ===
        else if (notification is ScrollEndNotification) {
          if (_dragOffsetNotifier.value > 0) {
            final velocity = notification.dragDetails?.primaryVelocity ?? 0.0;
            final isFling = velocity > widget.velocityThreshold;
            final isPastThreshold =
                _dragOffsetNotifier.value >
                (screenHeight * widget.closeThreshold);

            if (isFling || isPastThreshold) {
              _close();
            } else {
              _snapBack(velocity);
            }
          } else {
            // Reset buffer if we didn't move far enough
            _accumulatedOverscroll = 0.0;
          }
        }
        return false;
      },
      child: widget.builder(
        context,
        const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );

    return AnimatedBuilder(
      animation: _dragOffsetNotifier,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _dragOffsetNotifier.value),
          child: child,
        );
      },
      child: staticContent,
    );
  }
}
