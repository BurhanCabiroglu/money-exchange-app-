import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'main.dart';

class gold{
  double value;
  DateTime datetime;

  gold(this.value,this.datetime);
}


class gold_page extends StatefulWidget {
  @override
  _gold_pageState createState() => _gold_pageState();
}

class _gold_pageState extends State<gold_page> {
  
  static List<gold> gecici=new List();
  static List<gold> gold_series=new List();

   double onsvalue=0;
   double onsyesterdayvalue=0;
   double changeval=0;
   Icon iconas=new Icon(Icons.arrow_drop_down);
   Color changecolor=Colors.blue;
   double lastweeksdata=0.0;
   double lastmonthsdata=0.0;
   String changemonth="...";
   String changeweek="...";

  Future<void> getData()async{
    gecici=new List();
    gold_series=new List();
    DateTime now=DateTime.now();
    
    var gold_response=await http.get("https://mexchange.azurewebsites.net/api/v1/allons");
    if(gold_response.statusCode==200){
        var golden_json=json.decode(gold_response.body);


    
        for (var item in golden_json) {
            String time=item["tarih"].toString();
            time=time.split("T")[0];
            List tarihs=time.split("-");
            var tarih=new DateTime(int.parse(tarihs[0]),int.parse(tarihs[1]),int.parse(tarihs[2]));
            gecici.add(new gold(double.parse(item["kapanis"].toString()), tarih));
        }
        for(int i=gecici.length-30;i<gecici.length;i++){
            gold_series.add(gecici[i]);
        }
        int size=gecici.length;
        int getweekint=8;
        int getmonthint=31;
        lastweeksdata=gecici[size-8].value;
        lastmonthsdata=gecici[size-31].value;
        if(lastweeksdata==null){
          while (lastweeksdata==null) {
            getweekint++;
            lastweeksdata=gecici[size-getweekint].value;
            print(getweekint.toString()+" index gün haftada bulundu");
          }
        }
        if(lastmonthsdata==null){
          while (lastmonthsdata==null) {
            getmonthint++;
            lastmonthsdata=gecici[size-getmonthint].value;
            print(getweekint.toString()+" index gün ayda bulundu");
          }
        }

    }
    

    

    var onsResponse=await http.get("https://mexchange.azurewebsites.net/api/v1/ons/apikey=554897");
    
    var onsJson=json.decode(onsResponse.body);

    onsvalue= double.parse( onsJson["ons"].toString());
    if(gold_response.statusCode==200){
        onsyesterdayvalue=double.parse(onsJson["cons"].toString());
    
        changeval=(onsvalue-onsyesterdayvalue)/onsvalue*100.0;
    

        if(changeval.toString().contains("-")){
      
        iconas=new Icon(Icons.arrow_drop_down,color: Colors.red[400]);
        changecolor=Colors.red[400];
    }
      else{
     
        iconas=new Icon(Icons.arrow_drop_up,color: Colors.green[400]);
        changecolor=Colors.green[400];
      }
    }
   changemonth=((onsvalue-lastmonthsdata)/onsvalue*100.0).toStringAsFixed(2);
   changeweek=((onsvalue-lastweeksdata)/onsvalue*100.0).toStringAsFixed(2);


    setState(() {
      print("veriler alındı");
      if(gold_response.statusCode==200){
        print("hürriyet connected");

      }
      else{
        print("hürriyet failed");
      }
    });
    
    

  }
  void dispose(){
    super.dispose();
  }
  
  @override
  void initState(){
    super.initState();
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => Flushbar(flushbarPosition: FlushbarPosition.TOP,backgroundColor: Colors.blue[600],title: "Welcome Gold Page!",message: "Please wait for the Gold Data to be updated",duration: Duration(seconds: 3),)..show(this.context));
    });
    getData();
  }




  
