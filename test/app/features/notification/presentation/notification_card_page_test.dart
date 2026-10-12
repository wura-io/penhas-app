import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penhas/app/features/notification/domain/entities/notification_session_entity.dart';
import 'package:penhas/app/features/notification/presentation/pages/notification_card_page.dart';

void main() {
  NotificationEntity notificationWithTitle(String title) => NotificationEntity(
        name: 'PenhaS',
        content: 'conteudo da notificacao',
        time: DateTime(2024),
        icon: null,
        title: title,
      );

  Future<void> pumpCard(WidgetTester tester, String title,
      {Size? surface}) async {
    if (surface != null) {
      tester.view.physicalSize = surface;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCardPage(
            notification: notificationWithTitle(title),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group(NotificationCardPage, () {
    testWidgets('displays the full title without ellipsis truncation',
        (tester) async {
      const title =
          'PenhaS Teste ADM-055 | Notificacao com titulo longo e acentuacao';
      await pumpCard(tester, title);

      expect(tester.takeException(), isNull);
      final text = tester.widget<Text>(find.text(title));
      expect(text.overflow, isNot(TextOverflow.ellipsis));
      expect(text.maxLines, isNull);
    });

    testWidgets('long title wraps on narrow screens without overflow',
        (tester) async {
      const title =
          'PenhaS ADM-055 | Teste de envio - titulo bem longo com emojis e acentuacao para multiplas linhas';
      await pumpCard(tester, title, surface: const Size(320, 800));

      expect(tester.takeException(), isNull);
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('short title still renders', (tester) async {
      const title = 'Aviso';
      await pumpCard(tester, title);

      expect(tester.takeException(), isNull);
      expect(find.text(title), findsOneWidget);
    });
  });
}
