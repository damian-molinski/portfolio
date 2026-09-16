// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:portfolio/ui/contact/view/contact_form.dart'
    deferred as _contact_form;
import 'package:portfolio/ui/copy_email/view/copy_email_button.dart'
    deferred as _copy_email_button;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'contact_form': ClientLoader(
      (p) => _contact_form.ContactForm(),
      loader: _contact_form.loadLibrary,
    ),
    'copy_email_button': ClientLoader(
      (p) => _copy_email_button.CopyEmailButton(
        isIconOnly: p['isIconOnly'] as bool,
      ),
      loader: _copy_email_button.loadLibrary,
    ),
  },
);
