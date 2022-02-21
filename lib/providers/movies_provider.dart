import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pelis_app/helpers/debouncer.dart';
import 'package:pelis_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseURL = 'api.themoviedb.org';
  final String _apiKey = '4995e2881eeae458975573b5a6e57deb';
  final String _language = 'es-ES';
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  final Debouncer _debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;
  Map<int, List<Cast>> moviesCast = {};

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(
      {required String endpoint, required int page}) async {
    final url = Uri.https(_baseURL, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': page.toString(),
    });
    final response = await http.get(url);
    return response.body;
  }

  void getOnDisplayMovies() async {
    const String endpoint = '3/movie/now_playing';
    final nowPlayingResponse = NowPlayingResponse.fromJson(
        await _getJsonData(endpoint: endpoint, page: 1));
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  void getPopularMovies() async {
    _popularPage++;
    const String endpoint = '3/movie/popular';
    final popularResponse = PopularResponse.fromJson(
        await _getJsonData(endpoint: endpoint, page: _popularPage));
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    String endpoint = '3/movie/$movieId/credits';
    final creditsResponse = CreditsResponse.fromJson(
        await _getJsonData(endpoint: endpoint, page: _popularPage));

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseURL, '/3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    _debouncer.value = '';
    _debouncer.onValue = (value) async {
      final suggestions = await searchMovies(value);
      _suggestionStreamController.add(suggestions);
    };
    final timer = Timer.periodic(const Duration(microseconds: 300), (timer) {
      _debouncer.value = query;
    });
    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
