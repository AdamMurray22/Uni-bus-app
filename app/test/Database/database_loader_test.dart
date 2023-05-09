import 'package:app/Database/database_loader.dart';
import 'package:test/test.dart';

void main() {
  group('Database Loader Tests', () {

    test('.getDataBaseLoader() Returns same handler', () {
      DatabaseLoader loaderOne = DatabaseLoader.getDataBaseLoader();
      DatabaseLoader loaderTwo = DatabaseLoader.getDataBaseLoader();
      expect(loaderOne, loaderTwo);
    });
  });
}
