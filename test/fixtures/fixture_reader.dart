import 'dart:io';

String fixture(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();

String fixtureTools(String fileName) =>
    File('tools/$fileName').readAsStringSync();
