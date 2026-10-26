// Spike T-01 : vérification manuelle de la persistance après fermeture du
// navigateur. `flutter run` ouvre un profil temporaire, qui ne survit pas à
// la fermeture : compiler avec `fvm flutter build web -t
// tool/t01_persistence.dart`, servir le dossier sur un port fixe (le port
// fait partie de l'origine) et l'ouvrir dans un navigateur au profil
// dédié. Chaque lancement incrémente un compteur ; fermer le navigateur,
// relancer et vérifier que la valeur a augmenté de 1. Protocole complet :
// docs/spikes/T-01-sqlite-wasm-web.md.
import 'package:game_table/database.dart';
import 'package:game_table/persistent_storage.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = 'natif';
  final db = openTavernierDatabase(
    name: 't01_persistence',
    onWebResult: (r) => storage = r.chosenImplementation.name,
  );
  final rows = await db
      .customSelect("SELECT content FROM note WHERE id = 't01'")
      .get();
  final count = rows.isEmpty
      ? 1
      : int.parse(rows.single.read<String>('content')) + 1;
  await db.customStatement(
    'INSERT INTO note (id, owner_user_id, scope, content) '
    "VALUES ('t01', 'dev', 'table', ?) "
    'ON CONFLICT(id) DO UPDATE SET content = excluded.content',
    ['$count'],
  );
  // Firefox peut laisser la demande en attente : ne pas bloquer l'affichage.
  final persistent = await requestPersistentStorage()
      .then<Object>((g) => g)
      .timeout(const Duration(seconds: 5), onTimeout: () => 'sans_reponse');
  final line = 'T01 lancement=$count stockage=$storage persistant=$persistent';
  debugPrint(line);
  // Le titre de la page porte aussi la ligne, lisible depuis le titre de la
  // fenêtre du navigateur.
  runApp(
    Title(
      title: line,
      color: const Color(0xFF000000),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: Text(line)),
      ),
    ),
  );
}
