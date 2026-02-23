import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: value.when(
        data: (d) => KeyedSubtree(
          key: const ValueKey('data'),
          child: data(d),
        ),
        error: (e, st) =>
            error?.call(e, st) ??
            Center(
              key: const ValueKey('error'),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 48,
                      color: CupertinoColors.destructiveRed,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '加载失败',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 24),
                      CupertinoButton.filled(
                        onPressed: onRetry,
                        child: const Text('重试'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        loading:
            () =>
                loading?.call() ??
                const Center(
                  key: ValueKey('loading'),
                  child: CupertinoActivityIndicator(),
                ),
      ),
    );
  }
}
