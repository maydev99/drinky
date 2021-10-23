import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:layout/models/drink.dart';
import 'package:logger/logger.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppTitle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var logger = Logger();
  String name = '';
  String imageUrl = '';
  String instructions = '';

  @override
  void initState() {
    makeNetworkCall();
    super.initState();
  }

   

  void makeNetworkCall() async {
    var response = await Dio().get('https://www.thecocktaildb.com/api/json/v1/1/random.php');
    setState(() {
      try {
        var rawData = Drink.fromJson(response.data);
        name = rawData.strDrink;
        imageUrl = rawData.strDrinkThumb.toString();
        instructions = rawData.strInstructions;
        logger.i(imageUrl);

      } catch(e) {
        logger.e(e);
      }

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinky'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          //Image View
          Image.network(imageUrl,
          width: 400,
          height: 400,
          fit: BoxFit.cover,),
          //Drink Name Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,),
          ),
          //Instructions Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(instructions,
            style: const TextStyle(
              fontSize: 20,
            ),),
          ),

          Padding(
            padding: const EdgeInsets.all(32.0),
            child: MaterialButton(
              child: const Text('Get a Drink'),
                onPressed: () {
                  makeNetworkCall();
                },
            color: Colors.red,
            textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)
              ),
              elevation: 10,
            ),
          )
        ],
      ),
    );
  }
}