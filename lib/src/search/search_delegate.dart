// DELEGATE ES UNA CLASE QUE TIENE QUE CUMPLIR CIERTOS METODOS
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate {

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Iron man',
    'Shazam',
    'Antman',
    'Iron man 2',
    'Iron man 3',
    'Iron man 4',
    'Iron man 5'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America',
    'Hulk'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
      // TODO: implement buildActions
      // Seran las acciones de nuestro AppBar
      // Ejemplo: un botor de limpiar la consulta o cancelar la busqueda
      return [
        IconButton(
          icon: Icon( Icons.clear ), 
          onPressed: (){
            query = '';
          },
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // TODO: implement buildLeading
      // El build leadind es algo que aparece al inicio
      // En este caso seria un icono que aparece a la izquierda del AppBar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), 
        onPressed: (){
          close(context, null);
        }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      // El BuildResult crea los resultados que vamos a mostrar
      return Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.grey,
          child: Text(seleccion),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // Estas son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot <List<Pelicula>>snapshot) {
        if (snapshot.hasData) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text( pelicula.title ),
                subtitle: Text(
                  pelicula.overview,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );


    //     final listaSugerida = ( query.isEmpty ) 
    //                     ? peliculasRecientes
    //                     : peliculas.where(
    //                       (p) => p.toLowerCase().startsWith(query.toLowerCase())
    //                     ).toList();


    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i){
    //     return ListTile(
    //       leading: Icon( Icons.movie ),
    //       title: Text(listaSugerida[i]),
    //       onTap: (){
    //         seleccion = listaSugerida[i];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
  }
  
}