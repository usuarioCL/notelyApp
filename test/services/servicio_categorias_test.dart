import 'package:flutter_test/flutter_test.dart';
import 'package:notely_app/services/index.dart';

void main() {
  group('ServicioCategorias', () {
    late ServicioCategorias servicio;

    setUp(() {
      servicio = ServicioCategorias();
    });

    test('Obtener categorías disponibles', () {
      final categorias = servicio.obtenerCategorias();

      expect(categorias, isNotEmpty);
      expect(categorias.length, equals(4));
      expect(categorias, contains('General'));
      expect(categorias, contains('Personal'));
      expect(categorias, contains('Trabajo'));
      expect(categorias, contains('Ideas'));
    });

    test('Verificar categoría válida', () {
      expect(servicio.esCategoriasValida('General'), isTrue);
      expect(servicio.esCategoriasValida('Personal'), isTrue);
      expect(servicio.esCategoriasValida('Trabajo'), isTrue);
      expect(servicio.esCategoriasValida('Ideas'), isTrue);
    });

    test('Rechazar categoría inválida', () {
      expect(servicio.esCategoriasValida('Inválida'), isFalse);
      expect(servicio.esCategoriasValida(''), isFalse);
      expect(servicio.esCategoriasValida('Otro'), isFalse);
    });

    test('Obtener categoría por defecto', () {
      final categoriaDefault = servicio.obtenerCategoriaDefault();

      expect(categoriaDefault, equals('General'));
    });

    test('Categorías no se modifican', () {
      final categorias1 = servicio.obtenerCategorias();
      final categorias2 = servicio.obtenerCategorias();

      expect(categorias1, equals(categorias2));
    });
  });
}
