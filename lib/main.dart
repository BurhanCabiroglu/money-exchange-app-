import 'dart:convert';
import 'package:MoneyExchangeFlutter/base.dart';
import 'package:MoneyExchangeFlutter/base_select_page.dart';
import 'package:MoneyExchangeFlutter/crypto_page.dart';
import 'package:MoneyExchangeFlutter/favorites_page.dart';
import 'package:MoneyExchangeFlutter/gold_page.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'foreign.dart';
import 'Converter_page.dart';
import 'list_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main(List<String> args) {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Home()
    );
  }
}

class public{
  static List<foreign> currencyList=new List<foreign>();
  static SharedPreferences prefs;
}



class size{
  static double width;
  static double height;
  static String code;
  static bool firstopen=true;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static int currentPage=0;
  ScaffoldState scaffoldState;




  @override
  void initState() {
    getSharedPrefs();
    public.currencyList.add(new foreign("USD", null, "images/usd.jpg", "\$", "United States Dollar", null, null));
    public.currencyList.add(new foreign("EUR", null, "images/eur.png", "\€", "European Currency", null, null));
    public.currencyList.add(new foreign("GBP", null, "images/gbp.png", "\£", "British Pound", null, null));
    public.currencyList.add(new foreign("JPY", null, "images/jpy.png", "\¥", "Japanese Yen", null, null));
    public.currencyList.add(new foreign("AUD", null, "images/aud.png", "A\$", "Australian Dollar", null, null));
    public.currencyList.add(new foreign("CAD", null, "images/cad.png", "CA\$", "Canadian Dollar", null, null));
    public.currencyList.add(new foreign("CHF", null, "images/swiss.png", "\CHF", "Swiss Franc", null, null));
    public.currencyList.add(new foreign("CNY", null, "images/china.png", "\¥", "Chinese Renminbi", null, null));
    public.currencyList.add(new foreign("TRY", null, "images/turk.png", "\₺", "Turkish Lira", null, null));
    public.currencyList.add(new foreign("HKD", null, "images/hong.png", "HK\$"," Hong Kong Dollar", null, null));
    public.currencyList.add(new foreign("NOK", null, "images/norw.png", "\kr", "Norwegian Krone", null, null));
    public.currencyList.add(new foreign("INR", null, "images/hint.png", "\₹", "Indian Rupee", null, null));
    public.currencyList.add(new foreign("RUB", null, "images/rus.png", " \₽", "Russian Ruble", null, null));
    public.currencyList.add(new foreign("DKK", null, "images/danish.png", "\kr", "Danish Krone	", null, null));
    public.currencyList.add(new foreign("KRW", null, "images/kore.png", "\₩", "South Korean Won", null, null));

     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));

    setState(() {
       base.instance=public.currencyList[8];
       
       WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(backgroundColor: Colors.blue[600],title: "Welcome!",message: "Please wait for the data to be updated",duration: Duration(seconds: 2),)..show(this.context));
       //setCountry(size.code);
       
    });

    
    getData();
 


    
    
    super.initState();
    
   
  }

  
 Future<void> getSharedPrefs() async{
        public.prefs = await SharedPreferences.getInstance();
        String comeString=public.prefs.getString("favorites")??"";
        //String basem=public.prefs.getString("base")??"USD";

        
        favorite.coding=comeString.trim().split("-").toList();
        favorite.decoder();
       // base.instance=base.decoder(basem);
        
    String deneme= await public.prefs.getString("base")??"usd";
    print("prefs datasu:"+deneme);
    base.instance=base.decoder(deneme);
    setState(() {
      print("bunu da başardık");
      
    });
      


        print("prefs verilerinin alınmış olması lazım");
  }

  void setCountry(String ccode){
    switch(ccode){
      case "US":
      base.instance=public.currencyList[0];
      break;
      case "TR":
      base.instance=public.currencyList[8];
      break;
      case "DE":
      case "BE":
      case "BG":
      case "CZ":
      case "EE":
      case "IE":
      case "EL":
      case "ES":
      case "FR":
      case "HR":
      case "IT":
      case "CY":
      case "LV":
      case "LT":
      case "LU":
      case "HU":
      case "MT":
      case "NL":
      case "AT":
      case "PL":
      case "PT":
      case "RO":
      case "SI":
      case "SK":
      case "FI":
      case "SE":
      base.instance=public.currencyList[1];
      break;
      case "UK":
      base.instance=public.currencyList[2];
      break;
      case "CA":
      base.instance=public.currencyList[5];
      break;
      case "RU":
      base.instance=public.currencyList[12];
      break;
      case "IN":
      base.instance=public.currencyList[11];
      break;
      case "AU":
      base.instance=public.currencyList[4];
      break;
      case "CH":
      base.instance=public.currencyList[6];
      break;
      case "HK":
      base.instance=public.currencyList[9];
      break;
      case "NO":
      base.instance=public.currencyList[10];
      break;
      case "DK":
      base.instance=public.currencyList[13];
      break;
    }
  }



  void stateUpdate(){
    setState(() {
      base.encoder();
      print("ayrıca base encode edildi");
      print(base.instance.desc);
      getData();
    });
  }

  dynamic pageSelector(int current){
      if(current==0){
        return favorites_page();
      }
      else if(current==1){
        return list_page();
      }
      else if(current==2){
        return gold_page();
      }
      else if(current==3){
        return crypto_page();
      }
      else if(current==4){
        return converter();
      }  
  }

   String getDateStr(DateTime dateTime){
      String strDate=dateTime.year.toString()+"-";
      if(dateTime.month.toString().length==1){
        strDate+="0";
        strDate+=dateTime.month.toString();
        strDate+="-";
      }
      else{
        strDate+=dateTime.month.toString();
        strDate+="-";
      }
      
      if(dateTime.day.toString().length==1){
        strDate+="0";
        strDate+=dateTime.day.toString();
      }
      else{
        
        strDate+=dateTime.day.toString();
      }
      
      return strDate;
  }
  
