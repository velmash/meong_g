import 'package:flutter/material.dart';
import 'package:meong_g/features/home/domain/entity/meong_g.dart';
import 'package:meong_g/features/home/presentation/view/widgets/pet_add_card.dart';
import 'package:meong_g/features/home/presentation/view/widgets/pet_info_card.dart';

class PetCarouselView extends StatelessWidget {
  final List<MeongG> meongGs;
  const PetCarouselView({super.key, required this.meongGs});

  @override
  Widget build(BuildContext context) {
    final List<Widget> meongGsCard = meongGs.map((meongG) {
      return PetInfoCardView(meongGInfo: meongG);
    }).toList();

    final List<Widget> allCards = [
      ...meongGsCard,
      PetAddCardView(
        onProfileTap: () {
          print("Pet Add Profile Clicked");
        },
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 40; // 20px 양쪽 마진
    final viewportFraction = (cardWidth + 8) / screenWidth; // 카드 너비 + 8px 간격

    return PageView.builder(
      controller: PageController(viewportFraction: viewportFraction),
      itemCount: allCards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == allCards.length - 1 ? 0 : 4),
          child: allCards[index],
        );
      },
    );
  }
}
