import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/settings_column_item.dart';
import 'package:sm3ly/components/settings_row_item.dart';
import 'package:sm3ly/cubits/user_cubit/user_cubit.dart';
import 'package:sm3ly/cubits/user_cubit/user_states.dart';
import 'package:sm3ly/helpers/show_snack_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:sm3ly/constant.dart';
import '../components/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String id = 'settings screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textButton,
        title: const CustomText(
          text: 'Settings',
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserErrorState) {
            showSnackBar(context, text: state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyColors.textButton,
              ),
            );
          }
          var cubit = UserCubit.get(context);
          return SettingsColumnItem(
            children: [
              // Speaker Speed
              SettingsRowItem(
                title: 'Speaker Speed',
                trailing: Row(
                  children: [
                    // Increment
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: MyColors.textButton, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () => cubit.incrementSpeakerSpeed(context),
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Speed value
                    Container(
                      width: 50,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: MyColors.textButton,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: cubit.currentUser.speakerSpeed.toString(),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // decrement
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: MyColors.textButton, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () => cubit.decrementSpeakerSpeed(context),
                        icon: const Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Voice Type
              SettingsRowItem(
                title: 'Voice Type',
                trailing: state is UserChangeVoiceTypeLoadingState
                    ? const Row(
                      children: [
                         CircularProgressIndicator(
                            color: MyColors.textButton,
                          ),
                          SizedBox(width: 61),
                      ],
                    )
                    : ToggleSwitch(
                        initialLabelIndex: cubit.currentUser.isMale ? 0 : 1,
                        activeBgColors: const [
                          [Colors.blue],
                          [Colors.pink]
                        ],
                        totalSwitches: 2,
                        labels: const [
                          'Male',
                          'Female',
                        ],
                        onToggle: (index) =>
                            cubit.voiceTypeOnToggle(context, index!),
                      ),
              ),
              // Language
              SettingsRowItem(
                title: 'Language',
                trailing: ToggleSwitch(
                  initialLabelIndex: cubit.currentUser.isArabic ? 0 : 1,
                  activeBgColor: const [MyColors.textButton],
                  totalSwitches: 2,
                  labels: const [
                    'Arabic',
                    'English',
                  ],
                  onToggle: cubit.languageOnToggle,
                ),
              ),

              // Appearance
              SettingsRowItem(
                title: 'Appearance',
                trailing: ToggleSwitch(
                  initialLabelIndex: cubit.currentUser.isDarkMode ? 1 : 0,
                  activeBgColors: const [
                    [Colors.blue],
                    [Colors.black]
                  ],
                  totalSwitches: 2,
                  icons: const [Icons.wb_sunny_rounded, Icons.nightlight_round],
                  onToggle: (index) => cubit.appearanceOnToggle(index),
                ),
              ),
              // Change Password
              SettingsRowItem(
                onPressed: () => cubit.changePasswordOnPressed(context),
                title: 'Change Password',
                trailing: IconButton(
                  icon: const Icon(
                    Icons.lock,
                    color: MyColors.textButton,
                  ),
                  onPressed: () => cubit.changePasswordOnPressed(context),
                ),
              ),
              // Delete Account
              SettingsRowItem(
                onPressed: () => cubit.deleteAccountOnPressed(),
                title: 'Delete Account',
                trailing: IconButton(
                    onPressed: cubit.deleteAccountOnPressed,
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}
