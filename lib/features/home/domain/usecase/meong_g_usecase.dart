import 'package:meong_g/features/home/domain/entity/meong_g.dart';
import 'package:meong_g/features/home/domain/repository/meong_g_repository.dart';

class MeongGUseCase {
  final MeongGRepository _repository;

  MeongGUseCase(this._repository);

  Future<List<MeongG>> getMeongGs() {
    return _repository.fetchMeongGs();
  }
}
