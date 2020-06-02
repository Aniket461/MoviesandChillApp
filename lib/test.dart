import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';



class MyTest extends StatefulWidget {
  
  @override
  _MyTestState createState() => _MyTestState();
  
}

printdata(List data){

return ListView.builder(
  itemCount: data.length,
  itemBuilder: (context,index){
    final item = data[index];

        return ListTile(
          title: item["title"],
        );    
  },
);
}

class _MyTestState extends State<MyTest> {

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getData());
  }

List all = [];
bool pressed = false;
String imgurl = '';
String search = 'harry';
TextEditingController searchcont = new TextEditingController();

Future<String> getData() async {

  http.Response response = await http.get(
    Uri.encodeFull('http://www.omdbapi.com/?apikey=22481243&s=$search'),
    headers:{
      "Accept": "application/json"
    }
    );
List data = jsonDecode(response.body)["Search"];
print("here is data $data");

setState(() {
  all = data;
});

setState(() {
  pressed = true;
});
}

@override
Widget build(BuildContext context){

return Scaffold(
  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),  
  body:Column(children: <Widget>[
  
  Container(
    height: 150.0,
    child:Expanded(
      flex: 1,
      child: Column(
      children:[



          SizedBox(height:10.0),
                      Text("Search for any Hollywood movie...",style: TextStyle(
                        color: Colors.grey, fontSize: 20.0,
                      ),),
                      
                      Row(mainAxisAlignment: MainAxisAlignment.center, 
                        children:[
                      Container(              
            width: 185.0,
            child: TextField(
              controller: searchcont,
              style: TextStyle(color: Colors.white,    fontSize:20.0,),

                decoration: new InputDecoration(
                    enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white)
                        )
                ),
              
            ),
          ),
          SizedBox(width: 10.0,),
          Padding( padding: EdgeInsets.only(top:0.0),
            child:IconButton(icon: Icon(Icons.search), color: Colors.white,padding: EdgeInsets.only(top:15.0), iconSize: 45.0, onPressed: ()=>{

          setState(()=>{
            search = searchcont.text.toString().trim(),
          }),
          getData()

          }
          )
          )
          ]
          )
                  



  ]
  )
  )),

Expanded(child: 
Container( 
  decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0) ),
      ),
  
  child:
all != null ? ListView.builder(
itemCount: all.length,
itemBuilder: (context,index){
final item = all[index];
return Padding(
  padding: EdgeInsets.all(20.0),
  child: Container( 
  width: 100.0,
  decoration: BoxDecoration(
    
    borderRadius: BorderRadius.circular(10.0),
  ),
child:
Padding( padding: EdgeInsets.only(top:0.0,left:20.0),
child:Column(
  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.center,
children:[
  SizedBox(height:10.0),
  Image.network(item["Poster"],height: 250.0,),
  SizedBox(height:10.0),
Text(item["Title"],
textAlign: TextAlign.center,
style: TextStyle(
  fontWeight:FontWeight.bold,
  fontSize: 20.0,
),),
SizedBox(height:5.0),
RaisedButton(onPressed: ()=>{
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyMovieDetail(moviename: all[index]["Title"],)),
            ),
            
            },
color: Colors.amber,
child:Text("Details", style: TextStyle(
  fontSize:15.0,
),)),
SizedBox(height:0.0),
])

)
)

);
}
)

: Container(
  width: 500.0,
  padding: EdgeInsets.only(top:100.0),
  child:Column(children:[Text("No Result Found !!", textAlign: TextAlign.center,style: TextStyle(
  fontSize:25.0, color:Colors.black,
),),
 Text("Try searching for some other movie..", textAlign: TextAlign.center,style: TextStyle(
  fontSize:18.0, color:Colors.black,
),),
  ]),
)),),



  //bottombar
  Column( 
    mainAxisAlignment: MainAxisAlignment.end,
    children:[
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: <Widget>[
    Column( children:[
  IconButton(icon: Icon(Icons.favorite),color: Colors.white,iconSize:30.0,  onPressed:()=>{

Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyLiked()),
            ),
  },
  ),
  Text("Your Favourites", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.person),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccount()),
            ),
  },
  ),
  Text("Your Account", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.apps),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAbout()),
            ),
  },
  ),
  Text("About Us", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))
  
  ]
    ),

],
),
SizedBox(height:5.0),
])
    ]));
}
}




