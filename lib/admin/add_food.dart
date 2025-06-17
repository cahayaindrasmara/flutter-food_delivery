import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_delivery/service/database.dart';
// import 'package:random_string/random_string.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class AddFood extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? foodData;
  final String? category;
  final String? docId; // Gunakan jika nanti perlu update dokumen

  const AddFood({
    Key? key,
    this.isEdit = false,
    this.foodData,
    this.category,
    this.docId,
  }) : super(key: key);

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> fooditems = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  TextEditingController urlController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  // Tambah ini: variabel untuk pilih mode input gambar
  bool isUploadFromGallery = true;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.foodData != null) {
      namecontroller.text = widget.foodData!['Name'];
      pricecontroller.text = widget.foodData!['Price'];
      detailcontroller.text = widget.foodData!['Detail'];
      urlController.text = widget.foodData!['Image'];
      value = widget.category ?? "";
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  // uploadItem() async {
  //   String? imageUrl;
  //   // Jika input URL gambar langsung
  //   if (urlController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.redAccent,
  //         content: Text("Please enter the image URL."),
  //       ),
  //     );
  //     return;
  //   }
  //   imageUrl = urlController.text;

  //   if (namecontroller.text == "" ||
  //       pricecontroller.text == "" ||
  //       detailcontroller.text == "" ||
  //       value == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.redAccent,
  //         content: Text("Please fill all fields."),
  //       ),
  //     );
  //     return;
  //   }

  //   Map<String, dynamic> addItem = {
  //     "Image": imageUrl,
  //     "Name": namecontroller.text,
  //     "Price": pricecontroller.text,
  //     "Detail": detailcontroller.text,
  //   };

  //   await DatabaseMethods().addFoodItem(addItem, value!).then((value) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.orangeAccent,
  //         content: Text(
  //           "Food Item has been added Successfully",
  //           style: TextStyle(fontSize: 18.0),
  //         ),
  //       ),
  //     );
  //   });
  // }

  uploadItem() async {
    String? imageUrl = urlController.text;

    if (imageUrl.isEmpty ||
        namecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty ||
        detailcontroller.text.isEmpty ||
        value == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields.")));
      return;
    }

    Map<String, dynamic> itemData = {
      "Image": imageUrl,
      "Name": namecontroller.text,
      "Price": pricecontroller.text,
      "Detail": detailcontroller.text,
    };

    if (widget.isEdit && widget.docId != null && widget.category != null) {
      await DatabaseMethods().updateFoodItem(
        itemData,
        widget.category!,
        widget.docId!,
      );
    } else {
      await DatabaseMethods().addFoodItem(itemData, value!);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF373866),
          ),
        ),
        centerTitle: true,
        title: Text("Add Item", style: AppWidget.headLineTextFieldStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Image URL", style: AppWidget.semiBoldTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Image URL",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                  ),
                ),
              ),
              // ],
              SizedBox(height: 30.0),
              Text("Item Name", style: AppWidget.semiBoldTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Name",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text("Item Price", style: AppWidget.semiBoldTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Price",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text("Item Detail", style: AppWidget.semiBoldTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Detail",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Select Category",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items:
                        fooditems
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          widget.isEdit ? "Update" : "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
