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
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
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
              fontSize: 14,
              color: Color(0xff000000),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'OpenLayers',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () { launchUrl(Uri(
                        scheme: 'https',
                        host:'openlayers.org'));
                    },
                ),
                const TextSpan(
                  text: ' which is licenced under the ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'BSD 2-Clause License.',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () { launchUrl(Uri(
                        scheme: 'https',
                        host: 'www.tldrlegal.com',
                        path: '/license/bsd-2-clause-license-freebsd'));
                    },
                ),
                const TextSpan(
                  text: " OpenLayers provides the Api to display and manipulate the map in this application.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'OpenStreetMap',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () { launchUrl(Uri(
                        scheme: 'https',
                        host:'www.openstreetmap.org'));
                    },
                ),
                const TextSpan(
                  text: ' which is licenced under the ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Open Data Commons Open Database License.',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () { launchUrl(Uri(
                        scheme: 'https',
                        host: 'www.openstreetmap.org',
                        path: '/copyright'));
                    },
                ),
                const TextSpan(
                  text: " Open Street Maps provides the data used for the map in this application.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}