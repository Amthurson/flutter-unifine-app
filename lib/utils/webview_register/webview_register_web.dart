import 'dart:ui_web' show platformViewRegistry;
import 'dart:html' as html;

void registerWebViewFactory(String viewId, String url) {
  platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) => html.IFrameElement()
      ..src = url
      ..style.border = 'none',
  );
}
