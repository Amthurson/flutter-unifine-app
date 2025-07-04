# NavigationBarWidget WebView 历史状态监听

## 概述

本次修改为 `NavigationBarWidget` 添加了 WebView 历史状态监听功能，使其能够根据 WebView 的历史状态动态显示或隐藏返回按钮。

## 主要修改

### 1. NavigationBarWidget 修改

#### 新增属性
- `bool _canGoBack = false` - 跟踪 WebView 是否可以返回

#### 新增方法
- `_checkWebViewHistory()` - 检查 WebView 历史状态
- `updateWebViewHistory(bool canGoBack)` - 更新历史状态（供外部调用）

#### 修改的方法
- `_shouldShowBack` - 从 `Future<bool>` 改为同步的 `bool` 计算属性
- `_onBackPressed()` - 在返回操作后检查历史状态

### 2. BridgeWebViewWidget 修改

#### 新增导航监听
- `onPageStarted` - 页面开始加载时触发
- `onNavigationRequest` - 导航请求时触发
- `onUrlChange` - URL 变化时触发

#### 新增方法
- `_updateNavigationBarHistory()` - 更新导航栏历史状态

#### 修改的导航委托
```dart
_controller.setNavigationDelegate(
  NavigationDelegate(
    onPageStarted: (String url) {
      widget.onPageStarted?.call(url);
    },
    onPageFinished: (String url) async {
      widget.onPageFinished?.call(url);
      
      if (_isInitialized) {
        // 页面加载完成后检查历史状态
        _updateNavigationBarHistory();
        return;
      }
      
      // ... 初始化逻辑 ...
      
      // 初始化完成后检查历史状态
      _updateNavigationBarHistory();
    },
    onNavigationRequest: (NavigationRequest request) {
      widget.onNavigationRequest?.call(request.url);
      return NavigationDecision.navigate;
    },
    onUrlChange: (UrlChange change) {
      // URL 变化时检查历史状态
      _updateNavigationBarHistory();
    },
  ),
);
```

## 工作原理

### 1. 初始化阶段
- Widget 初始化时通过 `addPostFrameCallback` 检查 WebView 历史状态
- 如果 WebView 控制器存在，调用 `canGoBack()` 获取历史状态

### 2. 导航监听
- 页面开始加载时检查历史状态
- 页面加载完成时检查历史状态
- URL 变化时检查历史状态
- 导航请求时检查历史状态

### 3. 状态更新
- 通过 `updateWebViewHistory(bool canGoBack)` 方法更新状态
- 只有当状态真正发生变化时才触发 `setState()`
- 确保 Widget 只在必要时重建

### 4. 返回操作
- 用户点击返回按钮时，先执行返回操作
- 返回操作完成后，再次检查历史状态
- 确保返回按钮的显示状态与实际历史状态同步

## 使用示例

### 基本使用
```dart
NavigationBarWidget(
  key: _navKey,
  title: '页面标题',
  showBack: true,
  onBack: (context) async {
    // 自定义返回逻辑
    final canGoBack = await webViewController.canGoBack();
    if (canGoBack) {
      await webViewController.goBack();
    } else {
      Navigator.pop(context);
    }
  },
)
```

### 与 WebView 集成
```dart
Column(
  children: [
    NavigationBarWidget(
      key: _navKey,
      title: 'WebView 页面',
      showBack: true,
    ),
    Expanded(
      child: CompatibleWebView(
        url: 'https://example.com',
        navKey: _navKey,
        webViewController: _webViewController,
      ),
    ),
  ],
)
```

## 测试

创建了测试页面 `TestBackButtonPage` 来验证功能：

1. 访问 `/test-back` 路由
2. 页面会加载百度首页
3. 初始状态下返回按钮应该隐藏（因为没有历史）
4. 点击链接导航到其他页面后，返回按钮应该显示
5. 点击返回按钮应该回到上一页
6. 回到首页后，返回按钮应该再次隐藏

## 注意事项

1. **错误处理**: 如果 WebView 控制器不存在，会忽略错误并继续运行
2. **性能优化**: 只在状态真正变化时才触发重建
3. **线程安全**: 使用 `mounted` 检查确保 Widget 仍然存在
4. **兼容性**: 保持与现有代码的完全兼容性

## 解决的问题

1. **类型错误**: 修复了 `Future<bool>` 在 Widget build 方法中的使用问题
2. **状态同步**: 确保返回按钮状态与 WebView 历史状态同步
3. **用户体验**: 提供更准确的导航反馈
4. **代码质量**: 提高了代码的可维护性和可读性 