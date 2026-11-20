// Spec tables : « Notes » (US-26, EF-NOT-01 à 06, [N3] à [N7]).
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/notes/note_markdown.dart';
import 'package:game_table/notes/notes_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _camille = 'camille';
const _hugo = 'hugo';

late TavernierDatabase _db;
late String _varga;
late String _s12;

/// Brumeval : séance 12 en cours, Varga ; Camille a une note privée de
/// séance et une note de table partagée ; Hugo a partagé « Dette envers
/// Brug » et garde une note privée. Les notes vues par [me].
Future<void> _open(
  WidgetTester tester, {
  String me = _camille,
  Future<void> Function(NoteStore)? seed,
}) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  await tester.runAsync(() async {
    await _db.customStatement(
      'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
      "(?, 'Camille', 'fr', '{}'), (?, 'Hugo', 'fr', '{}')",
      [_camille, _hugo],
    );
    _s12 = await SessionStore(_db).create(
      tableId: 't',
      title: 'Le relais du Sel',
      date: DateTime(2026, 10, 30),
      status: SessionStatus.inProgress,
    );
    _varga = await NpcStore(_db)
        .create(tableId: 't', name: 'Varga la Balafrée');
    final notes = NoteStore(_db);
    await notes.create(
      ownerUserId: _camille,
      tableId: 't',
      scope: 'session',
      refId: _s12,
      title: 'Préparation de la séance 12',
      content: '**Objectif** : le relais.\n- Varga attend.',
    );
    final cal = await notes.create(
      ownerUserId: _camille,
      tableId: 't',
      scope: 'table',
      title: 'Calendrier et factions',
      content: 'La Guilde du Sel contrôle les péages.',
    );
    await notes.update(cal, private: false);
    final brug = await notes.create(
      ownerUserId: _hugo,
      tableId: 't',
      scope: 'npc',
      refId: _varga,
      title: 'Dette envers Brug',
      content: 'Chasser les loups du gué.',
    );
    await notes.update(brug, private: false);
    await notes.create(
      ownerUserId: _hugo,
      tableId: 't',
      scope: 'table',
      title: 'Secret de Hugo',
      content: 'Privé.',
    );
    await seed?.call(notes);
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        databaseProvider.overrideWith((ref) => _db),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(
            User(
              id: me,
              appMetadata: const {},
              userMetadata: const {},
              aud: 'authenticated',
              createdAt: '2026-11-20T10:00:00Z',
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NotesView(tableId: 't', gm: me == _camille),
        ),
      ),
    ),
  );
  await _settle(tester);
}

/// Laisse la base finir ses écritures, hors du temps simulé du test.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await _settle(tester);
}

Future<List<Note>> _notes(WidgetTester tester, String me) async =>
    (await tester.runAsync(() => NoteStore(_db).watchVisible(me).first))!;

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

void main() {
  test('texte brut du Markdown réduit', () {
    expect(
      notePlainText('**Objectif** : voir [Varga](npc:v1).\n- Demander.'),
      'Objectif : voir Varga. Demander.',
    );
  });

  _test('[N3] : notes du MJ, filtres, note partagée par Hugo', (tester) async {
    await _open(tester);
    expect(
      find.text('3 notes sur cet appareil · recherche hors-ligne'),
      findsOneWidget,
    );
    expect(find.text('Secret de Hugo'), findsNothing);
    expect(find.text('Partagée par Hugo · lecture seule'), findsOneWidget);
    expect(find.text('Partagée avec la table'), findsOneWidget);
    expect(find.text('SÉANCE 1 · 30 OCT.'), findsOneWidget);
    expect(find.text('Varga la Balafrée'), findsOneWidget);

    await _tap(tester, find.text('PNJ · 1'));
    expect(find.text('Dette envers Brug'), findsOneWidget);
    expect(find.text('Calendrier et factions'), findsNothing);
  });

  _test('[N6] : recherche sans accents ni casse', (tester) async {
    await _open(tester);
    await tester.enterText(find.byType(TextField), 'GUILDÉ');
    await tester.pumpAndSettle();
    expect(find.text('1 résultat · recherche hors-ligne'), findsOneWidget);
    expect(find.text('Calendrier et factions'), findsOneWidget);
    expect(find.text('Dette envers Brug'), findsNothing);
  });

  _test('[N5] : nouvelle note, lien, partage', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Nouvelle note'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Titre'),
      'Ce que le loup portait',
    );
    final body = find.widgetWithText(TextField, 'Texte');
    await tester.enterText(body, 'Un sceau. En parler à ');
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Lien vers un PNJ ou une rencontre'));
    await tester.enterText(find.byType(TextField).last, 'varga');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Varga la Balafrée').last);
    await _tap(tester, find.text('Partager avec la table'));
    await _tap(tester, find.text('Enregistrer'));

    final note = (await _notes(
      tester,
      _camille,
    )).firstWhere((n) => n.title == 'Ce que le loup portait');
    expect(
      note.content,
      'Un sceau. En parler à [Varga la Balafrée](npc:$_varga)',
    );
    expect(note.private, isFalse);
    // Rattachée à la séance en cours.
    expect((note.scope, note.refId), ('session', _s12));
  });

  _test('note de Hugo : lecture seule pour le MJ', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Dette envers Brug'));
    expect(find.text('Partagée par Hugo · lecture seule'), findsOneWidget);
    expect(find.text('Chasser les loups du gué.'), findsOneWidget);
    expect(find.text('Enregistrer'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  _test('Hugo voit ses notes et celles partagées, pas les privées du MJ', (
    tester,
  ) async {
    await _open(tester, me: _hugo);
    expect(find.text('Secret de Hugo'), findsOneWidget);
    expect(find.text('Calendrier et factions'), findsOneWidget);
    expect(find.text('Préparation de la séance 12'), findsNothing);
    expect(find.text('Partagée par Camille · lecture seule'), findsOneWidget);
  });

  _test('[EF-NOT-06] : conflit signalé puis fusionné', (tester) async {
    late String id;
    await _open(
      tester,
      seed: (notes) async {
        id = await notes.create(
          ownerUserId: _camille,
          tableId: 't',
          scope: 'table',
          title: 'Récompenses',
          content: 'Potion pour Mira.',
        );
        await _db.customStatement(
          "UPDATE note SET conflict = 'Langue géant pour Aldric.' "
          'WHERE id = ?',
          [id],
        );
      },
    );
    expect(find.text('Deux versions à fusionner'), findsOneWidget);
    await _tap(tester, find.text('Récompenses'));
    expect(
      find.text('Une autre version a été écrite sur un autre appareil'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Ajouter à mon texte'));
    final note = (await _notes(tester, _camille)).firstWhere((n) => n.id == id);
    expect(note.content, 'Potion pour Mira.\n\nLangue géant pour Aldric.');
    expect(note.conflict, isNull);
  });
}
