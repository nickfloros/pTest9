import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:js/js.dart' as js;

import 'mfordgae.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('line-chart')
class LineChart extends PolymerElement {
  
  bool get applyAuthorStyles => true;

  var _chartOptions;
  
  LineChart.created() : super.created() {
    
    js.context.google.load('visualization', '1', js.map(
                                                        {
                                                          'packages': ['corechart'],
                                                          'callback': _initChart,
                                                        }));
  }
  
  void _initChart() {

  }
}
