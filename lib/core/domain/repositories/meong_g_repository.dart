import 'package:meong_g/core/domain/entities/meong_g.dart';

abstract class MeongGRepository {
  Future<List<MeongG>> fetchMeongGs();
}
