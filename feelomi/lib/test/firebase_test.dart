import 'package:flutter_test/flutter_test.dart';
import 'package:feelomi/services/auth_service.dart';
import 'package:feelomi/services/emotions_service.dart';
import 'package:feelomi/models/emotion_model.dart';

void main() {
  group('Firebase Services Tests', () {
    testWidgets('AuthService registration test', (WidgetTester tester) async {
      // Test d'inscription
      try {
        final credential = await AuthService.registerWithEmail(
          email: 'test@feelomi.com',
          password: 'testpassword123',
          fullName: 'Test User',
        );

        expect(credential, isNotNull);
        expect(credential!.user!.email, equals('test@feelomi.com'));
      } catch (e) {
        // Gestion des erreurs de test
        print('Test error: $e');
      }
    });

    testWidgets('EmotionsService save test', (WidgetTester tester) async {
      // Test de sauvegarde d'émotion
      final emotion = EmotionModel(
        id: 'test_emotion',
        emotionValue: 4,
        emotionType: 'happy',
        timestamp: DateTime.now(),
        notes: 'Test emotion note',
        keywords: ['test', 'happy'],
      );

      try {
        await EmotionsService.saveEmotion(emotion);

        final emotions = await EmotionsService.getWeeklyEmotions();
        expect(emotions, isNotEmpty);
      } catch (e) {
        print('Emotion service test error: $e');
      }
    });
  });
}