_getSeriesData() {
    List<charts.Series<gold, DateTime>> series = [
      charts.Series(
        id: "Population",
        data: gold_series,
        domainFn: (gold series, _) => series.datetime,
        measureFn: (gold series, _) => series.value,
        colorFn: (gold series, _) => charts.MaterialPalette.blue.shadeDefault
      )
    ];
    return series;
}


  String getMonth(int i){
    List<String> month=["January","February","March","April","May","June","July","August","September","October","November","December"];
    return month[i];
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Container(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Container(
                    width: size.width/0.92,
                    padding: EdgeInsets.fromLTRB(size.width/13.8, size.height/56, 0, size.height/64),
                    child: Text("Gold price per ounce equal",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.705)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(size.width/13.8, 0, size.width/82.8, 0),
                        child: Text(onsvalue==0?"...":onsvalue.toStringAsFixed(2).toString(),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/33.185),textAlign: TextAlign.left,),
                     ),
                     Container(
                        padding: EdgeInsets.fromLTRB(size.width/82.8, 0, 0, 0),
                        child: Text("USD",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                     ),
                     Text("   % "+changeval.toStringAsFixed(2),style: TextStyle(color: changecolor,fontWeight: FontWeight.w600,fontSize: size.height/59.73),textAlign: TextAlign.left,),
                    iconas
                    ],
                ),
                Container(
                    width: size.width/0.92,
                    padding: EdgeInsets.fromLTRB(size.width/13.8, size.height/59.73, 0, size.width/82.8),
                    child: Text(DateTime.now().day.toString()+" "+getMonth(DateTime.now().month-1)+" "+DateTime.now().year.toString(),style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/68.92)),
                  ),
                SizedBox(height: size.height/44.8),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width/41.4),
                  height: size.height/3.584,
                  width: size.width/1.035,
                  child: new charts.TimeSeriesChart(
                    _getSeriesData(),
                    defaultRenderer: new charts.LineRendererConfig(includeArea: true,stacked: true),
                    primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false,desiredTickCount: 6,dataIsInWholeNumbers: false))),
                ),
                SizedBox(height: size.height/17.92),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size.width/13.8,),
                    Text("Yesterday's Data :  ",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.705)),
                    SizedBox(width: size.width/82.8,),
                    Text(onsyesterdayvalue==0?"...":onsyesterdayvalue.toStringAsFixed(2).toString(),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                    SizedBox(width: size.width/82.8,),
                    Text("USD",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                    Text("   % "+changeval.toStringAsFixed(2),style: TextStyle(color: changecolor,fontWeight: FontWeight.w600,fontSize: size.height/59.73),textAlign: TextAlign.left,),
                    //iconas
                    ],),
                   
                  

                  SizedBox(height: size.height/45,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                    
                    margin: EdgeInsets.fromLTRB(size.width/13.8, size.height/89.6, 0, 0),
                    child:Text("Last Week's Data :",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.705)),),
                      SizedBox(width: size.width/41.4,),
                       Text(lastweeksdata.toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                       SizedBox(width: size.width/82.8,),
                       Text("USD",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                       Text("   % "+changeweek,style: TextStyle(color: changeweek.contains("-")?Colors.red[400]:Colors.green[500],fontWeight: FontWeight.w600,fontSize: size.height/59.73),textAlign: TextAlign.left,),

                    ],
                  ),
                   SizedBox(height: size.height/45,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                    
                    margin: EdgeInsets.fromLTRB(size.width/13.8, size.height/89.6, 0, 0),
                    child:Text("Last Month's Data :",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.705)),),
                      SizedBox(width: size.width/82.8,),
                       Text(lastmonthsdata.toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                       SizedBox(width: size.width/82.8,),
                       Text("USD",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                      Text("   % "+changemonth,style: TextStyle(color: changemonth.contains("-")?Colors.red[400]:Colors.green[500],fontWeight: FontWeight.w600,fontSize: size.height/59.73),textAlign: TextAlign.left,),

                    ],
                  ),
             
              ],
          ),
      ),
    );
  }
}