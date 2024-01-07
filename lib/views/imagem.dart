import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cosmicvision/imagehelper.dart';
import 'package:cosmicvision/models/nasa_api_client.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:translator/translator.dart';

class ImagemDoDia extends StatefulWidget {
  const ImagemDoDia({Key? key}) : super(key: key);

  @override
  ImagemDoDiaState createState() => ImagemDoDiaState();
}

class ImagemDoDiaState extends State<ImagemDoDia> {
  late Future<Map<String, dynamic>> imagemDoDia;
  final NasaApiClient nasaApiClient =
      NasaApiClient(apiKey: 'RvMqHjtuK9Cm1X7WZYmtJ0KWskxuGdYw4uzpgqwV');

  dynamic _response;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    imagemDoDia = nasaApiClient.pegarImagemDoDia();
    data = {};
  }

  Future<String> traduzirTexto(String texto) async {
    final translator = GoogleTranslator();
    var traducao = await translator.translate(texto, from: 'en', to: 'pt');
    return traducao.text;
  }

  void _traduzirInformacoes() async {
    // Verifica se 'title' e 'explanation' não são nulos ou ausentes no mapa
    if (data['title'] != null && data['explanation'] != null) {
      final tituloTraduzido = await traduzirTexto(data['title']);
      final explicacaoTraduzida = await traduzirTexto(data['explanation']);
      // Atualiza o estado com as informações traduzidas
      setState(() {
        data['title'] = tituloTraduzido;
        data['explanation'] = explicacaoTraduzida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 74, 140, 245),
        onPressed: _traduzirInformacoes,
        child: const Icon(
          Icons.g_translate,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                'Imagem do Dia',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
            Text(
              "-",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize: 23,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF194B39),
      ),
      body: Center(
          child: FutureBuilder<Map<String, dynamic>>(
        future: imagemDoDia,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Color(0xFF194B39));
          } else if (snapshot.hasError || snapshot.data == null) {
            return const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
              size: 60,
            );
          } else {
            final data = snapshot.data!;
            final mediaType = data['media_type'];
            final imageUrl = data['hdurl'];
            final videoUrl = data['video_url'];
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                        child: Text(
                          data['title'].toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: mediaType == 'image'
                        ? Image.network(imageUrl, width: double.infinity)
                        : _YoutubePlayerWidget(videoUrl: videoUrl!),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF194B39),
                            ),
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.floppyDisk,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ImageHelper imageHelper = ImageHelper();
                            if (imageUrl.isNotEmpty) {
                              imageHelper.downloadMedia(
                                  context, imageUrl); // Para imagens
                            } else if (_response != null) {
                              imageHelper.downloadMedia(context, _response);
                            }
                          },
                          label: Text(
                            'Baixar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF194B39),
                            ),
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.shareNodes,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              ImageHelper().shareImage(context, imageUrl),
                          label: Text(
                            'Compartilhar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      "Descrição".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: const Color.fromARGB(255, 0, 230, 148),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Text(
                      data['explanation'],
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      )),
    );
  }
}

class _YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const _YoutubePlayerWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF286650),
      progressColors: const ProgressBarColors(
        playedColor: Color(0xFF286650),
        handleColor: Color(0xFF286650),
      ),
      onReady: () {},
      onEnded: (data) {},
    );
  }
}
