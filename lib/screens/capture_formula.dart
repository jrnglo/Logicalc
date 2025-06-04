import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../screens/expression_input.dart'; // Import ExpressionInput screen

class CaptureFormulaScreen extends StatefulWidget {
  const CaptureFormulaScreen({super.key});

  @override
  _CaptureFormulaScreenState createState() => _CaptureFormulaScreenState();
}

class _CaptureFormulaScreenState extends State<CaptureFormulaScreen> {
  File? _image;
  String _resultText = "Tap a button to capture or select an image...";
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _requestPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _captureImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission is required!")),
      );
    }
  }

  Future<void> _captureImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    _processSelectedImage(pickedFile);
  }

  Future<void> _selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    _processSelectedImage(pickedFile);
  }

  void _processSelectedImage(XFile? pickedFile) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String base64String = base64Encode(imageFile.readAsBytesSync());

      setState(() {
        _image = imageFile;
        _isLoading = true;
      });

      _showLoadingDialog();
      await _sendImageToAPI(base64String);
    }
  }

  Future<void> _sendImageToAPI(String base64Image) async {
    const String apiUrl = "https://jamesgalos.shop/booleanjames/process_image";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"base64_image": base64Image}),
      );

      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _resultText = jsonResponse["result"] ?? "No response from API";
        });
      } else {
        setState(() {
          _resultText = "API Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("API Connection Error: $e");
      Navigator.pop(context);
      setState(() {
        _resultText = "Error connecting to API: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boolean Extractor')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, height: 250, fit: BoxFit.cover),
                    )
                        : const Icon(Icons.image, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _requestPermission,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Capture Image'),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton.icon(
                          onPressed: _selectImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Select Image'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _resultText,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _resultText.contains("Error") || _resultText == "Tap a button to capture or select an image..."
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpressionInput(
                        initialExpression: _resultText,
                        autoConvert: true, // Automatically convert
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.transform),
                label: const Text('Convert Expression'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