Future<void> getData() async{
    DateTime now=new DateTime.now();
    DateTime yesterday=new DateTime(now.year,now.month,now.day-1);
   // String resp_yesterday=yesterday.year.toString()+"-"+yesterday.month.toString()+"-"+yesterday.day.toString();

    http.Response exchangeResponse=await http.get("https://mexchange.azurewebsites.net/api/v1/"+base.instance.name+"/apikey=554897");
    http.Response yesterdayResponse;
    if(base.instance.name!="EUR"){
       yesterdayResponse=await http.get("https://api.exchangeratesapi.io/"+getDateStr(yesterday)+"?base="+base.instance.name);
    }
    else{
       
       yesterdayResponse=await http.get("https://api.exchangeratesapi.io/"+getDateStr(yesterday));
    }
    var exchangeJson=json.decode(exchangeResponse.body);
    exchangeJson=exchangeJson["rates"];

    
    

    for(var item in public.currencyList){
      item.value=exchangeJson[item.name];
       
    }


    var yesterdayJson=json.decode(yesterdayResponse.body);
    yesterdayJson=yesterdayJson["rates"];
    print(public.currencyList.length);
    for(var item in public.currencyList){
     
       if(item.name=="EUR"&&base.instance.name=="EUR"){
          
       }
       else{
        item.change(item.value, yesterdayJson[item.name].toString());
       }
    }
    setState(() {
      print("list page getdata");
      if(exchangeResponse.statusCode==200){
         WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(backgroundColor: Colors.blue[600],titleText: Center(child: Text("O'Right, Data is Updated :)",style: TextStyle(color:white,fontSize: 17),),),title: "",message: " ",duration: Duration(seconds: 1),)..show(this.context));
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    size.width= MediaQuery.of(context).size.width;
    size.height=MediaQuery.of(context).size.height;

    //Locale myLocale= Localizations.localeOf(context);
    /*size.code=myLocale.countryCode.toString();
    if(size.firstopen){
      setCountry(size.code);
      size.firstopen=false;
    }*/
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Money ",style: GoogleFonts.lobster(textStyle: TextStyle(color: lightGrey,fontSize: size.height / 32,fontWeight: FontWeight.w300,))),
            Text("Ex",style: GoogleFonts.lobster(textStyle: TextStyle(color: bookBlue,fontSize: size.height / 32,fontWeight: FontWeight.w300,))),
            Text("Change ",style: GoogleFonts.lobster(textStyle: TextStyle(color: lightGrey,fontSize: size.height / 32,fontWeight: FontWeight.w300,))),
            ]
            ),
      centerTitle: true,
      elevation: 0.4,
      leading:Container(padding: EdgeInsets.symmetric(vertical:size.height/148,horizontal:size.width/68),child: Image.asset("images/logo.png"),),
      actions:<Widget>[    
        FlatButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> select_base_page())).then((value) => stateUpdate());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:size.width/41.4,vertical: size.height/89.6),
              child: Text(base.instance.name,
                  style: TextStyle(color: Colors.grey[900], fontSize: size.height/59.73,fontWeight: FontWeight.w700)),
            ),
          )
        ],
      ),


     body: pageSelector(currentPage),
     bottomNavigationBar: BottomNavigationBar(
       unselectedItemColor: Color(0xff989898),
       showUnselectedLabels: true,
       currentIndex: currentPage,
       onTap: (int a){setState(() {
         currentPage=a;
       });},
       selectedItemColor: bookBlue,items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home,size: size.height/34.46,),title: Text("Favorites",)),
        BottomNavigationBarItem(icon: Icon(Icons.list,size: size.height/34.46),title: Text("Lists")),
        BottomNavigationBarItem(icon: Icon(Icons.business,size: size.height/34.46),title: Text("Gold")),
        BottomNavigationBarItem(icon: Icon(Icons.computer,size: size.height/34.46),title: Text("Crypto")),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz,size: size.height/34.46),title: Text("Converter")),
        
     ],backgroundColor: Colors.white,),
     
    );
  }
}