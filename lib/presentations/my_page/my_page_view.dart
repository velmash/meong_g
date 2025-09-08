import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/theme/m_toast.dart';
import 'my_page_viewmodel.dart';
import 'widgets/my_page_header_view.dart';
import 'widgets/user_profile_card_view.dart';
import 'widgets/pet_section_view.dart';
import 'widgets/menu_section_view.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(myPageViewModelProvider.notifier);
      viewModel.checkLoginStatus();
      viewModel.getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageViewModelProvider);
    final viewModel = ref.read(myPageViewModelProvider.notifier);

    return Container(
      color: AppStyles.gray50,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyPageHeaderView(),
            const SizedBox(height: 34),

            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              UserProfileCardView(
                nickname: state.userInfo?.nickname,
                introduction: state.userInfo?.introduction,
                onEditTap: () =>
                    Navigator.of(context).pushNamed('/user-register'),
              ),

            const SizedBox(height: 28),

            PetSectionView(
              petCount: state.petCount,
              onAddPetTap: () =>
                  Navigator.of(context).pushNamed('/pet-register'),
            ),

            const SizedBox(height: 20),

            MenuSectionView(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
