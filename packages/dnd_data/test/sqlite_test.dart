import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  test('SQLite natif disponible avec FTS5', () {
    final db = sqlite3.openInMemory();
    addTearDown(db.dispose);
    final options = db
        .select('PRAGMA compile_options')
        .map((row) => row.values.first)
        .toList();
    expect(options, contains('ENABLE_FTS5'));
    db.execute(
      "CREATE VIRTUAL TABLE t USING fts5(name, tokenize = 'unicode61 remove_diacritics 2')",
    );
    db.execute("INSERT INTO t VALUES ('Défense')");
    expect(db.select("SELECT name FROM t WHERE t MATCH 'defense'"), hasLength(1));
  });
}
