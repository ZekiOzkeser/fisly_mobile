import 'package:flutter/material.dart';

/// Camera overlay widget with receipt frame guidance
/// Shows animated corner guides for optimal receipt positioning
class CameraOverlayWidget extends StatefulWidget {
  const CameraOverlayWidget({super.key});

  @override
  State<CameraOverlayWidget> createState() => _CameraOverlayWidgetState();
}

class _CameraOverlayWidgetState extends State<CameraOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameWidth = size.width * 0.85;
    final frameHeight = size.height * 0.5;

    return Stack(
      children: [
        // Dark overlay
        Container(color: Colors.black.withValues(alpha: 0.5)),

        // Transparent frame area
        Center(
          child: Container(
            width: frameWidth,
            height: frameHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 2),
            ),
            child: ClipRRect(
              child: CustomPaint(
                painter: _FrameCutoutPainter(),
                child: Container(),
              ),
            ),
          ),
        ),

        // Animated corner guides
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return SizedBox(
                width: frameWidth,
                height: frameHeight,
                child: Stack(
                  children: [
                    // Top-left corner
                    Positioned(
                      top: 0,
                      left: 0,
                      child: _buildCornerGuide(
                        isTopLeft: true,
                        scale: _pulseAnimation.value,
                      ),
                    ),

                    // Top-right corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _buildCornerGuide(
                        isTopRight: true,
                        scale: _pulseAnimation.value,
                      ),
                    ),

                    // Bottom-left corner
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: _buildCornerGuide(
                        isBottomLeft: true,
                        scale: _pulseAnimation.value,
                      ),
                    ),

                    // Bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildCornerGuide(
                        isBottomRight: true,
                        scale: _pulseAnimation.value,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Instruction text
        Positioned(
          top: size.height * 0.15,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Text(
                  'Position receipt within frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Ensure all corners are visible',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build corner guide indicator
  Widget _buildCornerGuide({
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
    required double scale,
  }) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(
          painter: _CornerGuidePainter(
            isTopLeft: isTopLeft,
            isTopRight: isTopRight,
            isBottomLeft: isBottomLeft,
            isBottomRight: isBottomRight,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for frame cutout
class _FrameCutoutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for corner guides
class _CornerGuidePainter extends CustomPainter {
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  _CornerGuidePainter({
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF2563EB)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final cornerLength = size.width * 0.6;

    if (isTopLeft) {
      path.moveTo(0, cornerLength);
      path.lineTo(0, 0);
      path.lineTo(cornerLength, 0);
    } else if (isTopRight) {
      path.moveTo(size.width - cornerLength, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, cornerLength);
    } else if (isBottomLeft) {
      path.moveTo(0, size.height - cornerLength);
      path.lineTo(0, size.height);
      path.lineTo(cornerLength, size.height);
    } else if (isBottomRight) {
      path.moveTo(size.width - cornerLength, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - cornerLength);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
