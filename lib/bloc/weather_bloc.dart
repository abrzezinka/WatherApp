import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/weather_data/weather_data.dart';
import 'package:weather_app/repository/weather_repository.dart';

class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String _city;

  FetchWeather(this._city);

  @override
  List<Object> get props => [_city];
}

class ResetWeather extends WeatherEvent {}

class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherIsNotSearched extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherData get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository repository = WeatherRepository();

  WeatherBloc() : super(WeatherIsNotSearched()) {
    on<FetchWeather>(_onFetchWeather);
  }

  void _onFetchWeather(WeatherEvent event, Emitter<WeatherState> emit) async {
    if (event is FetchWeather) {
      emit(WeatherIsLoading());
      try {
        WeatherData data = await repository.callApi(event._city);
        print(data);
        emit(WeatherIsLoaded(data));
      } catch (_) {
        print(_);
        emit(WeatherIsNotLoaded());
      }
    } else if (event is ResetWeather) {
      emit(WeatherIsNotSearched());
    }
  }

/*
  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherIsLoading();
      try {
        WeatherData data = await repository.callApi(event._city);
        yield WeatherIsLoaded(data);
      } catch (_) {
        yield WeatherIsNotLoaded();
      }
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearched();
    }
  }
*/

}
