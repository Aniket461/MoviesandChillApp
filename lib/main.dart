import 'package:flutter/material.dart';
import './test.dart';
void main() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
      
  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

body: Padding(
  padding:EdgeInsets.only(top:100.0, left: 50.0,right: 50.0),
  child:Text("Loading Movie Details.....", textAlign: TextAlign.center, style: TextStyle(
  color: Colors.white, fontFamily: "Montserrat", fontSize: 25.0,
),),));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
 @override
 Widget build(BuildContext context){
   return MaterialApp(
     home: MyTest(),
     debugShowCheckedModeBanner: false,
   );
 }

}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

@override
Widget build(BuildContext context){
  return Scaffold(

    backgroundColor: Color(0xFF21BFBD),
    body: ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:15.0,left:10.0),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>{},color: Colors.white,),
          Container(
            width:120.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              IconButton(icon: Icon(Icons.filter_list),
              color: Colors.white,
              onPressed: () => {},),
              IconButton(icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () => {},)
            ],
            )
          )
        ],)
        ),
        SizedBox(height:25.0),
        Padding(padding: EdgeInsets.only(left:40.0),
        child: Row(children: <Widget>[
          Text('Healthy',
          style:TextStyle(
            fontFamily:'Montserrat',
            color: Colors.white,
            fontSize: 25.0
          )),
          SizedBox(width:10.0),
          Text('Food',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize:25.0
          ),)

        ],)
        ),
        SizedBox(height:40.0),
        Container(
          height: MediaQuery.of(context).size.height - 180.0,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.only(topLeft:Radius.circular(75.0)),
          ),
          child: ListView(
            primary:false,
            padding:EdgeInsets.only(left:25.0,right:20.0),
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top:45.0),
              child:Container(
                height: MediaQuery.of(context).size.height - 300.0,
                child: ListView(
                  children:[

                    buildFoodItem('assets/plate1.png', 'Salmon bowl', '\$24'),
                    buildFoodItem('assets/plate2.png', 'Spring bowl', '\$22'),
                    buildFoodItem('assets/plate6.png', 'Avocado bowl', '\$26'),
                    buildFoodItem('assets/plate5.png', 'Berry bowl', '\$24'),
                    buildFoodItem('assets/plate1.png', 'Salmon bowl', '\$24'),
                    buildFoodItem('assets/plate2.png', 'Spring bowl', '\$22'),
                    buildFoodItem('assets/plate6.png', 'Avocado bowl', '\$26'),
                    buildFoodItem('assets/plate5.png', 'Berry bowl', '\$24'),

                  ],
                ),
              ),
              ),

              SizedBox(height:12.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Container(
                    height:50.0,
                    width:50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(child:Icon(Icons.search, color:Colors.black),),
                  ),

                  
                  Container(
                    height:50.0,
                    width:50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(child:Icon(Icons.calendar_today, color:Colors.black),),
                  ),
                  
                  Container(
                    height:50.0,
                    width:120.0,
        
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text('CheckOut',
                      style: 
                      TextStyle(fontFamily:'Montserrat',
                      fontSize:15.0, fontWeight:FontWeight.bold, color: Colors.white),
                    ),
                      )
                    ,
                  )





              ],),
              
            ],
                      ),
          

        ),

      ],
    ),

  );
}

Widget buildFoodItem(String imgPath,String foodName, String price){
  return Padding(padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0),
 child: InkWell(
   onTap:(){
   },
   child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: <Widget>[
       Container(
         child: Row(
           children:[
             Hero(
               tag:imgPath,
               child: Image(image: AssetImage(imgPath),
               fit: BoxFit.cover,
               height: 75.0,
               width: 75.0,)
             ),
             SizedBox(width:10.0),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(foodName,
                 style:TextStyle(
                   fontFamily: 'Montserrat',
                   fontSize: 17.0,
                   fontWeight: FontWeight.bold
                 )
                 ),
                 Text(price,
                 style:TextStyle(
                   fontFamily: 'Montserrat',
                   fontSize: 15.0,
                   color: Colors.grey
                 )
                 ),
               ],
             )
           ],
         ),
       ),
       IconButton(icon: Icon(Icons.add), onPressed:()=>{},
       color: Colors.black,),
     ],
   ),
 ), );
}

 }
