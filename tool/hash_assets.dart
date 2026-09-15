library;

import 'dart:io';

import 'package:crypto/crypto.dart';

const _buildDir = 'build/jaspr';
const _entryName = 'main.client.dart.js';
const _partSuffix = '.part.js';
const _jsSuffix = '.js';
const _htmlSuffix = '.html';

const _hashLength = 8;
final _hashedEntryPattern = RegExp(r'^main\.client\.dart\.[0-9a-f]{8}\.js$');

void main() {
  final buildDirectory = Directory(_buildDir);
  if (!buildDirectory.existsSync()) {
    _fail('$_buildDir does not exist. Run `jaspr build` first.');
  }

  final entryFile = File('$_buildDir/$_entryName');
  if (!entryFile.existsSync()) {
    _reportAlreadyHashedOrFail(buildDirectory);
    return;
  }

  final partRenames = _hashDeferredParts(buildDirectory);
  _rewritePartUris(entryFile, partRenames);

  final hashedEntryName = _hashEntry(entryFile, buildDirectory);
  _rewriteMarkupReferences(buildDirectory, hashedEntryName);

  stdout.writeln('Hashed $hashedEntryName and ${partRenames.length} deferred parts.');
}

/// Renames every deferred part to carry the hash of its own bytes.
///
/// Returns the old name against the new one, for [_rewritePartUris]. The contents are never touched:
/// the entry file's `deferredPartHashes` are digests of each hunk, and the loader throws when one
/// stops matching.
Map<String, String> _hashDeferredParts(Directory buildDirectory) {
  final children = buildDirectory.listSync();
  final partFiles = children.whereType<File>().where((file) => _nameOf(file).endsWith(_partSuffix));
  final renames = <String, String>{};

  for (final partFile in partFiles) {
    final currentName = _nameOf(partFile);
    final stem = currentName.substring(0, currentName.length - _partSuffix.length);
    final hashedName = '$stem.${_digestOf(partFile)}$_partSuffix';

    partFile.renameSync('${buildDirectory.path}/$hashedName');
    renames[currentName] = hashedName;
  }

  return renames;
}

/// Points the entry file's `deferredPartUris` at the renamed parts.
void _rewritePartUris(File entryFile, Map<String, String> renames) {
  var source = entryFile.readAsStringSync();

  for (final rename in renames.entries) {
    final currentName = rename.key;

    if (!source.contains(currentName)) {
      _fail(
        '$_entryName does not name $currentName. The dart2js output layout changed, and a rename '
        'here would leave the deferred imports pointing at files that no longer exist.',
      );
    }

    source = source.replaceAll(currentName, rename.value);
  }

  entryFile.writeAsStringSync(source);
}

/// Renames the entry file last, so its hash covers the rewritten part URIs.
String _hashEntry(File entryFile, Directory buildDirectory) {
  final stem = _entryName.substring(0, _entryName.length - _jsSuffix.length);
  final hashedName = '$stem.${_digestOf(entryFile)}$_jsSuffix';

  entryFile.renameSync('${buildDirectory.path}/$hashedName');

  return hashedName;
}

/// Points every pre-rendered page at the renamed entry file.
void _rewriteMarkupReferences(Directory buildDirectory, String hashedEntryName) {
  final children = buildDirectory.listSync(recursive: true);
  final markupFiles = children.whereType<File>().where((file) => _nameOf(file).endsWith(_htmlSuffix));
  var rewrittenPages = 0;

  for (final markupFile in markupFiles) {
    final markup = markupFile.readAsStringSync();
    if (!markup.contains(_entryName)) continue;

    markupFile.writeAsStringSync(markup.replaceAll(_entryName, hashedEntryName));
    rewrittenPages++;
  }

  if (rewrittenPages == 0) {
    _fail('No page in $_buildDir loaded $_entryName, so the site would ship without its islands.');
  }
}

/// A second run over an already-hashed build is a no-op; anything else is a broken build.
void _reportAlreadyHashedOrFail(Directory buildDirectory) {
  final children = buildDirectory.listSync();
  final isHashed = children.whereType<File>().any((file) => _hashedEntryPattern.hasMatch(_nameOf(file)));

  if (!isHashed) {
    _fail('$_buildDir holds neither $_entryName nor a hashed one. Run `jaspr build` first.');
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
