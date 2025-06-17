import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).update({
      "Wallet": amount,
    });
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future updateCartItem(
    String userId,
    String docId,
    int newQty,
    int newTotal,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .doc(docId)
        .update({"Quantity": newQty.toString(), "Total": newTotal.toString()});
  }

  Future deleteCartItem(String userId, String docId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .doc(docId)
        .delete();
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  // Future addFoodItem(Map<String, dynamic> foodItemMap, String category) async {
  //   return await FirebaseFirestore.instance
  //       .collection("items")
  //       .doc(category) // ⬅️ Gunakan kategori seperti "Burger"
  //       .collection("food") // ⬅️ Wajib ada
  //       .add(foodItemMap); // ⬅️ Simpan data makanan
  // }

  Future<void> updateFoodItem(
    Map<String, dynamic> item,
    String category,
    String docId,
  ) async {
    return await FirebaseFirestore.instance
        .collection(category) // karena `category` adalah nama koleksi
        .doc(docId)
        .update(item);
  }

  Future<void> deleteFoodItem(String foodId, String category) async {
    return await FirebaseFirestore.instance
        .collection("foods")
        .doc(category)
        .collection("items")
        .doc(foodId)
        .delete();
  }
}
