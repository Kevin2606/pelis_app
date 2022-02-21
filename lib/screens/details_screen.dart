import 'package:flutter/material.dart';
import 'package:pelis_app/models/models.dart';
import 'package:pelis_app/widgets/widgets.dart' show CastingCardsWidget;

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(
            title: movie.title, fullBackdropPath: movie.fullBackdropPath),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _PosterAndTitle(
                title: movie.title,
                originalTitle: movie.originalTitle,
                fullPosterImg: movie.fullPosterImg,
                voteAverage: movie.voteAverage,
                movieId: movie.heroId!,
              ),
              _Overview(overview: movie.overview),
              CastingCardsWidget(movieId: movie.id)
            ],
          ),
        )
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title, fullBackdropPath;
  const _CustomAppBar(
      {Key? key, required this.title, required this.fullBackdropPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.blueAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/img/loading.gif'),
          image: NetworkImage(fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String title, originalTitle, fullPosterImg;
  final double voteAverage;
  final String movieId;

  const _PosterAndTitle(
      {Key? key,
      required this.title,
      required this.originalTitle,
      required this.fullPosterImg,
      required this.voteAverage,
      required this.movieId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: movieId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(fullPosterImg),
                height: 150,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 225),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Text(
                      'Calificacion: $voteAverage ',
                      style: textTheme.caption,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: const Icon(
                        Icons.star_border_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overview;
  const _Overview({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 20),
      child: Text(
        overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
