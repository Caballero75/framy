import 'package:framy_generator/framy_object.dart';
import 'package:framy_generator/generator/widget_page_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Widget page generator result', () {
    test('should not generate anything when no widgets passed', () {
      final result = generateWidgetPages([], []);
      expect(result, isEmpty);
    });

    group('when a widget is passed', () {
      //given
      final widgetObjects = [
        FramyObject()
          ..name = 'MyWidget'
          ..type = FramyObjectType.widget
          ..constructors = [FramyObjectConstructor('', [])],
      ];

      test('should have a class with name FramyXXXCustomPage', () {
        final result = generateWidgetPages(widgetObjects, []);
        expect(result.contains('class FramyMyWidgetCustomPage'), isTrue);
      });

      test('should contain key Framy_XXX_Page', () {
        final result = generateWidgetPages(widgetObjects, []);
        expect(result.contains('Framy_MyWidget_Page'), isTrue);
      });

      test('should contain custom widget XXX constructor', () {
        final result = generateWidgetPages(widgetObjects, []);
        expect(result.contains('MyWidget('), isTrue);
      });
    });

    test('should contain 2 classes with proper names when 2 widgets are passed',
        () {
      //given
      final widgetObjects = [
        FramyObject()
          ..name = 'Widget1'
          ..type = FramyObjectType.widget
          ..constructors = [FramyObjectConstructor('', [])],
        FramyObject()
          ..name = 'Widget2'
          ..type = FramyObjectType.widget
          ..constructors = [FramyObjectConstructor('', [])],
      ];
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      expect(result.contains('FramyWidget1CustomPage'), isTrue);
      expect(result.contains('FramyWidget2CustomPage'), isTrue);
    });

    test(
        'should contain initialized dependencies list when widget has dependency',
        () {
      //given
      final widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
        'arg1',
        'String',
        null,
        false,
      ));
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      final expectedList =
          '''FramyDependencyModel<String>('arg1', 'String', null, createSubDependencies('String')),''';
      expect(result.contains(expectedList), isTrue);
    });

    test('should properly handle int dependency', () {
      //given
      final widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
        'arg1',
        'int',
        '13',
        false,
      ));
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      final expectedDependency =
          'FramyDependencyModel<int>(\'arg1\', \'int\', 13, createSubDependencies(\'int\')),';
      expect(result.contains(expectedDependency), isTrue);
    });

    test(
        'should use dependency in widget constructor when the non-named dependency is passed',
        () {
      //given
      final widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
        'arg1',
        'String',
        null,
        false,
      ));
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      expect(
        result.contains(RegExp('Widget1\\(\n *valueGetter\\(\'arg1\'\\)')),
        isTrue,
      );
    });

    test(
        'should use dependency in widget constructor when the named dependency is passed',
        () {
      //given
      final widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
        'arg1',
        'String',
        null,
        true,
      ));
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      expect(
        result
            .contains(RegExp('Widget1\\(\n *arg1: valueGetter\\(\'arg1\'\\)')),
        isTrue,
      );
    });

    test(
        'should use default value in dependency initialization when default value is present',
        () {
      //given
      final widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
        'arg1',
        'String',
        "'fooDefaultValue'",
        false,
      ));
      //when
      final result = generateWidgetPages(widgetObjects, []);
      //then
      expect(
        result.contains(RegExp('FramyDependencyModel.*\'fooDefaultValue\'')),
        isTrue,
      );
    });

    group('when the provider parameter is passed', () {
      List<FramyObject> widgetObjects;

      setUp(() {
        widgetObjects = getFramyObjectWithDependency(FramyObjectDependency(
          'String',
          'String',
          null,
          false,
          dependencyType: FramyDependencyType.provider,
        ));
      });

      test('it should contain the generation of the dependency model', () {
        //when
        final result = generateWidgetPages(widgetObjects, []);
        //then
        expect(
          result.contains(
              'FramyDependencyModel<String>(\'String\', \'String\', null, createSubDependencies(\'String\'))'),
          isTrue,
        );
      });

      test('it should contain MultiProvider', () {
        //when
        final result = generateWidgetPages(widgetObjects, []);
        //then
        expect(result.contains('MultiProvider'), isTrue);
      });

      test('it contain a Provider with the proper type using proper dependency',
          () {
        //when
        final result = generateWidgetPages(widgetObjects, []);
        //then
        expect(
          result.contains(
              'Provider<String>.value(value: valueGetter(\'String\')),'),
          isTrue,
        );
      });
    });
  });
}

List<FramyObject> getFramyObjectWithDependency(
    FramyObjectDependency dependency) {
  return [
    FramyObject()
      ..name = 'Widget1'
      ..type = FramyObjectType.widget
      ..constructors = [
        FramyObjectConstructor('', [dependency])
      ],
  ];
}
