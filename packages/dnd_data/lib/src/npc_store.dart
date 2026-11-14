import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Attitude d'un PNJ envers le groupe (EF-ACT-06).
enum Attitude {
  friendly,
  indifferent,
  hostile;

  static Attitude parse(String? code) =>
      values.asNameMap()[code] ?? indifferent;
}

/// Palier d'information cachée, révélé par l'Étude (EF-PNJ-03).
final class HiddenInfo {
  const HiddenInfo({
    required this.dc,
    required this.text,
    this.revealed = false,
  });

  factory HiddenInfo.fromJson(Map<String, Object?> json) => HiddenInfo(
    dc: json['dc']! as int,
    text: json['text']! as String,
    revealed: json['revealed'] as bool? ?? false,
  );

  final int dc;
  final String text;
  final bool revealed;

  Map<String, Object?> toJson() => {
    'dc': dc,
    'text': text,
    'revealed': revealed,
  };
}

/// PNJ d'une table : bloc de stats ([monsterId], [statBlock]) ou fiche
/// complète ([characterId]).
final class Npc {
  const Npc({
    required this.id,
    required this.tableId,
    required this.name,
    required this.attitude,
    required this.hiddenInfo,
    this.folder,
    this.monsterId,
    this.statBlock,
    this.characterId,
  });

  final String id;
  final String tableId;
  final String name;
  final String? folder;
  final String? monsterId;
  final Map<String, Object?>? statBlock;
  final String? characterId;
  final Attitude attitude;
  final List<HiddenInfo> hiddenInfo;
}

/// PNJ du MJ (US-18, EF-PNJ-01 à 03, EF-ACT-06).
final class NpcStore {
  NpcStore(this._db);

  final TavernierDatabase _db;

  static String _hidden(List<HiddenInfo> info) =>
      jsonEncode([for (final h in info) h.toJson()]);

  Future<void> _write(String sql, List<Object?> args) => _db.customUpdate(
    sql,
    variables: [for (final arg in args) Variable<Object>(arg)],
    updates: {_db.npcStatblocks},
  );

  /// Crée un PNJ ; rend son identifiant.
  Future<String> create({
    required String tableId,
    required String name,
    String? folder,
    String? monsterId,
    Map<String, Object?>? statBlock,
    String? characterId,
    Attitude attitude = Attitude.indifferent,
    List<HiddenInfo> hiddenInfo = const [],
  }) async {
    final id = uuidV7();
    await _write(
      'INSERT INTO npc_statblock (id, table_id, name, folder, monster_id, '
      'stat_block, character_id, attitude, hidden_info, created_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        id,
        tableId,
        name,
        folder,
        monsterId,
        statBlock == null ? null : jsonEncode(statBlock),
        characterId,
        attitude.name,
        _hidden(hiddenInfo),
        DateTime.now().toUtc().toIso8601String(),
      ],
    );
    return id;
  }

  /// Modifie les champs donnés ; [clearFolder] sort le PNJ de son dossier.
  Future<void> update(
    String id, {
    String? name,
    String? folder,
    bool clearFolder = false,
    Map<String, Object?>? statBlock,
    Attitude? attitude,
    List<HiddenInfo>? hiddenInfo,
  }) async {
    final columns = <String, Object?>{
      'name': ?name,
      if (clearFolder) 'folder': null else 'folder': ?folder,
      if (statBlock != null) 'stat_block': jsonEncode(statBlock),
      'attitude': ?attitude?.name,
      if (hiddenInfo != null) 'hidden_info': _hidden(hiddenInfo),
    };
    if (columns.isEmpty) return;
    await _write(
      'UPDATE npc_statblock SET '
      '${columns.keys.map((c) => '$c = ?').join(', ')} WHERE id = ?',
      [...columns.values, id],
    );
  }

  /// Copie [id] sous « nom (copie) », dans le même dossier ; rend
  /// l'identifiant de la copie. Une fiche complète liée n'est pas copiée.
  Future<String> duplicate(String id) async {
    final copy = uuidV7();
    await _write(
      'INSERT INTO npc_statblock (id, table_id, name, folder, monster_id, '
      'stat_block, attitude, hidden_info, created_at) '
      "SELECT ?, table_id, name || ' (copie)', folder, monster_id, "
      'stat_block, attitude, hidden_info, ? FROM npc_statblock WHERE id = ?',
      [copy, DateTime.now().toUtc().toIso8601String(), id],
    );
    return copy;
  }

  Future<void> delete(String id) =>
      _write('DELETE FROM npc_statblock WHERE id = ?', [id]);

  /// PNJ de [tableId], par dossier (sans dossier en dernier) puis par nom.
  Stream<List<Npc>> watchList(String tableId) => _db
      .customSelect(
        'SELECT * FROM npc_statblock WHERE table_id = ? '
        'ORDER BY folder IS NULL, folder COLLATE NOCASE, name COLLATE NOCASE',
        variables: [Variable.withString(tableId)],
        readsFrom: {_db.npcStatblocks},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            Npc(
              id: row.read<String>('id'),
              tableId: row.read<String>('table_id'),
              name: row.read<String>('name'),
              folder: row.readNullable<String>('folder'),
              monsterId: row.readNullable<String>('monster_id'),
              statBlock: switch (row.readNullable<String>('stat_block')) {
                final json? => jsonDecode(json) as Map<String, Object?>,
                null => null,
              },
              characterId: row.readNullable<String>('character_id'),
              attitude: Attitude.parse(row.readNullable<String>('attitude')),
              hiddenInfo: [
                for (final h in jsonDecode(
                  row.readNullable<String>('hidden_info') ?? '[]',
                ) as List<Object?>)
                  HiddenInfo.fromJson(h! as Map<String, Object?>),
              ],
            ),
        ],
      );
}
