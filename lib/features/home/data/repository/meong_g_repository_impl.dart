import 'package:meong_g/features/home/domain/entity/meong_g.dart';
import 'package:meong_g/features/home/domain/repository/meong_g_repository.dart';

class MeongGRepositoryImpl implements MeongGRepository {
  @override
  Future<List<MeongG>> fetchMeongGs() async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 2));

    // Return a list of MeongG objects
    return [
      MeongG(
        name: "마로",
        breed: "도베르만",
        age: 31,
        imageUrl: "https://drive.google.com/file/d/1YIvJTieF1XWh63OH8LireEC3JAOWCDRZ/view?usp=sharing",
      ),
      MeongG(
        name: "요환",
        breed: "치와와",
        age: 30,
        imageUrl: "https://drive.google.com/file/d/1YIvJTieF1XWh63OH8LireEC3JAOWCDRZ/view?usp=sharing",
      ),
      MeongG(
        name: "형찬",
        breed: "진돗개",
        age: 30,
        imageUrl: "https://drive.google.com/file/d/1YIvJTieF1XWh63OH8LireEC3JAOWCDRZ/view?usp=sharing",
      ),
    ];
  }
}
