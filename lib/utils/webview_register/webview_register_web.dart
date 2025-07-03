import 'dart:ui_web' show platformViewRegistry;
import 'dart:html' as html;

final Set<String> _registeredViewTypes = {};

void registerWebViewFactory(String viewType, String url) {
  platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%';
      return iframe;
    },
  );
  _registeredViewTypes.add(viewType);
}
