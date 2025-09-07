import 'package:meong_g/core/domain/entities/meong_g.dart';
import 'package:meong_g/core/domain/repositories/meong_g_repository.dart';

class MeongGUseCase {
  final MeongGRepository _repository;

  MeongGUseCase(this._repository);

  Future<List<MeongG>> getMeongGs() {
    return _repository.fetchMeongGs();
  }
}
