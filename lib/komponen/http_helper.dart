//kode http_helper.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/movie.dart';
class HttpHelper {
/*
Kelas ini digunakan untuk mendapatkan data dari themoviedb
dengan metode Upcoming yang memberikan nilai return berupa teks
*/

  final String urlKey = 'api_key=600978bc5c12ae0104be7f290e7575e9'; //1
  final String urlBase = 'https://api.themoviedb.org/3/movie'; //2
  final String urlUpcoming = '/upcoming?'; //3
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase = 'https://api.themoviedb.org/3/movie?'
  'api_key=600978bc5c12ae0104be7f290e7575e9';

  get movieobjects => null; //4
  Future<String> getUpcoming() async {
    //5
    final Uri upcoming = Uri.parse(
        urlBase + urlUpcoming + urlKey + urlLanguage);

    Future<List> getUpComingAsList() async {
      final Uri upcoming =
      Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);
      http.Response result = await http.get(upcoming);
      if (result.statusCode == HttpStatus.ok) {
        final jsonResponseBody = json.decode(result.body); //1
        final movieObjects = jsonResponseBody['results']; //2
        List movies = movieobjects.map((json) => Movie.fromJson(json)).toList();
        return movies;
      } else {
        return [];
      }
    }
//6

    http.Response result = await http.get(upcoming); //7
    if (result.statusCode == HttpStatus.ok) { //8
      String responseBody = result.body;
      return responseBody; //9
    }
    else {
      return '{}'; //10
    }
  }

  Future<List> getUpComingAsList() async {
    final Uri upcoming =
    Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(result.body); //1
      final movieObjects = jsonResponseBody['results']; //2
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
        return movies;
      } else {
        return [];
      }
    }
  Future<List> findMovies(String title) async {
    final Uri query = Uri.parse(urlSearchBase + title);
    http.Response hasilcari = await http.get(query);
    var hasilCari;
    if (hasilCari.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(hasilCari.body);
      final movieObjects = jsonResponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
    }
  }