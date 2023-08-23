class DosageDetails {
  List<Map<String,String>> dosageDetails;
  DosageDetails(this.dosageDetails);
}
class Dose{
  Map<String,DosageDetails> details;
  Dose(this.details);
}