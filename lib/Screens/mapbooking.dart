import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging/Screens/bookings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class MapBooking extends StatefulWidget {
  String name, address;
  MapBooking({super.key, required this.name, required this.address});

  @override
  State<MapBooking> createState() => _MapBookingState();
}

class _MapBookingState extends State<MapBooking> {
  String? selectedOption;
  String userName = '';
  String uid = '';
  String mail = '';

  double amount=0.0;

  @override
  void initState() {
    super.initState();
    loadUserName();
    _name.text = widget.name;
    _address.text = widget.address;
  }

  Future<void> loadUserName() async {
    try {
      // Check if the user is authenticated
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data.containsKey('name') &&
            data.containsKey('email')) {
          setState(() {
            userName = data['name'];
            mail = data['email'];
          });
        }
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: mail)
            .where('name', isEqualTo: userName)
            .limit(1)
            .get();
        uid = querySnapshot.docs[0].id;
        print(uid);
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  final format = DateFormat("dd-MM-yyyy");
  String? _selectedHourSlot;
  List<String> _hourSlots = [
    '1-2 AM',
    '2-3 AM',
    '3-4 AM',
    '4-5 AM',
    '5-6 AM',
    '6-7 AM',
    '7-8 AM',
    '8-9 AM',
    '9-10 AM',
    '10-11 AM',
    '11-12 AM',
    '12-1 PM',
    '1-2 PM',
    '2-3 PM',
    '3-4 PM',
    '4-5 PM',
    '5-6 PM',
    '6-7 PM',
    '7-8 PM',
    '8-9 PM',
    '9-10 PM',
    '10-11 PM',
    '11-12 PM',
    '12-1 AM',
  ];


