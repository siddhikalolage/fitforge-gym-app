import 'package:flutter_test/flutter_test.dart';
import 'package:fitforge_ai/main.dart';

void main() {
  testWidgets('shows onboarding when no profile exists', (tester) async {
    await tester.pumpWidget(const GymApp(hasUser: false));

    expect(find.text('Welcome to FitForge'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
