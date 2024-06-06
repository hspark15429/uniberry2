import 'dart:io';

import 'package:typesense/typesense.dart';

void main() async {
  // Replace with your configuration
  const host = 'en26j4yxt9m7pfkip-1.a1.typesense.net';
  const protocol = Protocol.https;
  final config = Configuration(
    // Api key
    '058Tok9mJzeZggOm9u4I80UPGntwEEp1',
    nodes: {
      Node(
        protocol,
        host,
        port: 443,
      ),
    },
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: const Duration(seconds: 2),
  );

  final client = Client(config);

  final searchParameters = {
    'q': '',
    'query_by': 'periods,term,campuses,schools',
    'filter_by': '',
    'include_fields': 'courseId',
  };

  print(await client.collection('courses').documents.search(searchParameters));
}
