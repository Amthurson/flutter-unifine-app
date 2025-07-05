import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/font_size_provider.dart';

class FontSizePage extends StatelessWidget {
  const FontSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    double scale = fontSizeProvider.fontScale;

    return Scaffold(
      appBar: AppBar(
        title: Text('字体大小'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('完成', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Container(
              color: Colors.green[100],
              padding: EdgeInsets.all(8),
              child: Text(
                '预览字体大小',
                style: TextStyle(fontSize: 16 * scale),
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.wechat),
            title: Text(
              '拖动下面的滑块，可设置字体大小',
              style: TextStyle(fontSize: 16 * scale),
            ),
          ),
          ListTile(
            leading: Icon(Icons.wechat),
            title: Text(
              '设置后，会改变聊天和朋友圈的字体大小。如果在使用过程中存在问题或意见，可反馈给团队',
              style: TextStyle(fontSize: 16 * scale),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Text('A', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Slider(
                    value: scale,
                    min: 0.8,
                    max: 1.4,
                    divisions: 6,
                    label: scale.toStringAsFixed(2),
                    onChanged: (value) {
                      fontSizeProvider.setFontScale(value);
                    },
                  ),
                ),
                Text('A', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
