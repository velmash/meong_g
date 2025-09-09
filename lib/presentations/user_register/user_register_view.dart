import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/theme/m_toast.dart';

import 'user_register_viewmodel.dart';
import 'widgets/profile_image_widget.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/user_register_app_bar.dart';

class UserRegisterView extends ConsumerStatefulWidget {
  final UserInfo? userInfo;

  const UserRegisterView({super.key, this.userInfo});

  @override
  ConsumerState<UserRegisterView> createState() => _UserRegisterViewState();
}

class _UserRegisterViewState extends ConsumerState<UserRegisterView> {
  late final TextEditingController nameController;
  late final TextEditingController introductionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.userInfo?.nickname ?? '',
    );
    introductionController = TextEditingController(
      text: widget.userInfo?.introduction ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    introductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userRegisterViewModelProvider(widget.userInfo));
    final viewModel = ref.read(
      userRegisterViewModelProvider(widget.userInfo).notifier,
    );

    // 에러 메시지가 있을 때 스낵바 표시
    ref.listen(userRegisterViewModelProvider(widget.userInfo), (
      previous,
      next,
    ) {
      if (next.errorMessage.isNotEmpty &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () => viewModel.clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UserRegisterAppBar(
        isLoading: state.isLoading,
        isValid: state.isValid,
        onComplete: () async {
          await viewModel.saveUserProfile();
          if (context.mounted &&
              !state.isLoading &&
              state.errorMessage.isEmpty) {
            Navigator.of(context).pop();
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text(
                "프로필 편집",
                style: TextStyle(
                  color: AppStyles.gray900,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileSection(viewModel, state),
              const SizedBox(height: 24),
              _buildFormSection(viewModel),
              const SizedBox(height: 24),
              _buildAuthTypeSection(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserRegisterViewModel viewModel, state) {
    return ProfileImageWidget(
      imagePath: state.profileImagePath ?? state.userInfo?.profileImageFileName,
      onTap: () => _showImagePickerOptions(viewModel),
    );
  }

  Widget _buildFormSection(UserRegisterViewModel viewModel) {
    return Column(
      children: [
        CustomTextField(
          label: "이름",
          hintText: "이름을 입력하세요",
          controller: nameController,
          onChanged: viewModel.updateName,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: "한줄소개",
          hintText: "나를 소개하는 한마디를 적어주세요.",
          controller: introductionController,
          onChanged: viewModel.updateIntroduction,
        ),
      ],
    );
  }

  Widget _buildAuthTypeSection(state) {
    if (state.authTypeDisplayText.isEmpty) return const SizedBox.shrink();

    return Text(
      state.authTypeDisplayText,
      style: const TextStyle(
        color: AppStyles.gray400,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _showImagePickerOptions(UserRegisterViewModel viewModel) {
    final state = ref.read(userRegisterViewModelProvider(widget.userInfo));
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                Mtoast.show(context, "갤러리 선택 구현 예정");
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                Mtoast.show(context, "카메라 촬영 구현 예정");
              },
            ),
            if (state.profileImagePath != null ||
                state.userInfo?.profileImageFileName != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('사진 삭제', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.updateProfileImage(null);
                },
              ),
          ],
        ),
      ),
    );
  }
}
