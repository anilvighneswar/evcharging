import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Booking',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            handle(uid!);
          },
          child: Text('Press'),
        ),
      ),
    );
  }
  void handle(String uid){
    getBookingsByUid(uid);

  }
  Future<List<DocumentSnapshot>> getBookingsByUid(String uid) async {
    List<DocumentSnapshot> bookings = [];
    List<List> eachb = [];

    try {
      QuerySnapshot chargersSnapshot = await FirebaseFirestore.instance
          .collectionGroup('bookings')
          .where('uid', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot bookingDoc in chargersSnapshot.docs) {
        DocumentSnapshot chargerSnapshot =
        await bookingDoc.reference.parent!.parent!.get();
        bookings.add(chargerSnapshot);
        String cname = bookingDoc.get('cname');
        String addr = bookingDoc.get('address');
        String slot = bookingDoc.get('slot');
        String date = bookingDoc.get('date');
        String vtype = bookingDoc.get('vtype');
        String status = bookingDoc.get('status');
        List<String> document = [cname, addr, slot, date, vtype, status];
        eachb.add(document);
      }
    } on Exception catch (e) {
      print(e);
    }

    print(bookings);
    print(eachb);
    return bookings;
  }




}
