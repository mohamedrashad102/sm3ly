import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  static const String id = 'about us screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.textButton,
        elevation: 0,
        title: const CustomText(text: "About Us"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
              child: Image.asset(
            "assets/images/us.jpg",
            height: 300,
            width: 300,
          )),
          Container(
              alignment: Alignment.center,
              height: 50,
              width: 120,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Colors.deepPurple.shade500),
              child: const CustomText(
                fontWeight: FontWeight.normal,
                text: "Our team",
                fontSize: 20,
              )),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "1- Mohamed Rashad",
                color: MyColors.gradient1,
              ),
              CustomText(
                text: "2- Mohamed Abdelmaboud",
                color: MyColors.gradient1,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1,
              endIndent: 35,
              indent: 35,
              color: MyColors.textButton,
            ),
          ),
          const SizedBox(
          //  alignment: Alignment.,
            width: 270,
            child: CustomText(
                color: MyColors.gradient1,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                text:
                    "We are students at the Faculty of Computers and Information, Zagazig University in the third-year."),
          )
        ],
      ),
    );
  }
}
