import 'package:meong_g/features/home/domain/entity/meong_g.dart';

abstract class MeongGRepository {
  Future<List<MeongG>> fetchMeongGs();
}
