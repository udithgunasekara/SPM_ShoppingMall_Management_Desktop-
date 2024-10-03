import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
//get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

//CREATE: add a new note
  Future<void> addNotes(String note) {
    return notes.add({
      'note': note,
      'Timestamp': Timestamp.now(),
    });
  }

//READ: get a notes from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('Timestamp', descending: true).snapshots();

    return notesStream;
  }

  // Method to get the stream of notes
  // Stream<QuerySnapshot> getNotesStream() {
  //   return notes.orderBy('timestamp', descending: true).snapshots();
  // }

//get product Store details
  final CollectionReference productStore =
      FirebaseFirestore.instance.collection('Store Products');

  // Method to get the stream of productStore
  Stream<QuerySnapshot> getProductStoreStream() {
    return productStore.snapshots();
  }

//wishlist collection
  final CollectionReference wishlistCollection =
      FirebaseFirestore.instance.collection('wishlist');

  // Method to add a product ID to the wishlist
  Future<void> addToWishlist(String productId) async {
    DocumentReference wishlistDoc =
        wishlistCollection.doc('single_user_wishlist'); // Assuming single user

    DocumentSnapshot docSnapshot = await wishlistDoc.get();

    if (docSnapshot.exists) {
      List<dynamic> productIds = docSnapshot['productIds'] ?? [];
      if (!productIds.contains(productId)) {
        productIds.add(productId);
        await wishlistDoc.update({'productIds': productIds});
      }
    } else {
      await wishlistDoc.set({
        'productIds': [productId]
      });
    }
  }

// Method to fetch product IDs from the wishlist
  Future<List<String>> fetchWishlistProductIds() async {
    DocumentReference wishlistDoc =
        wishlistCollection.doc('single_user_wishlist');
    DocumentSnapshot docSnapshot = await wishlistDoc.get();

    if (docSnapshot.exists) {
      return List<String>.from(docSnapshot['productIds'] ?? []);
    }
    return [];
  }

  // Method to fetch products by their IDs
  Future<List<DocumentSnapshot>> fetchProductsByIds(
      List<String> productIds) async {
    if (productIds.isEmpty) return []; // Return empty list if no IDs provided

    QuerySnapshot productsSnapshot = await productStore
        .where(FieldPath.documentId, whereIn: productIds)
        .get();
    return productsSnapshot.docs;
  }

  //Method to detele the wishlist item
  // Method to remove a product ID from the wishlist
  Future<void> removeFromWishlist(String productId) async {
    DocumentReference wishlistDoc =
        wishlistCollection.doc('single_user_wishlist'); // Assuming single user

    DocumentSnapshot docSnapshot = await wishlistDoc.get();

    if (docSnapshot.exists) {
      List<dynamic> productIds = docSnapshot['productIds'] ?? [];
      if (productIds.contains(productId)) {
        productIds.remove(productId); // Remove the product ID from the list
        await wishlistDoc.update({'productIds': productIds});
      }
    }
  }
}
