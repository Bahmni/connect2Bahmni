class LabResult {

  String? name;
  DateTime? accessionDateTime;
  dynamic result;
  String? uom;
  bool? abnormal;
  String? uploadedFileName;
  bool? referredOut;
  int? index;
  double? minNormal;
  double? maxNormal;
  String? orderDate;

  LabResult({this.name, this.accessionDateTime, this.result, this.uom, this.abnormal, this.uploadedFileName, this.referredOut, this.index, this.minNormal, this.maxNormal, this.orderDate});

}