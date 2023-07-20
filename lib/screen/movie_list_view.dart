import 'package:flutter/material.dart';
import '../komponen/http_helper.dart'; //1

import '../komponen/http_helper.dart';
import 'movie_detail.dart'; //1
class MovieListView extends StatefulWidget { //2
  const MovieListView({Key? key}) : super(key: key);
  @override
  State<MovieListView> createState() => _MovieListViewState();
}
class _MovieListViewState extends State<MovieListView> {
  Icon searchIcon = Icon(Icons.search);
  Widget titleBar = Text('Daftar Film');
//3
  late int moviesCount;
  late List movies;
  late HttpHelper helper;
  //tambahan iconbase
  final String iconbase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fblackpinkupdate.com%2Fblackpink-official-logo-text-jpg';
  void toggleSearch() {
    setState(() {
      if (this.searchIcon.icon == Icons.search) {
        this.searchIcon = Icon(Icons.cancel);
        this.titleBar = TextField(
          autofocus: true,
          onSubmitted: (text) {
            searchMovies(text);
          },
          decoration: InputDecoration(hintText: 'Ketik kata pencarian'),
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        );
      } else {
        setState(() {
          this.searchIcon = Icon(Icons.search);
          this.titleBar = Text('Daftar Film');
        });
        defaultList();
      }
    });
  }
  @override
  void initState() { //4
    defaultList();
    super.initState();
  }
  Future defaultList() async { //5
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getUpComingAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    NetworkImage image; //tambahan image
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
             ListTile(
               title: Text('Upcoming'),
          onTap: () {
          Navigator.pop(context); //untuk menutup drawer
            setState(() {
              this.searchIcon = Icon(Icons.search);
              this.titleBar = Text('Daftar Film');
            });
          defaultList(); //perintah getUpcoming()
          },
        ),
        ListTile(
        title: Text('Cari'),
      onTap: () {
          Navigator.pop(context);
          setState(() {
            this.searchIcon = Icon(Icons.cancel);
            this.titleBar = TextField(
                autofocus: true,
                onSubmitted: (text) {
              searchMovies(text); //perintah cari Movie
            },
            decoration:
            InputDecoration(hintText: 'ketik kata pencarian'),
            textInputAction: TextInputAction.search,
            style: TextStyle(
            color: Colors.cyan,
            fontSize: 20.0
            ),
            );
          });
      }
    ),
    ListView.builder( //6
        itemCount: moviesCount,
        itemBuilder: (context, position) {
          //tambahan kode untuk akses image pada url
          if (movies[position].posterPath !=null) {
            image = NetworkImage(iconbase + movies[position].posterPath);
          }else{
            image=NetworkImage(defaultImage);
          }
          return Card(
            elevation: 2,
            child: ListTile(
              onTap: () { //1
                MaterialPageRoute route = MaterialPageRoute( //2
                  builder: (context) {
                    return MovieDetail(
                      selectedMovie: movies[position],
                    );
                  },
                );
                Navigator.push(context, route); //3
              },
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(movies[position].title),
              subtitle: Text(
                'Released: ' +
                    movies[position].releaseDate +
                    ' - Vote: ' +
                    movies[position].voteAverage.toString(),
              ),
            ),
          );
        },
      );
  }

  Future searchMovies(String text) async {
    List searchedMovies = await helper.findMovies(text);
    setState(() {
      movies = searchedMovies;
      moviesCount = movies.length;
    });
  }
}