class MyMovieDetail extends StatefulWidget{

  final String moviename;
  // receive data from the FirstScreen as a parameter
  MyMovieDetail({Key key, @required this.moviename}) : super(key: key);

 @override
  _MyMovieDetailState createState() => new _MyMovieDetailState(moviename);
}

class _MyMovieDetailState extends State<MyMovieDetail>{


   String moviename;
   Map<String,dynamic> all = {};
  // receive data from the FirstScreen as a parameter
  _MyMovieDetailState(String name){
    this.moviename = name;
  }
final String newname ="";

  @override
  void initState() {
    super.initState();
    getData();

  }


Future<String> getData() async {

  http.Response response = await http.get(
    Uri.encodeFull('http://www.omdbapi.com/?apikey=22481243&t=$moviename'),
    headers:{
      "Accept": "application/json"
    }
    );

    print(jsonDecode(response.body));
setState(() {
all = jsonDecode(response.body);  
});

print("$all from allll");
}

_launchURL(String url,String year) async {
  
  String ur = url.toLowerCase().replaceAll(RegExp("[^a-zA-Z0-9 ]"),"").replaceAll(" ", "-");
  String newUrl = "https://yts.mx/movies/$ur-$year";
  print(newUrl);
  if (await canLaunch(newUrl)) {
    await launch(newUrl);
  } else {
    throw 'Could not launch $url';
  }
}

storeDb(String name,String url,String year){
if(globals.userEmail == ''){print("no user created");
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Not logged in"),
 content: Text("Please login to access Favourites feature"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     Navigator.of(context).pop(),
   } ,child:Text("close"))
 ],
);
});}
else{  
DocumentReference documentReference = Firestore.instance.collection(globals.userEmail).document(name);
Map<String,String> todos = {
  "name": name,
  "url": url,
  "year":year
};
documentReference.setData(todos).whenComplete(() =>print("$name created"));
showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Successful",style: TextStyle(color:Colors.green),),
 content: Text("$name !! sucessfully added to your favourites list"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     Navigator.of(context).pop(),
   } ,child:Text("close"))
 ],
);
});
}
}

