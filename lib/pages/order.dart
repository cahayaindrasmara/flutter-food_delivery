import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/service/database.dart';
import 'package:food_delivery/service/shared_pref.dart';
import 'package:food_delivery/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  String getDirectImageUrl(String url) {
    if (url.contains("drive.google.com/file/d/")) {
      final id = url.split('/d/')[1].split('/')[0];
      return "https://drive.google.com/uc?export=view&id=$id";
    }
    return url;
  }

  void showEditDialog(String docId, String currentQty, String currentTotal) {
    TextEditingController qtyController = TextEditingController(
      text: currentQty,
    );

    int pricePerItem = int.parse(currentTotal) ~/ int.parse(currentQty);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit Quantity"),
            content: TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter new quantity"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  int newQty = int.parse(qtyController.text);
                  int newTotal = newQty * pricePerItem;

                  await DatabaseMethods().updateCartItem(
                    id!,
                    docId,
                    newQty,
                    newTotal,
                  );

                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text("Update"),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // RESET total setiap kali rebuild
        total = 0;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            total += int.parse(ds["Total"]);

            return Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      SizedBox(width: 20.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          getDirectImageUrl(ds["Image"]),
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["Name"],
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                            Text(
                              "\$" + ds["Total"],
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showEditDialog(
                                      ds.id,
                                      ds["Quantity"],
                                      ds["Total"],
                                    );
                                  },
                                  child: Icon(Icons.edit, size: 20),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods().deleteCartItem(
                                      id!,
                                      ds.id,
                                    );
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidget.headLineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            Expanded(
              // height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            // Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFieldStyle()),
                  Text(
                    "\$" + total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                if (wallet == null) return;

                int walletAmount = int.parse(wallet!);

                if (walletAmount <= 0 || walletAmount < total) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Saldo tidak mencukupi untuk checkout!"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return; // hentikan proses
                }

                // Jika cukup, lanjut checkout
                int newAmount = walletAmount - total;
                await DatabaseMethods().UpdateUserwallet(
                  id!,
                  newAmount.toString(),
                );
                await SharedPreferenceHelper().saveUserWallet(
                  newAmount.toString(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Checkout berhasil!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
