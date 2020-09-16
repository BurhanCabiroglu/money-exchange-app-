class foreign {
  String name;
  String value;
  final img;
  String symbol;
  final desc;
  var chn;
  String dun;

  foreign(this.name, this.value, this.img, this.symbol, this.desc, this.chn,
      this.dun);

  change(var n, var g) {
    this.value = n;
    double ara=1.0/double.parse(g);
    this.dun = ara.toString();
    /*
      if (double.parse(n) > (double.parse(dun))) {
        chn = "+";
        print("bugün:" +n+"  dun:"+dun+chn);
      } else if (double.parse(n) <(double.parse(dun))) {
        chn = "-";
        print("bugün:" +n+"  dun:"+dun+chn);
      } else {
        chn = "=";
      }
    */
    double change_val=double.parse(double.parse(this.value).toStringAsFixed(2))-double.parse(double.parse(this.dun).toStringAsFixed(2));

    if (change_val>0) {
        chn = "+";
        print("bugün:" +n+"  dun:"+dun+chn);
      } else if (change_val<0) {
        chn = "-";
        print("bugün:" +n+"  dun:"+dun+chn);
      } else {
        chn = "=";
      }
  }
}
