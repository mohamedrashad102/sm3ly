import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/custom_text_form_field.dart';
import 'package:sm3ly/components/font.dart';
import 'package:sm3ly/cubits/user_cubit/user_cubit.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/screens/login_screen.dart';
import '../components/custom_text.dart';
import '../cubits/user_cubit/user_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String id = 'profile screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.textButton,
        title: const CustomText(
          text: "Profile",
          fontSize: 30,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSuccessSignOutState) {
            Navigator.pushNamed(context, LoginScreen.id);
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
          var currentUser = UserCubit.get(context).currentUser;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: MyColors.textButton)),
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),
                              ),
                              Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MyColors.textButton,
                                  ),
                                  height: 30,
                                  width: 30,
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      color: Colors.white,
                                      Icons.add_a_photo_outlined,
                                      size: 20,
                                    ),
                                  )),
                            ]),
                      ]),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  text: '   Name',
                  color: MyColors.gradient1,
                  fontSize: 20,
                ),
                CustomTextFormField(
                  controller: TextEditingController(text: currentUser.username),
                  enabled: false,
                  textStyle: MyFonts.englishFont(
                    color: MyColors.textButton,
                  ),
                ),
                const SizedBox(height: 20),
                const CustomText(
                  text: '   Email',
                  color: MyColors.gradient1,
                  fontSize: 20,
                ),
                CustomTextFormField(
                  controller: TextEditingController(text: currentUser.email),
                  enabled: false,
                  textStyle: MyFonts.englishFont(
                    color: MyColors.textButton,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(
                      text:
                          "The number of words : ${currentUser.totalNumberOfWords - currentUser.totalNumberOfClasses}",
                      fontSize: 17,
                      color: MyColors.textButton,
                    ),
                    const Spacer(),
                    CustomText(
                      text: "(${currentUser.totalNumberOfClasses} Classes)",
                      fontSize: 17,
                      color: MyColors.textButton,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          width: double.infinity,
          color: MyColors.textButton,
          child: MaterialButton(
            onPressed: () async => UserCubit.get(context).logout(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "log out",
                  color: Colors.white,
                  fontSize: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
