import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/capture_controls_widget.dart';
import './widgets/extraction_results_widget.dart';
import './widgets/ocr_processing_widget.dart';
import './widgets/preview_screen_widget.dart';

/// Camera Scan Screen - Intelligent receipt capture with OCR processing
/// Provides full-screen camera overlay with frame guidance and validation workflow
class CameraScan extends StatefulWidget {
  const CameraScan({super.key});

  @override
  State<CameraScan> createState() => _CameraScanState();
}

class _CameraScanState extends State<CameraScan> with WidgetsBindingObserver {
  // Camera state
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  // Capture state
  XFile? _capturedImage;
  String? _croppedImagePath;

  // Processing state
  bool _isProcessing = false;
  double _processingProgress = 0.0;

  // OCR results state
  Map<String, dynamic>? _ocrResults;
  bool _showResults = false;

  // Screen state
  String _currentScreen = 'camera'; // camera, preview, processing, results

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  /// Initialize camera with platform-specific settings
  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionDeniedDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      // Select appropriate camera based on platform
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Apply platform-specific settings
      await _applyPlatformSettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  /// Request camera permission
  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Apply platform-specific camera settings
  Future<void> _applyPlatformSettings() async {
    if (_cameraController == null) return;

    try {
      // Auto focus (works on all platforms)
      await _cameraController!.setFocusMode(FocusMode.auto);

      // Flash mode (mobile only)
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.off);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }

      // Exposure mode
      try {
        await _cameraController!.setExposureMode(ExposureMode.auto);
      } catch (e) {
        debugPrint('Exposure mode not supported: $e');
      }
    } catch (e) {
      debugPrint('Error applying camera settings: $e');
    }
  }

  /// Toggle flash on/off
  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  /// Capture photo from camera
  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = photo;
        _currentScreen = 'preview';
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
      _showErrorSnackBar('Failed to capture photo. Please try again.');
    }
  }

  /// Select image from gallery
  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _currentScreen = 'preview';
        });
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      _showErrorSnackBar('Failed to select image from gallery.');
    }
  }

  /// Crop captured image
  Future<void> _cropImage() async {
    if (_capturedImage == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _capturedImage!.path,
      );

      if (croppedFile != null) {
        setState(() {
          _croppedImagePath = croppedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Image cropping error: $e');
      _showErrorSnackBar('Failed to crop image.');
    }
  }

  /// Process image with OCR
  Future<void> _processImage() async {
    setState(() {
      _currentScreen = 'processing';
      _isProcessing = true;
      _processingProgress = 0.0;
    });

    try {
      // Simulate OCR processing with progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 200));
        if (mounted) {
          setState(() {
            _processingProgress = i / 100;
          });
        }
      }

      // Simulate OCR extraction results
      final results = _generateMockOCRResults();

      setState(() {
        _ocrResults = results;
        _isProcessing = false;
        _currentScreen = 'results';
        _showResults = true;
      });
    } catch (e) {
      debugPrint('OCR processing error: $e');
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Failed to process receipt. Please try again.');
    }
  }

  /// Generate mock OCR results for demonstration
  Map<String, dynamic> _generateMockOCRResults() {
    return {
      'amount': {'value': '₺245.50', 'confidence': 0.95},
      'supplier': {'value': 'Migros', 'confidence': 0.88},
      'date': {'value': '13/01/2026', 'confidence': 0.92},
      'category': {
        'value': 'Market',
        'confidence': 0.85,
        'suggestions': ['Market', 'Gıda', 'Alışveriş'],
      },
      'items': [
        {'name': 'Süt', 'price': '₺35.00'},
        {'name': 'Ekmek', 'price': '₺15.00'},
        {'name': 'Peynir', 'price': '₺125.50'},
        {'name': 'Zeytin', 'price': '₺70.00'},
      ],
    };
  }

  /// Retake photo
  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _croppedImagePath = null;
      _ocrResults = null;
      _showResults = false;
      _currentScreen = 'camera';
    });
  }

  /// Save OCR results and navigate
  void _saveResults() {
    // Navigate to manual receipt entry with OCR data
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/manual-receipt-entry', arguments: _ocrResults);
  }

  /// Edit OCR field
  void _editField(String fieldName) {
    // Show edit dialog for the field
    _showEditFieldDialog(fieldName);
  }

  /// Show edit field dialog
  void _showEditFieldDialog(String fieldName) {
    final theme = Theme.of(context);
    final currentValue = _ocrResults?[fieldName]?['value'] ?? '';
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${fieldName.toUpperCase()}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldName.toUpperCase(),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ocrResults![fieldName]['value'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show permission denied dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text('Please grant camera permission to scan receipts.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show no camera dialog
  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No Camera Available'),
        content: Text('No camera was detected on this device.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show camera error dialog
  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Error'),
        content: Text('Failed to initialize camera. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: _buildCurrentScreen(theme)),
    );
  }

  /// Build current screen based on state
  Widget _buildCurrentScreen(ThemeData theme) {
    switch (_currentScreen) {
      case 'camera':
        return _buildCameraScreen(theme);
      case 'preview':
        return PreviewScreenWidget(
          imagePath: _croppedImagePath ?? _capturedImage?.path ?? '',
          onRetake: _retakePhoto,
          onCrop: _cropImage,
          onProcess: _processImage,
        );
      case 'processing':
        return OCRProcessingWidget(progress: _processingProgress);
      case 'results':
        return ExtractionResultsWidget(
          results: _ocrResults ?? {},
          onEdit: _editField,
          onSave: _saveResults,
          onRetake: _retakePhoto,
        );
      default:
        return _buildCameraScreen(theme);
    }
  }

  /// Build camera screen
  Widget _buildCameraScreen(ThemeData theme) {
    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
        ),
      );
    }

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(child: CameraPreview(_cameraController!)),

        // Camera overlay with frame guidance
        CameraOverlayWidget(),

        // Header with controls
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  tooltip: 'Close',
                ),

                // Flash toggle (mobile only)
                if (!kIsWeb)
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: _isFlashOn ? 'flash_on' : 'flash_off',
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleFlash,
                    tooltip: _isFlashOn ? 'Flash On' : 'Flash Off',
                  ),
              ],
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CaptureControlsWidget(
            onCapture: _capturePhoto,
            onGallery: _selectFromGallery,
          ),
        ),
      ],
    );
  }
}