// ignore_for_file: file_names

import 'package:cosmicvision/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DetalhesImagem extends StatefulWidget {
  final Map<String, dynamic> imageInfo;

  const DetalhesImagem({Key? key, required this.imageInfo}) : super(key: key);

  @override
  State<DetalhesImagem> createState() => _DetalhesImagemState();
}

class _DetalhesImagemState extends State<DetalhesImagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        title: Text(
          widget.imageInfo['title'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF286650),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.network(widget.imageInfo['hdurl']),
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
                      if (widget.imageInfo['hdurl'] != null) {
                        imageHelper.downloadMedia(
                            context, widget.imageInfo['hdurl']); // Para imagens
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
                    onPressed: () => ImageHelper()
                        .shareImage(context, widget.imageInfo['hdurl']),
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
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.imageInfo['explanation'],
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            // Outras informações que você desejar exibir
          ],
        ),
      ),
    );
  }
}
