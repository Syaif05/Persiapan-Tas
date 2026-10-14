import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class CategoriesRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  CategoriesRepository(this._db);

  Stream<List<CategoryEntry>> watchAllCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder), (c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<List<CategoryEntry>> getAllCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder), (c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Future<CategoryEntry?> getCategoryByName(String name) {
    return (_db.select(_db.categories)..where((c) => c.name.equals(name.trim())))
        .getSingleOrNull();
  }

  Future<CategoryEntry> getOrCreateCategory(String name) async {
    final existing = await getCategoryByName(name);
    if (existing != null) return existing;

    final newId = _uuid.v4();
    await _db.into(_db.categories).insert(
      CategoriesCompanion.insert(
        id: newId,
        name: name.trim(),
        sortOrder: const Value(99),
      ),
    );
    return (await getCategoryByName(name))!;
  }
}
