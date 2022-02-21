import 'package:flutter/material.dart';
import 'package:pelis_app/providers/movies_provider.dart';
import 'package:pelis_app/search/search_delegate.dart';
import 'package:pelis_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelis App'),
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Tarjetas principales
            CardSwiperWidget(movies: moviesProvider.onDisplayMovies),
            //Slider de peliculas
            MovieSliderWidget(
              moviesPopular: moviesProvider.popularMovies,
              title: 'Peliculas populares',
              onNextPage: moviesProvider.getPopularMovies,
            ),
/*             MovieSliderWidget(
              moviesPopular: moviesProvider.popularMovies,
              title: 'Peliculas populares',
            ), */
          ],
        ),
      ),
    );
  }
}
