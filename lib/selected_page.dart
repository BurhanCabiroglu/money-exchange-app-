import 'dart:convert';

import 'package:MoneyExchangeFlutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'list_page.dart';
import 'package:http/http.dart' as http;
import 'const.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'base.dart';



class gold{
  double value;
  DateTime datetime;

  gold(this.value,this.datetime);
}

class selected_page extends StatefulWidget {
  @override
  _selected_pageState createState() => _selected_pageState();
}


class _selected_pageState extends State<selected_page> {
  
  static List<gold> rates_series=new List();

  Color change_color;
  double changeval=0;

  String lastweek="...";
  
  String lastmonth="...";

  Future<void> getData() async{
    rates_series=new List();
    DateTime now=new DateTime.now();
    DateTime last=new DateTime(now.year,now.month,now.day-30);

    http.Response response=await http.get("https://api.exchangeratesapi.io/history?start_at="+getDateStr(last)+"&end_at="+getDateStr(now)+"&base="+base.instance.name+"&symbols="+selected.name);
    http.Response responselastweek=await http.get("https://api.exchangeratesapi.io/"+getDateStr(new DateTime(now.year,now.month,now.day-7))+"?base="+base.instance.name+"&symbols="+selected.name);
    http.Response responselastmonth=await http.get("https://api.exchangeratesapi.io/"+getDateStr(new DateTime(now.year,now.month-1,now.day))+"?base="+base.instance.name+"&symbols="+selected.name);
    var responseJson=json.decode(response.body);
    responseJson=responseJson["rates"];
    

    for(int i=0;i<30;i++){
      DateTime gel=new DateTime(now.year,now.month,now.day-30+i);
          if(responseJson[getDateStr(gel)]!=null){
              rates_series.add(new gold(1/double.parse(responseJson[getDateStr(gel)][selected.name].toString()), gel)); 
          }
    }



    var resweek=json.decode(responselastweek.body);
    var resmonth=json.decode(responselastmonth.body);

    lastmonth=resmonth["rates"][selected.name].toString();
    lastweek=resweek["rates"][selected.name].toString();

    print(resweek);
    print(resmonth);
      setState(() {
        print("selected page");
        
      });
      
    print("veriler alındı");
    
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


 @override
 void initState(){
   getData();


   setState(() {
     changeval=double.parse(double.parse(selected.value).toStringAsFixed(2))-double.parse(double.parse(selected.yestval).toStringAsFixed(2));
     changeval=changeval/double.parse(double.parse(selected.value).toStringAsFixed(2))*100.0;
     if(changeval>0){
       change_color=Colors.green[500];
     }
     else if(changeval<0){
       change_color=Colors.red[400];
     }
     
   });
   super.initState();
 } 
  
  _getSeriesData() {
    List<charts.Series<gold, DateTime>> series = [
      charts.Series(
        id: "Population",
        data: rates_series,
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
     return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
       home:Scaffold(
       appBar: AppBar(
          title: Text(selected.desc,style: TextStyle(color: lightGrey,fontSize: size.height/42.66)),
          centerTitle: true,
          leading: FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            padding: EdgeInsets.symmetric(horizontal: size.width/82.8,vertical:size.height/179.2),
            color: white,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(size.height/44.8)),
            child: Icon(Icons.arrow_back,color: lightGrey,),
          ),
        ),
        
      backgroundColor:Colors.white,
      body: Container(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Container(
                    width: size.width/0.92,
                    padding: EdgeInsets.fromLTRB(size.width/13.8, size.height/56, 0, size.height/64),
                    child: Text("1 "+selected.desc+" equal to",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.075)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(size.width/13.8, 0, size.width/82.8, 0),
                        child: Text(double.parse(selected.value).toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/33.185),textAlign: TextAlign.left,),
                     ),
                     Container(
                        padding: EdgeInsets.fromLTRB(size.width/82.8, 0, 0, 0),
                        child: Text(base.instance.desc,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                     ),
                    
                    Container(
                      padding: EdgeInsets.fromLTRB(size.width/20.7, 0, 0, 0),
                      child: Text("% "+changeval.toStringAsFixed(2),style: TextStyle(color:change_color,fontSize: size.height/52.075,fontWeight: FontWeight.w600),),
                    )

                    ],
                ),
                Container(
                    width: size.width/0.92,
                    padding: EdgeInsets.fromLTRB(size.width/13.8, size.height/44.8, 0, size.width/82.8),
                    child: Text(DateTime.now().day.toString()+" "+getMonth(DateTime.now().month-1)+" "+DateTime.now().year.toString(),style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/68.923)),
                  ),
                SizedBox(height: size.height/44.8),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width/41.4),
                  height: size.height/3.584,
                  width: size.width/1.035,
                  child: new charts.TimeSeriesChart(
                    _getSeriesData(),
                    defaultRenderer: new charts.LineRendererConfig(includeArea: true,stacked: true),
                    primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false,desiredTickCount: 4,dataIsInWholeNumbers: false))),
                ),
                SizedBox(height: size.height/17.92),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size.width/13.8,),
                    Text("Yesterday's Data   : ",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.075)),
                    SizedBox(width: size.width/82.8,),
                    Text((double.parse(selected.yestval.toString())).toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                    SizedBox(width: size.width/82.8,),
                    Text(base.instance.name,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                    //Text("   % ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.left,),
                   
                    ],),
                  SizedBox(height: size.height/44.8),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size.width/13.8,),
                    Text("Last Week's Data  : ",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.075)),
                    SizedBox(width: size.width/82.8,),
                    Text(lastweek=="..."?lastweek:(1/double.parse(lastweek.toString())).toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                    SizedBox(width: size.width/82.8,),
                    Text(base.instance.name,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                    //Text("   % ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.left,),
                   
                    ],),
                SizedBox(height: size.height/44.8),
                 Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size.width/13.8,),
                    Text("Last Month's Data : ",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/52.075)),
                    SizedBox(width: size.width/82.8,),
                    Text(lastmonth=="..."?lastmonth:(1/double.parse(lastmonth.toString())).toStringAsFixed(2),style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: size.height/42.66),textAlign: TextAlign.left,),
                    SizedBox(width: size.width/82.8,),
                    Text(base.instance.name,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400,fontSize: size.height/74.66),textAlign: TextAlign.left,),
                    //Text("   % ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),textAlign: TextAlign.left,),
                   
                    ],),
              
              ],
          ),
      ),
    ),
  
     );
     
  }
}