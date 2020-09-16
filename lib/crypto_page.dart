import 'dart:convert';
import 'main.dart';
import 'package:MoneyExchangeFlutter/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class cryptoMoney{
  String name;
  String value;
  String change;
  String img;
  Color color;
  cryptoMoney(this.name,this.value,this.change,this.img);
}

class crypto_page extends StatefulWidget {
  @override
  _crypto_pageState createState() => _crypto_pageState();
}

class _crypto_pageState extends State<crypto_page> {


  static List<cryptoMoney> crypto_list=new List();

  @override
  void initState() {
    crypto_list=new List();
    crypto_list.add(new cryptoMoney("Bitcoin", "...", "...", "images/crypto/btc.png"));
    crypto_list.add(new cryptoMoney("Ethereum", "...", "...", "images/crypto/etc.png"));
    crypto_list.add(new cryptoMoney("Tether", "...", "...", "images/crypto/tether.png"));
    crypto_list.add(new cryptoMoney("XRP", "...", "...", "images/crypto/xrp.png"));
    crypto_list.add(new cryptoMoney("Litecoin", "...", "...", "images/crypto/ltc.png"));
    //Rcrypto_list.add(new cryptoMoney("Bitcoin Cash", null, null, "images/crypto/btcahs.png"));

    getCryptoData();
    super.initState();
  }


  Future<void> getCryptoData() async{
    http.Response response=await http.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=c3e87ff7-d253-4e35-83b5-29aa37b01a16");
    var json_object=json.decode(response.body);
    json_object=json_object["data"];
    for (var item in json_object) {
      for (var it in crypto_list) {
        if(it.name==item["name"].toString()){
          
          
          it.value=double.parse(item["quote"]["USD"]["price"].toString()).toStringAsFixed(2);
          it.value=it.value.replaceAll(".", ",");
          
          if(double.parse(item["quote"]["USD"]["price"].toString()).toStringAsFixed(0).length>5){            
            
            it.value=it.value.toString().substring(0,3)+"."+it.value.toString().substring(3,it.value.toString().length);
          }
          else if(double.parse(item["quote"]["USD"]["price"].toString()).toStringAsFixed(0).length>4){            
           
            it.value=it.value.toString().substring(0,2)+"."+it.value.toString().substring(2,it.value.toString().length);
          }
          else if(double.parse(item["quote"]["USD"]["price"].toString()).toStringAsFixed(0).length>3){            
            
            it.value=it.value.toString().substring(0,1)+"."+it.value.toString().substring(1,it.value.toString().length);
          }
          it.change=double.parse(item["quote"]["USD"]["percent_change_24h"].toString()).toStringAsFixed(2);
          if(it.change.contains("-")){
            it.color=Colors.red[400];
          }
          else{
            it.color=Colors.green[600];
          }
        }
        
      }
      
    }
    setState(() {
      print("crpto status");
    });
    
  }

  Widget cardTile(cryptoMoney item,int index){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height/44.8)),
      color: white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical:size.height/224),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height/37.33,horizontal: size.width/24.35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width:size.width/13.8,child: Image.asset(item.img),),
            SizedBox(width:size.width/46),
            Container(child: Text(item.name,style: TextStyle(color:lightGrey,fontSize: size.height/50,fontWeight: FontWeight.w700),),width:size.width/4.6),
            SizedBox(width:size.width/20.7,),
            Container(child: Text("\$ "+item.value.toString(),style: TextStyle(color:bookBlue,fontSize: size.height/47.157,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),width:size.width/3.45),
            SizedBox(width:size.width/13.8,),
            Text("% "+item.change,style: TextStyle(color:item.color,fontSize: size.height/64,fontWeight: FontWeight.w600,),),
          ],
        ),
      ),
    );
  }


  Widget list_view(BuildContext context){
      return ListView.builder(itemCount: crypto_list.length,itemBuilder: (BuildContext c,int index){
          return cardTile(crypto_list[index],index);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width/59.14,vertical:size.height/300),
        child: list_view(context),
      ) ,
    );
  }
}