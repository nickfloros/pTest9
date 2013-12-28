part of mford_gae;


class Site {
  int id;
  
  String stationName;
  String stationCode;
  
  double latitude;
  double longitude;

  Site() {
    
  }
  
  factory Site.create(int id, String name, String code, double latitude, double longitude){
    var value = new Site()
     ..id=id
     ..stationName = name
     ..stationCode = code
     ..latitude = latitude
     ..longitude = longitude;
    
    return value;
  }
}

/**
 * representation of an anemoeter reading 
 */
class AnemometerReading {
  int id;
  DateTime timeStamp;
  WindDirection direction;
  WindSpeed speed;
  
  AnemometerReading() {}

  /**
   * parser 
   */
  factory AnemometerReading.parse(Map jsonMap) {
    var value = new AnemometerReading()
      ..id = jsonMap['id']
      ..timeStamp = DateTime.parse(jsonMap['timeStamp'])
      ..direction = new WindDirection.create(jsonMap['direction'])
      ..speed = new WindSpeed.create(jsonMap['speed']);
    
    return value;
  }
}

/** 
 * wind direction
 */
class WindDirection {
  int min, max, avg;
  
  WindDirection() {
    
  }
  
  factory WindDirection.create(Map jsonMap) {
    var value = new WindDirection()
    ..min = jsonMap['min']
    ..max = jsonMap['max']
    ..avg = jsonMap['avg'];        
    
    return value;
  }
}

/**
 * wind speed
 */
class WindSpeed {
  double min, max, avg;
  
  WindSpeed() {
    
  }
  
  factory WindSpeed.create(Map jsonMap) {
    var value = new WindSpeed()
      ..min = jsonMap['min']
      ..max = jsonMap['max']
      ..avg = jsonMap['avg'];   
    return value;
  }
}
