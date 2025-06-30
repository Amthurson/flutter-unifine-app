import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../theme/app_theme.dart';

class FaceCollectionPage extends StatefulWidget {
  const FaceCollectionPage({super.key});

  @override
  State<FaceCollectionPage> createState() => _FaceCollectionPageState();
}

class _FaceCollectionPageState extends State<FaceCollectionPage> {
  bool _isLoading = false;

  void _startFaceCollection() async {
    setState(() {
      _isLoading = true;
    });

    // 模拟人脸采集过程
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(msg: '人脸采集完成');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('人脸采集'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.face, size: 48, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      '人脸采集',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '请按照提示进行人脸采集',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Icon(Icons.camera_alt, size: 48, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startFaceCollection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('开始采集'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
