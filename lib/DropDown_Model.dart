
class Localization {
  final List <Zone> zone;
  final List <District> district;

  Localization({this.zone, this.district});

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
 
       
      zone: parseZone(json),
      district: parseDistrict(json),
      
    );
  }

  
  static List<Zone> parseZone(zoneJson) {
    var zlist = zoneJson['zone'] as List;
    List<Zone> zoneList =
      zlist.map((data) => Zone.fromJson(data)).toList();
    return zoneList;
  }

  static List<District> parseDistrict(districtJson) {
    var dlist = districtJson['district'] as List;
    List<District> districtList =
        dlist.map((data) => District.fromJson(data)).toList();
    return districtList;
  }



}

class Zone {
  final int id;
  final String name;

  Zone({this.id, this.name});

  factory Zone.fromJson(Map<String, dynamic> parsedJson){
    return Zone(id: parsedJson['id'], name: parsedJson['name']);
  }

}

class District {
  final int id;
  final String name;
  final int zoneId;

  District({this.id, this.name, this.zoneId});

  factory District.fromJson(Map<String, dynamic> parsedJson) {
    return District(id: parsedJson['id'], name: parsedJson['name'],  zoneId: parsedJson['zone_id']);
  }

}