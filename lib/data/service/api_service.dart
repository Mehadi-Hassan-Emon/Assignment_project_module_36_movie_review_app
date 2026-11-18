import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:movie_review_app/core/app_strings.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:http/http.dart' as http;

import '../../data/model/model.dart';

class ApiService {
  Future<List<Movie>> getTrendingMovies() async {
    final url = Uri.parse('${AppStrings.baseUrl}/trending/all/week');
    debugPrint('GET $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': AppStrings.authorizationToken,
        'accept': 'application/json',
      },
    );

    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('${AppStrings.baseUrl}/search/movie?query=$query');
    debugPrint('GET $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': AppStrings.authorizationToken,
        'accept': 'application/json',
      },
    );

    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  //Top layer
  Map<String, dynamic> parseMovieDetails(String responseBody) {//api te big kono data anle ui te chap komanor jonno parse lageh
    return jsonDecode(responseBody);
  }

  //2nd layer

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = Uri.parse('${AppStrings.baseUrl}/movie/$movieId');
    debugPrint('GET $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': AppStrings.authorizationToken,
        'accept': 'application/json',
      },
    );

    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200) {
      // return jsonDecode(response.body);
      return compute(parseMovieDetails, response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}