@override
Widget build(BuildContext context){

print("$all from the all call");
  if(all == []){
  return Scaffold(
  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

  body: Text("Data is loading", style: TextStyle(
    fontSize: 24.0
  ),),

  );


  }

else{
print("$moviename is this");
return Scaffold(

  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

body: Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children:[Padding(padding: EdgeInsets.only(left:100.0, top: 20.0,bottom:20.0, right:100.0),
 child: Image.network(all['Poster'], height:250.0),
 ),

Expanded(child: Container(
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.only(topLeft:Radius.circular(55.0)),
        ),
        child:ListView(
          children: <Widget>[
            Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            SizedBox(height:40.0),
            Padding(padding: EdgeInsets.only(left:30.0,right:30.0),
      child:Text(all["Title"], style: TextStyle(color:Colors.black, fontFamily: "Montserrat", fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
      SizedBox(height:30.0),
      Row(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
           SizedBox(width:30.0),
        Text("Released:", style: TextStyle(color:Colors.black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold)),
        SizedBox(width:5.0),
        Text(all["Released"], style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:50.0),
        Text("Rated:", style: TextStyle(color:Colors.
        black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:5.0),
        Text(all["Rated"], style: TextStyle(color:Colors.
        grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
      ],),

SizedBox(height:15.0),


Row(mainAxisAlignment: MainAxisAlignment.start, 
          children:[
             SizedBox(width:30.0),
        Text("Genre:", style: TextStyle(color:Colors.black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:10.0),
        Container(width:250.0,
        child:Text(all["Genre"], style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
        )
        ]),

SizedBox(height:15.0),

        Row(mainAxisAlignment: MainAxisAlignment.start, 
          children:[
             SizedBox(width:30.0),
        Text("Actors:", style: TextStyle(color:Colors.black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:10.0),
        Container( width: 250.0,
        child:Text(all["Actors"], style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),),
        
        ]),

SizedBox(height:15.0),
        Row(mainAxisAlignment: MainAxisAlignment.start, 
          children:[
            SizedBox(width:30.0),
        Text("IMDB Rating:", style: TextStyle(color:Colors.black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:10.0),
        Text(all["imdbRating"], style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        ]),

        SizedBox(height:20.0),
        Row(mainAxisAlignment: MainAxisAlignment.start, 
          children:[
             SizedBox(width:30.0),
        Text("Plot:", style: TextStyle(color:Colors.black,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),),
        SizedBox(width:10.0),
        Container( width: 270.0,
        child:Text(all["Plot"], style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),),
        
        ]),

        SizedBox(height: 20.0,),
Row( children:[ 
  Padding( padding: EdgeInsets.only(left: 85.0,right:15.0),
child:RaisedButton(onPressed: ()=>{
  _launchURL(all["Title"], all["Year"]),
},
child:Text("Get Download Link"),color: Colors.amber,),
),
SizedBox(height:10.0),
IconButton(icon: Icon(Icons.favorite_border), onPressed:()=>{

storeDb(all["Title"],all["Poster"],all["Year"]),

},iconSize: 35.0,color: Colors.red),
]),
SizedBox(height:50.0),   ]
      ))
          ]
          ),
      )
      )
  ])
);


}
}
}





class MyLiked extends StatefulWidget {
  
  @override
  _MyLikedState createState() => _MyLikedState();
}

class _MyLikedState extends State<MyLiked>{



deleteMovie(String name){
  DocumentReference documentReference = Firestore.instance.collection(globals.userEmail).document(name);
documentReference.delete().whenComplete(() =>print("deleted"));

showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
 title: Text("Deleted!!",style: TextStyle(color:Colors.red),),
 content: Text("$name !! sucessfully deleted!!"),
 actions: <Widget>[
   FlatButton(onPressed: ()=>{
     Navigator.of(context).pop(),
   } ,child:Text("close"))
 ],
);
});

}

  
@override
Widget build(BuildContext context){

return Scaffold(

  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

body: (globals.userEmail != '')?

StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(globals.userEmail).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
                if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Container(
                 child: Padding(padding: EdgeInsets.all(20.0), child:Column(children:[
                   Image.network(document['url'], height: 200.0,),
                    SizedBox(height:5.0),
                  Text(document['name'],style: TextStyle(color:Colors.white, fontFamily: 'Montserrat', fontSize: 22.0),textAlign: TextAlign.center,),
                  SizedBox(height:5.0),
                  Row( mainAxisAlignment: MainAxisAlignment.center, children:[
          RaisedButton(onPressed: ()=>{
            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyMovieDetail(moviename: document['name'],)),
                        ),
                        
                        },
            color: Colors.amber,
            child:Text("Details", style: TextStyle(
  fontSize:15.0,
),)),
SizedBox(width:10.0),
RaisedButton(onPressed: ()=>{
            
            deleteMovie(document['name']),
            
                        },
            color: Colors.red,
            child:Text("Remove", style: TextStyle(
  fontSize:15.0,
),)),



]),
                 ])) 
                );              }).toList(),
            );
        }
      },
    )
: Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children:[Padding( padding: EdgeInsets.only(top:100.0,left:50.0,right:50.0), child:Text("Please Login to retrieve your Favourite movies", style: TextStyle(color:Colors.white, fontSize: 30.0),textAlign: TextAlign.center,),
),

SizedBox(height:200.0),
  //bottombar
  Column( 
    mainAxisAlignment: MainAxisAlignment.end,
    children:[
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: <Widget>[
    Column( children:[
  IconButton(icon: Icon(Icons.home),color: Colors.white,iconSize:30.0,  onPressed:()=>{

Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTest()),
            ),
  },
  ),
  Text("Home", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.person),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccount()),
            ),
  },
  ),
  Text("Your Account", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.apps),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAbout()),
            ),
  },
  ),
  Text("About Us", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))
  
  ]
    ),

],
),
SizedBox(height:5.0),
])
])

);


}
}


