import 'package:dartz/dartz.dart';
import 'package:example/app/search/domain/errors/erros.dart';
import 'package:example/app/search/infra/datasources/search_datasource.dart';
import 'package:example/app/search/infra/models/result_model.dart';
import 'package:example/app/search/infra/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SearchDatasourceMock extends Mock implements SearchDatasource {}

main() {
  final datasource = SearchDatasourceMock();
  final repository = SearchRepositoryImpl(datasource);

  test('deve retornar uma lista de ResultModel', () async {
    when(() => datasource.searchText('jacob'))
        .thenAnswer((_) async => <ResultModel>[
              ResultModel(image: '', name: '', nickname: '', url: ''),
            ]);

    var result = await repository.getUsers("jacob");
    expect(result | [], isA<List<ResultModel>>());
  });

  test('deve retornar um ErrorSearch caso seja lançado throw no datasource',
      () async {
    when(() => datasource.searchText('jacob')).thenThrow(ErrorSearch());

    var result = await repository.getUsers("jacob");
    final error = result.fold<Failure?>(id, (_) => null);
    expect(error, isA<ErrorSearch>());
  });
  test(
      'deve retornar um DatasourceResultNull caso o retorno do datasource seja nulo',
      () async {
    when(() => datasource.searchText('jacob')).thenAnswer((_) async => null);

    var result = await repository.getUsers("jacob");
    final error = result.fold<Failure?>(id, (_) => null);
    expect(error, isA<DatasourceResultNull>());
  });
}
