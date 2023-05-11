import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    const double fontSize = 18;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "This application was made with:",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: fontSize,
                color: Color(0xff000000),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                    key: const Key("Open layers credit"),
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'OpenLayers',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(
                                  Uri(scheme: 'https', host: 'openlayers.org'));
                            },
                        ),
                        const TextSpan(
                          text: ' which is licenced under the ',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'BSD 2-Clause License.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.tldrlegal.com',
                                  path:
                                      '/license/bsd-2-clause-license-freebsd'));
                            },
                        ),
                        const TextSpan(
                          text:
                              " OpenLayers provides the Api to display and "
                                  "manipulate the map in this application.",
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    key: const Key("Open Street Map credit"),
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'OpenStreetMap',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.openstreetmap.org'));
                            },
                        ),
                        const TextSpan(
                          text: ' which is licenced under the ',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Open Data Commons Open Database License.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.openstreetmap.org',
                                  path: '/copyright'));
                            },
                        ),
                        const TextSpan(
                          text:
                              " Open Street Maps provides the data used for the "
                                  "map in this application.",
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    key: const Key("Open Source Routing Machine credit"),
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Open Source Routing Machine',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'project-osrm.org'));
                            },
                        ),
                        const TextSpan(
                          text: ' which is licenced under the ',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'permissive 2-clause BSD license.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'opensource.org',
                                  path: '/license/bsd-2-clause/'));
                            },
                        ),
                        const TextSpan(
                          text:
                          " ORSM provides the routing engine used by this application.",
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    key: const Key("openstreetmap.de credit"),
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'routing.openstreetmap.de.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'routing.openstreetmap.de'));
                            },
                        ),
                        const TextSpan(
                          text: ' This server is sponsored by ',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Fossgis.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.fossgis.de'));
                            },
                        ),
                        const TextSpan(
                          text: ' The full licence can be viewed in german ',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'on the fossgis website.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.fossgis.de',
                                  path: '/arbeitsgruppen/osm-server/nutzungsbedingungen/'));
                            },
                        ),
                        const TextSpan(
                          text:
                          " routing.openstreetmap.de provides the server that is "
                              "running ORSM and so is providing the service that "
                              "allows this application to providing routing data.",
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    key: const Key("Fix the map"),
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                          "If you find an error with the map please report it ",
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'here.',
                          style: const TextStyle(fontSize: fontSize, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(
                                  scheme: 'https',
                                  host: 'www.openstreetmap.org',
                                  path: '/fixthemap'));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
