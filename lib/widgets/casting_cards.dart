import 'package:flutter/material.dart';
import 'package:pelis_app/models/models.dart';
import 'package:pelis_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCardsWidget extends StatelessWidget {
  final int movieId;

  const CastingCardsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              height: 190,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const _CastCard(),
              ));
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            height: 190,
            child: ListView.builder(
                itemCount: cast.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _CastCard(cast: cast[index]);
                }));
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast? cast;
  const _CastCard({Key? key, this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(cast == null
                    ? 'https://via.placeholder.com/100x150'
                    : cast!.fullProfilePath),
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            cast == null ? 'Nombre Actor' : cast!.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
