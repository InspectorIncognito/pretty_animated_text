import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final ValueNotifier<AnimatedTextController?> _notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    // Fresh (non-const) config every build, mirroring the demo's _buildConfig()
    // — a const instance would be canonicalized and defeat the test.
    // ignore: prefer_const_constructors
    final config = AnimationConfig(
      duration: const Duration(milliseconds: 40),
      type: AnimationType.letter,
      repeat: true,
      reverse: true,
      repeatCount: 3,
    );
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SquashBounceText(
              text: const Text('Hello World', style: TextStyle(fontSize: 20)),
              config: config,
              onControllerCreated: (c) {
                if (_notifier.value != c) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _notifier.value = c;
                  });
                }
              },
            ),
            ValueListenableBuilder<AnimatedTextController?>(
              valueListenable: _notifier,
              builder: (context, controller, _) => ListenableBuilder(
                listenable: controller ?? ChangeNotifier(),
                builder: (context, _) =>
                    Text('playing=${controller?.isAnimating ?? false}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  // Regression: rebuilding with an equivalent config must not restart the
  // animation during build (no "setState() called during build").
  testWidgets('rebuild with equivalent config does not throw during build',
      (tester) async {
    await tester.pumpWidget(const _Host());
    final state = tester.state<_HostState>(find.byType(_Host));
    for (var i = 0; i < 60; i++) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
    }
  });
}