class MyAccount extends StatefulWidget {
  
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount>{

  bool isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();


  
@override
Widget build(BuildContext context){




return Scaffold(

  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

body: (globals.userEmail != "") 
        ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("Welcome to Movies and Chill,", style: TextStyle(color: Colors.white, fontSize:20.0), textAlign: TextAlign.center,),
              Text(globals.userEmail, style:TextStyle(color: Colors.white, fontSize:20.0), textAlign: TextAlign.center,),
              SizedBox(height: 50),
              _signOutButton(),
              SizedBox(height: 200.0,),
               Container(
                 alignment: Alignment.bottomCenter,
                 decoration: BoxDecoration(
                   
                 ),
              child:
               Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
    Column( children:[
  IconButton(icon: Icon(Icons.home),color: Colors.white,iconSize:30.0,  onPressed:()=>{

Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTest()),
            ),
  },
  ),
  Text("Home", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.person),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccount()),
            ),
  },
  ),
  Text("Your Account", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.apps),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAbout()),
            ),
  },
  ),
  Text("About Us", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),

],)
            )
           

            ],
          ),
        )
        : Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _signInButton(),
                       ],
          ),
        ),

);
}



//Functions

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return 'signInWithGoogle succeeded: $user';
}
void signOutGoogle() async{
  await googleSignIn.signOut();
  globals.userEmail = "";
  print("User Sign Out");
 
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTest()),
            );
}

Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() => {
            globals.userEmail = googleSignIn.currentUser.email,
            setState(()=>{
                isLoggedIn = true,
            }),

        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


Widget _signOutButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signOutGoogle();
        setState(() {
          isLoggedIn = false;
        });

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }





}


class MyAbout extends StatefulWidget {
  
  @override
  _MyAboutState createState() => _MyAboutState();
}

class _MyAboutState extends State<MyAbout>{
  

launchURL() async {
  
  if (await canLaunch("https://aniwebsite.netlify.com")) {
    await launch('https://aniwebsite.netlify.com');
  } else {
    throw 'Could not launch https://aniwebsite.netlify.com';
  }
}


@override
Widget build(BuildContext context){

return Scaffold(

  backgroundColor: Colors.black,
  appBar: AppBar(
   title: Text('Movies & Chill'),
   backgroundColor: Colors.amber,
  ),

body: Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [Padding(
padding: EdgeInsets.all(20.0),
child: Container(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:[
      Text("Movies & Chill is a movie search app,", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 15.0),textAlign: TextAlign.justify,),
      Text("Where you can search for any Hollywood movie and get Details and Download link for the same.", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 15.0),textAlign: TextAlign.justify,),
      SizedBox(height:10.0),
      Text("The app uses open source OMDB api to get all the movie details. You can find the api at omdbapi.com.", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 15.0),textAlign: TextAlign.justify,),
      SizedBox(height:10.0),
      Text("Movies & Chill is developed by Aniket Surve, A Tech enthusiast and an IT Engineer by profession.", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 15.0),textAlign: TextAlign.justify,),
      SizedBox(height:5.0),
      Text("You can reach out to me at my website!!", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 15.0),textAlign: TextAlign.justify,),
      Row( mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        OutlineButton(onPressed:()=>{
          launchURL(),
        }, child:Text("Visit My Website",style: TextStyle(color:Colors.amber, fontFamily: "Montserrat",fontSize: 22.0,),))
      ],),
      SizedBox(height: 100.0),
    ],
  )
)
  ),
  
  Container(
                 alignment: Alignment.bottomCenter,
                 decoration: BoxDecoration(
                   
                 ),
              child:
               Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
    Column( children:[
  IconButton(icon: Icon(Icons.home),color: Colors.white,iconSize:30.0,  onPressed:()=>{

Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTest()),
            ),
  },
  ),
  Text("Home", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.person),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccount()),
            ),
  },
  ),
  Text("Your Account", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),



  Column( children:[
  IconButton(icon: Icon(Icons.favorite),color: Colors.white,iconSize:30.0,  onPressed:()=>{
    
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyLiked()),
            ),
  },
  ),
  Text("My Favourites", style:TextStyle(
    fontSize:12.0, color:Colors.white,
  ))]
    ),

],)
            )
           

  
  ])
);


}
}


