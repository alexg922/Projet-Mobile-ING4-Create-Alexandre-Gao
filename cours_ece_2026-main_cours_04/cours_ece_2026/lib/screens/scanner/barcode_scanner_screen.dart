import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:formation_flutter/res/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Returns true if camera-based scanning is supported.
/// Supported on: Android, iOS, Web (Chrome/Edge use getUserMedia).
/// Falls back to manual input on: Windows/macOS/Linux native desktop.
bool get _supportsCameraScanning {
  if (kIsWeb) return true; // Web browsers support camera via getUserMedia
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final _barcodeController = TextEditingController();
  MobileScannerController? _cameraController;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    if (_supportsCameraScanning) {
      _cameraController = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      _hasScanned = true;
      Navigator.of(context).pop(barcodes.first.rawValue);
    }
  }

  void _submitManual() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      Navigator.of(context).pop(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_supportsCameraScanning) {
      return _buildCameraScanner();
    } else {
      return _buildManualInput();
    }
  }

  /// Camera-based scanner for Android/iOS/Web
  Widget _buildCameraScanner() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController!,
            onDetect: _onDetect,
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
          // Scan frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.yellow, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Bottom text
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: const Text(
              'Placez le code-barres dans le cadre',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Manual barcode input for native Desktop (Windows/macOS/Linux)
  Widget _buildManualInput() {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        toolbarHeight: 54,
        title: const Text(
          'Scanner un produit',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppColors.blue, size: 28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.qr_code_scanner, size: 100, color: AppColors.blue.withAlpha(80)),
            const SizedBox(height: 30),
            const Text(
              'Entrez un code-barres',
              style: TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Sur Chrome/Edge ou téléphone, la caméra s\'active.\nSur Windows natif, entrez le code manuellement.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Avenir', fontSize: 13, color: AppColors.grey3),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitManual(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.qr_code, color: AppColors.blue),
                  hintText: 'Ex: 3017620422003',
                  hintStyle: TextStyle(color: AppColors.greyPlaceholder, fontFamily: 'Avenir', fontSize: 14),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.greyBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.greyBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.yellow)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 275,
              height: 45,
              child: ElevatedButton(
                onPressed: _submitManual,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.blue,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rechercher', style: TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.w900, fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.search, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Codes-barres rapides :', style: TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.blue)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _QuickBarcode(code: '3017620422003', label: 'Nutella', onTap: (c) { _barcodeController.text = c; _submitManual(); }),
                _QuickBarcode(code: '5449000000996', label: 'Coca-Cola', onTap: (c) { _barcodeController.text = c; _submitManual(); }),
                _QuickBarcode(code: '7622210449283', label: 'Oreo', onTap: (c) { _barcodeController.text = c; _submitManual(); }),
                _QuickBarcode(code: '3046920022651', label: 'Lindt', onTap: (c) { _barcodeController.text = c; _submitManual(); }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickBarcode extends StatelessWidget {
  const _QuickBarcode({required this.code, required this.label, required this.onTap});
  final String code;
  final String label;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontFamily: 'Avenir', fontSize: 12, color: AppColors.blue)),
      backgroundColor: AppColors.yellow.withAlpha(50),
      side: BorderSide(color: AppColors.yellow),
      onPressed: () => onTap(code),
    );
  }
}