  // Variable to store the selected option
  List<String> dropdownOptions = [
    'two wheeler',
    'three wheeler',
    'four wheeler',
  ]; // List of options for the dropdown
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _date = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                children: [
                  SizedBox(width: 8,),
                  IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  },
                      icon: Icon(Icons.arrow_back_ios_new_outlined)),
                  Text('Book Slot', style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Hello!', style: TextStyle(color: HexColor('#18731B'),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Charging Station:', style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Container(
                  width: 380,
                  height: 40,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#18731B')),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: _name,
                    readOnly: true,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Address:', style: TextStyle(color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Container(
                  width: 380,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#18731B')),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: _address,
                    readOnly: true,
                  ),
                ),
              ),


              SizedBox(height: 8,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Please fill the details to book your slot',
                      style: TextStyle(color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: GoogleFonts
                              .inter()
                              .fontFamily)),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Enter your vehicle type:', style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 380,
                  height: 50,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#18731B')),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOption,
                    hint: Text('Select your vehicle type', style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.normal,
                        fontFamily: GoogleFonts
                            .inter()
                            .fontFamily)),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    items: dropdownOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option, style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: GoogleFonts
                                .inter()
                                .fontFamily)),
                      );
                    }).toList(),
                    // Customize dropdown button style
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: SizedBox(),
                    // Remove default underline
                    isExpanded: true, // Make the dropdown button take full width
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('DATE:', style: TextStyle(color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts
                          .inter()
                          .fontFamily)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  width: 380,
                  height: 50,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#18731B')),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '',
                      hintText: 'Select a date',
                      prefixIcon: Icon(
                        Icons.calendar_today, color: HexColor('#18731B'),),
                    ),
                    controller: _date,
                    keyboardType: TextInputType.datetime,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          final formattedDate = format.format(selectedDate);
                          setState(() {
                            _date.text = formattedDate;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Select a time Slot:',
                      style: TextStyle(color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts
                              .inter()
                              .fontFamily)),
                ],
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Container(
                    width: 380,
                    height: 60,
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor('#18731B')),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedHourSlot,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedHourSlot = newValue;
                        });
                      },
                      items: _hourSlots.map((hourSlot) {
                        return DropdownMenuItem<String>(
                          value: hourSlot,
                          child: Text(hourSlot),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Hour Slot',
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
              SizedBox(height: 40,),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(onPressed: () async {
                  String addr = _address.text;
                  String cname = _name.text;
                  String date = _date.text;
                  String? vtype = selectedOption.toString();
                  String hour=_selectedHourSlot.toString();
                  // print(vtype);
                  // print(hour);

                  try {
                    if(await isSlotAvailable(addr, date, hour, cname)==false) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red[700],
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(20),
                          content: Text("Selected time slot is not available."),
                        ),
                      );
                    }
                    else {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child:Container(
                              height: 320,
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, icon: Icon(Icons.close_rounded))

                                    ],
                                  ),
                                  Text(
                                    'Total Amount: \$${amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Card Number',
                                      labelStyle: TextStyle(color: HexColor('#18731B'),), // Change hint text color
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:HexColor('#18731B'),), // Change underline color
                                      ),),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Expiration Date',
                                            labelStyle: TextStyle(color: HexColor('#18731B'),), // Change hint text color
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color:HexColor('#18731B'),), // Change underline color
                                            ),),
                                        ),),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'CVV',
                                            hoverColor: HexColor('#18731B'),
                                            labelStyle: TextStyle(color: HexColor('#18731B'),), // Change hint text color
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color:HexColor('#18731B'),), // Change underline color
                                            ),),),),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(HexColor('#18731B').value))),
                                    onPressed: () {
                                      addBooking(
                                          addr, cname, vtype, date, _selectedHourSlot!, uid);
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green[700],
                                          duration: Duration(seconds: 3),
                                          margin: EdgeInsets.all(20),
                                          content: Text('Booking Added'),
                                        ),);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => BookingScreen()),
                                      ).then((Navigator.of(context).pop));
                                    },
                                    child: Text('Pay Now'),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      );
                    }
                  } catch (e) {
                    if (e.toString() ==
                        'Null check operator used on a null value') {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red[700],
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(20),
                          content: Text("Please fill all the details."),
                        ),
                      );
                    } else {
                      print(e);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red[700],
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(20),
                          content: Text(
                              "Could'nt book a slot at the moment.Please try again later."),
                        ),
                      );
                    }
                  }
                }
                    ,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(HexColor('#18731B').value)),
                      fixedSize: MaterialStateProperty.all<Size>(Size(280, 45)),
                    ),
                    child: Text('Book Slot', style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts
                            .inter()
                            .fontFamily))),
              ),


            ]


        ),
      ),
    );
  }

  void addBooking(String chargerAddress, String chargerName,
      String vehicleType, String date, String hourSlot, String uid) async {
    // Check if a charger with the given address exists
    try {
      QuerySnapshot chargersSnapshot = await FirebaseFirestore.instance
          .collection('chargers')
          .where('address', isEqualTo: chargerAddress)
          .get();

      if (chargersSnapshot.size > 0) {
        // Charger already exists
        String chargerId = chargersSnapshot.docs[0].id;
        // Create the sub-collection "bookings" within the charger document
        CollectionReference bookingsCollection = FirebaseFirestore.instance
            .collection('chargers')
            .doc(chargerId)
            .collection('bookings');
        // Add a new booking document to the "bookings" sub-collection
        bookingsCollection.add({
          'vtype': vehicleType,
          'date': date,
          'slot': hourSlot,
          'status': 'pending',
          'uid': uid,
          'cname': chargerName,
          'address': chargerAddress,
        });
      } else {
        // Charger does not exist, create a new charger document
        DocumentReference chargerDocument = await FirebaseFirestore.instance
            .collection('chargers')
            .add({
          'cname': chargerName,
          'address': chargerAddress,
        });

        // Create the sub-collection "bookings" within the new charger document
        CollectionReference bookingsCollection = chargerDocument.collection(
            'bookings');

        // Add a new booking document to the "bookings" sub-collection
        bookingsCollection.add({
          'vtype': vehicleType,
          'date': date,
          'slot': hourSlot,
          'status': 'pending',
          'uid': uid,
          'cname': chargerName,
          'address': chargerAddress,
        });
      }
    }
    catch (e) {
      print(e);
      //ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(20),
          content: Text("Database error"),
        ),
      );
    }
  }

  Future<bool> isSlotAvailable(String chargerAddress, String date,
      String hourSlot, String name) async {
    QuerySnapshot chargersSnapshot = await FirebaseFirestore.instance
        .collection('chargers')
        .where('address', isEqualTo: chargerAddress)
        .get();
    if (chargersSnapshot.docs.isNotEmpty) {
      String chargerId = chargersSnapshot.docs[0].id;
      CollectionReference chargerRef = FirebaseFirestore.instance.collection('chargers');
      QuerySnapshot snapshot = await chargerRef.doc(chargerId)
          .collection('bookings')
          .where('date', isEqualTo: date)
          .where('slot', isEqualTo: hourSlot)
          .get();

      // print('Query snapshot: ${snapshot.docs}');
      // print('Is slot available: ${snapshot.docs.isEmpty}');
      return snapshot.docs.isEmpty;
    } else {
      return true;
    }
  }
}






