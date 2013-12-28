library mford_gae;
import 'dart:html';
import 'dart:async';
import 'dart:convert';

part 'model.dart';

class Mford_Gae_Services {
  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1';
  
  Future<List<Site>> readSites() {
    Completer comp = new Completer<List<Site>>();
    HttpRequest.getString('${_url}/sites')
      .then((result) { 
        print('Request complete: $result');
        comp.complete(_parseSites(result));
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }

  /*
   * parse sites response 
   */
  List<Site> _parseSites(var payload) {
    var sites = new List<Site>();
    var map = JSON.decode(payload);
    if (map['status']['success'] == true) {
      var n=0;
      for (var item in map['sites']) {
        var s = new Site.create(n++, 
            item['name'], 
            item['code'],
            double.parse(item['lat']),
            double.parse(item['lt']));
        sites.add(s);
      }
    }
    return sites;
  }
  
  Future<List<AnemometerReading>> readSite(String siteName) {
    
    Completer comp = new Completer<List<AnemometerReading>>();
    
    HttpRequest.getString('${_url}/report?site=${siteName}')
      .then((result) { 
        print('Request complete: $result');
        var map = JSON.decode(result);
        List<AnemometerReading> list = new List<AnemometerReading>();
        if (map['status']['success']) {
          for (var reading in map['readings']) {
            list.add(new AnemometerReading.parse(reading));
          }
        }
        comp.complete(list);
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }
}