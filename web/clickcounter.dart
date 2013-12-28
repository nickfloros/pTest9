import 'dart:html';
import 'dart:convert';
import 'dart:js';
import 'package:polymer/polymer.dart';
import 'package:js/js.dart' as js;

import 'mfordgae.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('click-counter')
class ClickCounter extends PolymerElement {
  
  List _speedData=[];
  List _directionData=[];
  
  @published int count = 0;
  @published
   List sites = toObservable([]);
  Element _bsmodal;
  var _menu;
  Element _dropMenu;
  /**
   * allow global css style to apply
   */
  bool get applyAuthorStyles => true;
  
//  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1/report?site=HIGHCLIFFE';
  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1/sites';
  ClickCounter.created() : super.created() {
    HttpRequest.getString(_url).then(
        (result) { 
          print('Request complete: $result');
          var map = JSON.decode(result);
          sites.clear();
          sites.addAll(map['sites']);
        });
    //_menu =getShadowRoot('click-counter').querySelector("#menu");
    //_dropMenu = _menu.querySelector('.dropdown-menu');
    ///_menu.onClick.listen( (onData) {
    //  _menu.classes.toggle('open');
    //});
    _bsmodal = shadowRoot.querySelector("#myModal");
    // asynch load visualisation package ..
    js.context.google.load('visualization', '1', js.map(
                                                        {
                                                          'packages': ['corechart'],
                                                          'callback': drawVisualization,
                                                        }));
  }
  var _windSpeedChart;
  var _windDirectionsChart;
  var _windSpeedChartOptions;
  var _windDirectionChartOptions;
  var _gviz;
  void increment() {
    count++;
  }
  void drawVisualization(){
    _gviz = js.context.google.visualization;
    _windSpeedChartOptions = js.map({
      'title': 'Wind speed ',
    'hAxis': {'title': 'Time'},
    'vAxis': {'0':{'title': 'Speed (knots)'},
      '1':{'title': 'Speed (km/h)'}
    }
    });
    
    
    _windDirectionChartOptions = js.map({
      'title': 'Wind direction',
    'hAxis': {'title': 'Time'},
    'vAxis': {
      'title': 'Direction (degrees)',
      'viewWindowMode':'explicit',
      'viewWindow':{
      'max':'360',
      'min':'0'
      }
    }
    });

    _windSpeedChart = new js.Proxy(_gviz.LineChart, getShadowRoot('click-counter').querySelector('#windSpeed'));
    _windDirectionsChart = new js.Proxy(_gviz.LineChart, getShadowRoot('click-counter').querySelector('#windDirection'));
  }
  
  void drawGraph(var title, var speedData, var directionData) {
    
   
    _windSpeedChart.draw(_gviz.arrayToDataTable(js.array(speedData)), 
        _windSpeedChartOptions);
        
    _windDirectionsChart.draw(_gviz.arrayToDataTable(js.array(directionData)), 
        _windDirectionChartOptions);

  }
  Element _previous = null;
  void selection(Event e, var detail, Element target) {
    var val = target.getAttribute('data-value');
    
    if (_previous!=null)
      _previous.classes.toggle('active');
    _previous = target.parent;
    _previous.classes.toggle('active');
    if (val!=null) {
      print('selected is ${val}');
      var svc = new Mford_Gae_Services();
      var future = svc.readSite(val).then( (resp) {
        _speedData.clear();
        _directionData.clear();
        _speedData.add( new List() 
          ..add('Time')
          ..add('Min')
          ..add('Avg')
          ..add('Max')
          );
        
        _directionData.add( new List() 
          ..add('Time')
          ..add('Min')
          ..add('Avg')
          ..add('Max')
          );
                
        for (AnemometerReading item in resp) {
          _speedData.add( new List()
            ..add(item.timeStamp)
            ..add(item.speed.min)
            ..add(item.speed.avg)
            ..add(item.speed.max)
            );
          _directionData.add(new List()
            ..add(item.timeStamp)
            ..add(item.direction.min)
            ..add(item.direction.avg)
            ..add(item.direction.max)
            );
        }
        drawGraph(val,_speedData,_directionData);
        print(resp.length);
      });
      
    }
    else {
      _bsmodal.attributes['aria-hidden']='true';
    }
  }
}

