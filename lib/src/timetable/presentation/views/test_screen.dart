import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:uniberry2/core/utils/typedefs.dart';

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
    'q': '14002',
    'query_by': 'codes',
    'filter_by': '',
    // 'include_fields': 'courseId',
    'per_page': '1',
    'group_by': 'codes',
    'group_limit': '1'
  };
  // save to a file
  final file = File('search_results.json');
  final result =
      await client.collection('courses').documents.search(searchParameters);
  await file.writeAsString(result.toString());
  print(await client.collection('courses').documents.search(searchParameters));
}
