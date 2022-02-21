import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:pelis_app/models/models.dart';

class CardSwiperWidget extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiperWidget({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightAppBar = Scaffold.of(context).appBarMaxHeight;
    final size = MediaQuery.of(context).size;
    final altura = size.height - heightAppBar!;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: altura * 0.55,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: altura * 0.55,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.5,
        itemHeight: altura * 0.5,
        itemBuilder: (context, index) {
          final movie = movies[index];
          movie.heroId = 'SwiperMovie-${movie.id}';
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
