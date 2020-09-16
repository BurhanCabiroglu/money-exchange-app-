import 'package:MoneyExchangeFlutter/const.dart';
import 'package:MoneyExchangeFlutter/main.dart';
import 'package:flutter/material.dart';
import 'foreign.dart';
import 'base.dart';
import 'selectForeign1.dart';
import 'selectForeign2.dart';


class selector{
  static foreign foreign1;
  static foreign foreign2;
}

class converter extends StatefulWidget {
  @override
  _converterState createState() => _converterState();
}

class _converterState extends State<converter> {

  //static bool contru=true;

  static TextEditingController inputOneController;
  static TextEditingController inputTwoController;


  @override
  void initState() {
    print(base.instance.desc);
    selector.foreign1=base.instance;
    
   inputOneController = TextEditingController();
   inputTwoController = TextEditingController();
  
   
    super.initState();
  }

  void stateUpdate(){
   setState(() {
      print("State Updated");
   });
    
  }

  void dispose(){
    inputOneController.dispose();
    inputTwoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: 2000,
          child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(height: size.height/14.94),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   FlatButton(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height/89.6)),
                     color: Colors.blue[400],
                     onPressed: (){
                        setState(() {
                           inputOneController.text="";
                           inputTwoController.text="";
                         });
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> selectForeign1())).then((value) => stateUpdate());
                     },
                     child:Container(
                       height: size.height/14.93,
                       width: size.width/4.14,
                       child: Row(children: [SizedBox(width: size.width/51.75,),Icon(Icons.arrow_drop_down,color: Colors.white,size: size.width/13.8,),Text(selector.foreign1!=null?selector.foreign1.name:base.instance.name,style:TextStyle(fontSize: size.height/49.77,color: white,fontWeight: FontWeight.w600))],),
                      )
                    ),

                  
                   SizedBox(width: size.width/10.35),
                   
                   FlatButton(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height/89.6)),
                     color: Colors.blue[400],
                     onPressed: (){
                          setState(() {
                            inputOneController.text="";
                            inputTwoController.text="";
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> selectForeign2())).then((value) => stateUpdate());
                     },
                     child:Container(
                       height: size.height/14.93,
                       width: size.width/4.14,
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [SizedBox(width: 8,),Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,),Text(selector.foreign2!=null?selector.foreign2.name:"Select",style:TextStyle(fontSize: 18,color: white,fontWeight: FontWeight.w600))],),
                      )
                    ),
                   ]),
               SizedBox(height: size.height/89.6),
               Container(
                height: size.height/12.8,
                width: size.width / 1.3,
                margin: EdgeInsets.only(
                    top: size.height / 20, bottom: size.height / 30),
                child: TextField(
                  
                  controller: inputOneController,
                  onChanged: (a) {

                    var d = double.parse(inputOneController.text);

                    if(selector.foreign1!=null && selector.foreign2!=null){
                    inputTwoController.text =
                        (d * double.parse(selector.foreign2.value)/double.parse(selector.foreign1.value))
                              .toStringAsFixed(2)
                              .toString();
                    }
                              
                    return;
                  },
                  style: TextStyle(fontSize: size.height/44.8),
                  decoration: InputDecoration(
                    prefixText:selector.foreign1.symbol,
                    labelText:selector.foreign1.name,
                    labelStyle: TextStyle(fontSize: size.height/64, color: Colors.black87),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.grey[300])),
                    focusColor: lightGrey,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.grey[400])),
                  ),
                ),
              ),
               SizedBox(height: size.height/400),
               Container(
                height: size.height/12.8,
                width: size.width / 1.4,
                child: TextField(
                  style: TextStyle(fontSize: size.height/44.8),
                  readOnly: true,
                  controller: inputTwoController,
                  decoration: InputDecoration(
                    prefixText: selector.foreign2!=null?selector.foreign2.symbol:null,
                    labelText: selector.foreign2!=null?selector.foreign2.name:null,
                    labelStyle: TextStyle(fontSize: size.height/64, color: Colors.black87),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.grey[300])),
                    focusColor: Colors.blueGrey,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height/89.6),
                        borderSide: BorderSide(color: Colors.grey[300])),
                  ),
                ),
              ),
               SizedBox(height: size.height/44.8,),
               FlatButton(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height/89.6)),
                     color: Colors.grey[300],
                     onPressed: (){
                       setState(() {
                        if(selector.foreign1!=null&&selector.foreign2!=null){
                          foreign aradegisken=selector.foreign1;
                          selector.foreign1=selector.foreign2;
                          selector.foreign2=aradegisken;
                          inputOneController.text="";
                          inputTwoController.text="";
                        }
                       });
                     },
                     child: Container(
                       height: size.height/16.29,
                       width: size.width/5.52,
                       child: Icon(Icons.swap_horiz),
                       )
                     ),
             
              ],
          ),
        )
    );
  }
}