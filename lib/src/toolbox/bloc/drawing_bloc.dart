import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:webtile38/src/map_component/open_street_map.dart';
import './bloc.dart';
import 'package:webtile38/src/sketch_maker/draw.dart';
import 'package:webtile38/src/sketch_maker/draw_rectangle.dart';
import 'package:webtile38/src/sketch_maker/draw_circle.dart';
import 'package:webtile38/src/sketch_maker/draw_polygon.dart';

class SketchBloc extends Bloc<OptionsEvent, DrawingState> {
  OpenStreetMap map;
  String label;
  Draw _draw;
  final AreaBloc _areaBloc;

  SketchBloc(this._areaBloc);
  @override
  DrawingState get initialState => InactiveDrawingState();

  @override
  Stream<DrawingState> mapEventToState(
    OptionsEvent event,
  ) async* {
    _draw?.active = false;
    _draw = null;

    DrawingState result = InactiveDrawingState();

    if (event is PolygonOptionEvent) {
      _draw = DrawPolygon(map.map, _areaBloc, event.text);
    } else if (event is RectangleOptionEvent) {
      _draw = DrawRectangle(map.map, _areaBloc, event.text);
    } else if (event is CircleOptionEvent) {
      _draw = DrawCircle(map.map, _areaBloc, event.text);
    }

    if (_draw is Draw) {
      _draw.active = true;
      result = ActiveDrawingState(_draw);
    }
    yield result;
  }
}
