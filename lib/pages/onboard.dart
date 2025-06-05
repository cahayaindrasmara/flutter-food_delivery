import 'package:flutter/material.dart';
import 'package:food_delivery/widget/content_model.dart';
import 'package:food_delivery/widget/widget_support.dart';
import 'package:food_delivery/pages/signup.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        contents[i].title,
                        style: AppWidget.semiBoldTextFieldStyle(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        contents[i].description,
                        style: AppWidget.lightTextFieldStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              } else {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                );
              }
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722), // warna oren
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                currentIndex == contents.length - 1 ? "Start" : "Next",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
