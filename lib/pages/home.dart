import 'package:flutter/material.dart';
import 'package:food_delivery/pages/details.dart';
import '../widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool iceCream = false, pizza = false, salad = false, burger = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello Cahaya!", style: AppWidget.boldTextFieldStyle()),
                Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text("Delicious Food", style: AppWidget.headLineTextFieldStyle()),
            Text(
              "Discover and get great food",
              style: AppWidget.lightTextFieldStyle(),
            ),
            const SizedBox(height: 20.0),
            Container(margin: const EdgeInsets.only(right: 20.0), child: showItem()),
            const SizedBox(height: 30.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Details()),
                      );
                    },
                    child: foodCard("images/salad2.png", "Veggie Taco Hash", "Fresh and Healthy", "\$25"),
                  ),
                  const SizedBox(width: 15.0),
                  foodCard("images/salad3.png", "Mix Veg Salad", "Spicy with Onion", "\$28"),
                  const SizedBox(width: 15.0),
                  foodCard("images/salad4.png", "Mix Veg Salad", "Spicy with Onion", "\$28"),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/salad2.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Mediterranean Chickpea Salad",
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Honey Got Cheese",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "\$28",
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryItem("images/ice-cream.png", iceCream, () {
          setState(() {
            iceCream = true;
            pizza = false;
            salad = false;
            burger = false;
          });
        }),
        categoryItem("images/burger.png", burger, () {
          setState(() {
            iceCream = false;
            pizza = false;
            salad = false;
            burger = true;
          });
        }),
        categoryItem("images/pizza.png", pizza, () {
          setState(() {
            iceCream = false;
            pizza = true;
            salad = false;
            burger = false;
          });
        }),
        categoryItem("images/salad.png", salad, () {
          setState(() {
            iceCream = false;
            pizza = false;
            salad = true;
            burger = false;
          });
        }),
      ],
    );
  }

  Widget categoryItem(String imagePath, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            imagePath,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget foodCard(String imagePath, String title, String subtitle, String price) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              Text(title, style: AppWidget.semiBoldTextFieldStyle()),
              Text(subtitle, style: AppWidget.lightTextFieldStyle()),
              Text(price, style: AppWidget.semiBoldTextFieldStyle()),
            ],
          ),
        ),
      ),
    );
  }
}
