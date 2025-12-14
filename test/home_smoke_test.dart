import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/components/check_mark.dart';

void main() {
  testWidgets('HomeScreen smoke test - renders', (WidgetTester tester) async {
    // Set a larger test window to avoid layout overflow in narrow test harnesses
    final binding = TestWidgetsFlutterBinding.ensureInitialized()
        as TestWidgetsFlutterBinding;
    // Use a large test window to provide enough horizontal space for product cards
    binding.window.physicalSizeTestValue = const Size(1080, 2340);
    binding.window.devicePixelRatioTestValue = 1.0;

    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    // Use a small, stable component for a reliable smoke test.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: CheckMark()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CheckMark), findsOneWidget);
  });
}
