import 'dart:ui';
import 'package:MoneyExchangeFlutter/const.dart';
import 'package:MoneyExchangeFlutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'base.dart';
import 'package:flutter/material.dart';


class select_base_page extends StatefulWidget {
  @override
  _select_base_pageState createState() => _select_base_pageState();
}

class _select_base_pageState extends State<select_base_page> {
 
 

  @override
  void initState() {

    super.initState();
  }

  Widget list_view(BuildContext context){
    return ListView.builder(itemCount: public.currencyList.length,itemBuilder: (BuildContext c,int index){
      return Material(
        color: Colors.grey[100],
        child: InkWell(
          onTap: (){
              Navigator.pop(context);
              setState(() {
                base.instance=public.currencyList[index];
              });
          },
          splashColor: Colors.blue,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height/44.8)),
            elevation:0,
            child: Container(
              height: size.height / 12,
              width: size.width / 5.175,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(public.currencyList[index].name+" :  ",style: TextStyle(fontSize: size.height / 55.77,color: Color(0xff898989))),
                    Text(public.currencyList[index].desc,style: TextStyle(fontSize: size.height / 49.77,color: lightGrey)),
                    Text(" : "+public.currencyList[index].symbol,style: TextStyle(fontSize: size.height / 55.77,color: Color(0xff898989))),
                ],),
              ),
            ),
          ),
        ),
      );
    });
  }

      
  @override  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Select a Base Currency",style: TextStyle(color: lightGrey,fontSize: size.height/49.77)),
          centerTitle: true,
          leading: FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            padding: EdgeInsets.symmetric(horizontal:size.width/82.8,vertical:size.height/180),
            color: white,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(size.height/44.8)),
            child: Icon(Icons.arrow_back,color: lightGrey,),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(right: size.width/59.14,left: size.width/59.14,top: size.height/180),
          child: list_view(context),
        ),
        backgroundColor: background,
      ),
    );
  }
}