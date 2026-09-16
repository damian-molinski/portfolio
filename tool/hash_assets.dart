library;

import 'dart:io';

import 'package:crypto/crypto.dart';

const _buildDir = 'build/jaspr';
const _loaderName = 'main.client.dart.js';
const _moduleName = 'main.client.mjs';
const _programName = 'main.client.wasm';
const _htmlSuffix = '.html';

const _hashLength = 8;
final _hashedLoaderPattern = RegExp(r'^main\.client\.dart\.[0-9a-f]{8}\.js$');

void main() {
  final buildDirectory = Directory(_buildDir);
  if (!buildDirectory.existsSync()) {
    _fail('$_buildDir does not exist. Run `just build` first.');
  }

  final loaderFile = File('$_buildDir/$_loaderName');
  if (!loaderFile.existsSync()) {
    _reportAlreadyHashedOrFail(buildDirectory);
    return;
  }

  if (!File('$_buildDir/$_programName').existsSync()) {
    _fail('$_buildDir holds no $_programName. `jaspr build` ran without `--experimental-wasm`.');
  }

  // The loader names the other two, so they are renamed first and the loader last — its own hash
  // has to cover the rewritten names. `main.client.wasm.map` stays unhashed: its name is written
  // into the program's `sourceMappingURL` section.
  final renames = {
    _programName: _hashInPlace(File('$_buildDir/$_programName')),
    _moduleName: _hashInPlace(File('$_buildDir/$_moduleName')),
  };
  _rewriteLoaderReferences(loaderFile, renames);

  final hashedLoaderName = _hashInPlace(loaderFile);
  _rewriteMarkupReferences(buildDirectory, hashedLoaderName);

  stdout.writeln('Hashed $hashedLoaderName, ${renames.values.join(' and ')}.');
}

String _hashInPlace(File file) {
  final currentName = _nameOf(file);
  if (!file.existsSync()) {
    _fail('$_buildDir holds no $currentName, so the client bundle is incomplete.');
  }

  final extensionStart = currentName.lastIndexOf('.');
  final stem = currentName.substring(0, extensionStart);
  final extension = currentName.substring(extensionStart);
  final hashedName = '$stem.${_digestOf(file)}$extension';

  file.renameSync('${file.parent.path}/$hashedName');

  return hashedName;
}

void _rewriteLoaderReferences(File loaderFile, Map<String, String> renames) {
  var source = loaderFile.readAsStringSync();

  for (final rename in renames.entries) {
    final currentName = rename.key;

    if (!source.contains(currentName)) {
      _fail(
        '$_loaderName does not name $currentName. The generated loader changed, and a rename here '
        'would leave it fetching a file that no longer exists.',
      );
    }

    source = source.replaceAll(currentName, rename.value);
  }

  loaderFile.writeAsStringSync(source);
}

void _rewriteMarkupReferences(Directory buildDirectory, String hashedLoaderName) {
  final children = buildDirectory.listSync(recursive: true);
  final markupFiles = children.whereType<File>().where((file) => _nameOf(file).endsWith(_htmlSuffix));
  var rewrittenPages = 0;

  for (final markupFile in markupFiles) {
    final markup = markupFile.readAsStringSync();
    if (!markup.contains(_loaderName)) continue;

    markupFile.writeAsStringSync(markup.replaceAll(_loaderName, hashedLoaderName));
    rewrittenPages++;
  }

  if (rewrittenPages == 0) {
    _fail('No page in $_buildDir loaded $_loaderName, so the site would ship without its islands.');
  }
}

void _reportAlreadyHashedOrFail(Directory buildDirectory) {
  final children = buildDirectory.listSync();
  final isHashed = children.whereType<File>().any((file) => _hashedLoaderPattern.hasMatch(_nameOf(file)));

  if (!isHashed) {
    _fail('$_buildDir holds neither $_loaderName nor a hashed one. Run `just build` first.');
  }

  stdout.writeln('$_buildDir is already hashed.');
}

String _nameOf(File file) => file.uri.pathSegments.last;

String _digestOf(File file) {
  final bytes = file.readAsBytesSync();
  final digest = sha256.convert(bytes);

  return digest.toString().substring(0, _hashLength);
}

Never _fail(String reason) {
  stderr.writeln('hash_assets: $reason');
  exit(1);
}
