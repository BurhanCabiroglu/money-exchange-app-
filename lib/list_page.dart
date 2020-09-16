import 'dart:convert';

import 'package:MoneyExchangeFlutter/base.dart';
import 'package:MoneyExchangeFlutter/favorites_page.dart';
import 'package:MoneyExchangeFlutter/foreign.dart';
import 'package:MoneyExchangeFlutter/selected_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';



class selected{
  static String name;
  static String value;
  static String yestval;
  static String desc;
}


class list_page extends StatefulWidget {
  @override
  _list_pageState createState() => _list_pageState();
}



class _list_pageState extends State<list_page> {

  @override
  void initState(){
    updateState();
    getData();
    super.initState();
  }

  void updateState(){
    setState(() {
      print("list page updated");
    });
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
    //String resp_yesterday=yesterday.year.toString()+"-"+yesterday.month.toString()+"-"+yesterday.day.toString();

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
            margin: EdgeInsets.fromLTRB(size.width/59, size.height/224, size.width/59, size.height/224),
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
                    child:  Image.asset(item.img)
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
                  SizedBox(width: double.parse(item.value).toStringAsFixed(2).length>6?0:double.parse(item.value).toStringAsFixed(2).length>5? size.width / 40:size.width/17),
                  Container(
                      width: size.width/414 * double.parse(item.value).toStringAsFixed(2).length*15.0,
                      padding: EdgeInsets.all(0),
                      child: Text(item.value!=null? double.parse(item.value).toStringAsFixed(2):"...",style: TextStyle(fontSize:double.parse(item.value.toString()).toStringAsFixed(2).length>5 ?size.height/45:size.height / 40),textAlign: TextAlign.right,),
                  ),
                  Container(
                     margin: EdgeInsets.fromLTRB(size.width / 100,size.height / 59.73, size.width / 207, 0),
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

            if(!favorite.list.contains(item)){
                Flushbar(
                  title:  item.desc,
                  backgroundColor: Colors.green[300],
                  message:  item.desc+" is added to favorites",
                  duration:  Duration(seconds:1),              
              )..show(context);
               favorite.list.add(item);
               favorite.encoder();
            }
            else{
              Flushbar(
                  title:  item.desc,
                  backgroundColor: Colors.red[300],
                  message:  item.desc+" is already added to favorites ",
                  duration:  Duration(seconds:1),  
                              
              )..show(context);
             
            }
            
            

           
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
      body: ListView.builder(itemCount: public.currencyList.length,itemBuilder: (BuildContext c,int index){
        return cardTile(public.currencyList[index],index);
      }),
    );
  }
}