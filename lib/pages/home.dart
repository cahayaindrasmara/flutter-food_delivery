import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/service/database.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/widget/widget_support.dart';
import 'package:food_delivery/pages/details.dart';
// import 'package:food_delivery/pages/order.dart' as myorder;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;

  String? name;

  Stream? foodItemStream;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();

    setState(() {});
  }

  ontheload() async {
    foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
    getthesharedpref();
    // setState(() {});
  }

  String getDirectImageUrl(String url) {
    if (url.contains("drive.google.com/file/d/")) {
      final id = url.split('/d/')[1].split('/')[0];
      return "https://drive.google.com/uc?export=view&id=$id";
    }
    return url;
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  // Widget allItems() {
  //   return StreamBuilder(
  //     stream: foodItemStream,
  //     builder: (context, AsyncSnapshot snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //             padding: EdgeInsets.zero,
  //             itemCount: snapshot.data.docs.length,
  //             shrinkWrap: true,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               DocumentSnapshot ds = snapshot.data.docs[index];
  //               return GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder:
  //                           (context) => Details(
  //                             detail: ds["Detail"],
  //                             name: ds["Name"],
  //                             price: ds["Price"],
  //                             image: getDirectImageUrl(ds["Image"]),
  //                           ),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.all(4),
  //                   child: Material(
  //                     elevation: 5.0,
  //                     borderRadius: BorderRadius.circular(20),
  //                     child: Container(
  //                       padding: EdgeInsets.all(14),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           ClipRRect(
  //                             borderRadius: BorderRadius.circular(20),
  //                             child: Image.network(
  //                               getDirectImageUrl(ds["Image"]),
  //                               height: 150,
  //                               width: 150,
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                           Text(
  //                             ds["Name"],
  //                             style: AppWidget.semiBoldTextFieldStyle(),
  //                           ),
  //                           SizedBox(height: 5.0),
  //                           Text(
  //                             ds["Detail"],
  //                             style: AppWidget.lightTextFieldStyle(),
  //                           ),
  //                           SizedBox(height: 5.0),
  //                           Text(
  //                             "\$" + ds["Price"],
  //                             style: AppWidget.semiBoldTextFieldStyle(),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           )
  //           : CircularProgressIndicator();
  //     },
  //   );
  // }

  Widget allItems() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height:
              270, // pastikan tinggi dibatasi agar scroll horizontal bekerja
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Details(
                            detail: ds["Detail"],
                            name: ds["Name"],
                            price: ds["Price"],
                            image: getDirectImageUrl(ds["Image"]),
                          ),
                    ),
                  );
                },
                child: Container(
                  width:
                      180, // batasi lebar setiap item agar tidak terlalu besar
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              getDirectImageUrl(ds["Image"]),
                              height:
                                  100, // sebelumnya 120 atau 150, dikurangi agar tidak overflow
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            // Gunakan Expanded untuk teks panjang agar fleksibel
                            child: Text(
                              ds["Detail"],
                              style: AppWidget.lightTextFieldStyle(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$" + ds["Price"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Details(
                              detail: ds["Detail"],
                              name: ds["Name"],
                              price: ds["Price"],
                              image: getDirectImageUrl(ds["Image"]),
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                getDirectImageUrl(ds["Image"]),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    ds["Name"],
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    ds["Detail"],
                                    style: AppWidget.lightTextFieldStyle(),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "\$" + ds["Price"],
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
            : CircularProgressIndicator();
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello ${name ?? 'User'},",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  // GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => myorder.Order(),
                  //     ),
                  //   );
                  // },
                  // child: Container(
                  //   margin: EdgeInsets.only(right: 20.0),
                  //   padding: EdgeInsets.all(3),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Icon(
                  //     Icons.shopping_cart_outlined,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // ),
                ],
              ),
              SizedBox(height: 20.0),
              Text("Delicious Food", style: AppWidget.headLineTextFieldStyle()),
              Text(
                "Discover and Get Great Food",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: showItem(),
              ),
              SizedBox(height: 30.0),
              Container(height: 270, child: allItems()),
              SizedBox(height: 30.0),
              // allItemsVertically(),
              SizedBox(
                height: 600, // Atur tinggi sesuai kebutuhan
                child: allItemsVertically(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Ice-cream");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: icecream ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Pizza");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: pizza ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
            foodItemStream = await DatabaseMethods().getFoodItem("Salad");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: salad ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
            foodItemStream = await DatabaseMethods().getFoodItem("Burger");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: burger ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
