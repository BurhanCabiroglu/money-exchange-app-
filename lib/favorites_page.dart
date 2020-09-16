import 'dart:convert';
import 'selected_page.dart';
import 'list_page.dart';
import 'package:MoneyExchangeFlutter/base.dart';
import 'package:MoneyExchangeFlutter/foreign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';







class favorites_page extends StatefulWidget {
  @override
  _favorites_pageState createState() => _favorites_pageState();
}

class favorite{
  static List<foreign> list=new List();
  static List<String> coding=new List();

static decoder() async{
    for(String item in favorite.coding){
      switch(item){
        case "usd":
        favorite.list.add(public.currencyList[0]);
        break;
        case "eur":
        favorite.list.add(public.currencyList[1]);
        break;
        case "gbp":
        favorite.list.add(public.currencyList[2]);
        break;
        case "jpy":
        favorite.list.add(public.currencyList[3]);
        break;
        case "aud":
        favorite.list.add(public.currencyList[4]);
        break;
        case "cad":
        favorite.list.add(public.currencyList[5]);
        break;
        case "chf":
        favorite.list.add(public.currencyList[6]);
        break;
        case "cny":
        favorite.list.add(public.currencyList[7]);
        break;
         case "cny":
        favorite.list.add(public.currencyList[8]);
        break;
        case "hkd":
        favorite.list.add(public.currencyList[9]);
        break;
        case "inr":
        favorite.list.add(public.currencyList[10]);
        break;
        case "rub":
        favorite.list.add(public.currencyList[11]);
        break;
        case "dkk":
        favorite.list.add(public.currencyList[12]);
        break;
        case "krw":
        favorite.list.add(public.currencyList[13]);
        break;
      }
    }
  }

  static encoder() async{
    coding=new List();
    for(foreign item in favorite.list){
      switch(item.name.toLowerCase()){
        case "usd":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "eur":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "gbp":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "jpy":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "aud":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "cad":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "chf":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "cny":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
         case "cny":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "hkd":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "inr":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "rub":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "dkk":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break;
        case "krw":
        favorite.coding.add(item.name.toLowerCase()+"-");
        break; 
      }
      

    }
    String datas="";
    for(String i in favorite.coding){
      datas+=i;
    }
    await public.prefs.setString("favorites", datas);
    
  }
}

class _favorites_pageState extends State<favorites_page> {

  @override
  void initState(){
    updateState();
    super.initState();
  }

  void updateState(){
    setState(() {
      print("list page updated");
    });
  }
 
  void dispose(){
    super.dispose();
  }

  void stateUpdate(){
    setState(() {
      print("state update");
    });
  }

  Widget cardTile(foreign item,int index){

    if(base.instance.name!=item.name){
      return Material(
        color: Colors.grey[100],
        child: InkWell(
          splashColor: Colors.blue,
          highlightColor: Colors.blue,
          focusColor: Colors.blue,
          hoverColor: Colors.blue,
          child: Card(
            margin: EdgeInsets.fromLTRB(size.width/59.14, size.height/224, size.width/59.14, size.height/224),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0.0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: size.height/12,
                    width: size.width/6.93,
                    margin: EdgeInsets.fromLTRB(size.width/20.7, size.height/180, size.width/41.4, size.height/180),
                    child: Image.asset(item.img),
                  ),
                  SizedBox(
                    width: size.width / 20.7,
                  ),
                  Container(
                    width: size.width / 3.183,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: TextStyle(fontSize: size.height / 46.8,fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height / 180.2),
                        Text(item.desc,style: TextStyle(fontSize: size.height / 68.923,color: Color(0xff898989),fontWeight: FontWeight.normal),textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  //SizedBox(width: double.parse(item.value).toStringAsFixed(2).length>5? size.width / 17:size.width/11),
                  SizedBox(width:size.width/11),

                  Container(
                      child: Text(item.value!=null? double.parse(item.value).toStringAsFixed(2):". . .",style: TextStyle(fontSize: size.height / 38)),
                  ),
                  SizedBox(width: 3,),
                  Container(
                     margin: EdgeInsets.fromLTRB(size.width / 150,size.height / 59.73, size.width / 207, 0),
                     child: Text(base.instance.name,style: TextStyle(color: Colors.grey[600],fontSize: size.height / 81.454545)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height / 74.66, 0, 0),
                    child: item.chn.toString() == "+" 
                        ? Icon(Icons.arrow_drop_up,color: Colors.green,size: size.width/13.8,)
                        : item.chn.toString() == "-"
                        ? Icon(Icons.arrow_drop_down,color: Colors.red,size: size.width/13.8,)
                        :Icon(Icons.drag_handle, color: Colors.grey,size: size.width/17,)    
                  )
                ],
              ),
            ),
          ),
          onTap: (){
            print("clicked");
            selected.name=item.name;
            selected.desc=item.desc;
            selected.value=item.value;
            selected.yestval=item.dun;
            print(selected.desc);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> selected_page())).then((value) => stateUpdate());
            
          },
          onLongPress: (){
            setState(() {
              favorite.list.remove(item);
              favorite.encoder();
              Flushbar(
                  title:  item.desc,
                  backgroundColor: Colors.red[300],
                  message:  item.desc+" is deleted from favorites",
                  duration:  Duration(seconds:1),              
              )..show(context);
            });
          },
        ),
      );
    }
    else{
      return Material();
    }

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: favorite.list==null||favorite.list.length==0
        ?Center(child: Text("Uploading"))
        : ListView.builder(itemCount: favorite.list.length,itemBuilder: (BuildContext c,int index){
        return cardTile(favorite.list[index],index);
      }),),
    );
  }
}