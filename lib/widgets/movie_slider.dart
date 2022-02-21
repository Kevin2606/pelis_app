import 'package:flutter/material.dart';
import 'package:pelis_app/models/models.dart';

class MovieSliderWidget extends StatefulWidget {
  final List<Movie> moviesPopular;
  final String title;
  final Function onNextPage;

  const MovieSliderWidget(
      {Key? key,
      required this.moviesPopular,
      required this.title,
      required this.onNextPage})
      : super(key: key);

  @override
  State<MovieSliderWidget> createState() => _MovieSliderWidgetState();
}

class _MovieSliderWidgetState extends State<MovieSliderWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    double? maxScrollTemp;
    scrollController.addListener(() {
      double positionScroll = scrollController.position.pixels;
      double maxScroll = scrollController.position.maxScrollExtent;
      if (positionScroll >= maxScroll - 600) {
        if (maxScrollTemp == maxScroll) {
          return;
        } else {
          widget.onNextPage();
          maxScrollTemp = maxScroll;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightAppBar = Scaffold.of(context).appBarMaxHeight;
    final size = MediaQuery.of(context).size;
    final altura = size.height - heightAppBar!;

    return SizedBox(
      width: double.infinity,
      height: altura * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 25),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.moviesPopular.length,
              itemBuilder: (context, index) =>
                  _MoviePoster(movie: widget.moviesPopular[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'SliderMovie-${movie.id}';
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
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
                  width: 130,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
