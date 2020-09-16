import 'foreign.dart';
import 'main.dart';

class base{


  static foreign instance;  

  static foreign decoder(String item){

    foreign instance;

      switch(item.toLowerCase()){
        case "usd":
        instance= public.currencyList[0];
        break;
        case "eur":
        instance= public.currencyList[1];
        break;
        case "gbp":
        instance= public.currencyList[2];
        break;
        case "jpy":
        instance= public.currencyList[3];
        break;
        case "aud":
        instance= public.currencyList[4];
        break;
        case "cad":
        instance= public.currencyList[5];
        break;
        case "chf":
        instance= public.currencyList[6];
        break;
        case "cny":
        instance= public.currencyList[7];
        break;
        case "try":
        instance= public.currencyList[8];
        break;
        case "hkd":
        instance= public.currencyList[9];
        break;
        case "inr":
        instance= public.currencyList[10];
        break;
        case "rub":
        instance= public.currencyList[11];
        break;
        case "dkk":
        instance= public.currencyList[12];
        break;
        case "krw":
        instance= public.currencyList[13];
        break;
      
    }
    return instance;
  }

  static encoder() async{
    
    await public.prefs.setString("base", base.instance.name);
    
  
   }
}