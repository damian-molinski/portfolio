// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:portfolio/ui/contact/view/contact_form.dart' as _contact_form;
import 'package:portfolio/ui/copy_email/view/copy_email_button.dart'
    as _copy_email_button;
import 'package:portfolio/ui/core/components/icons.dart' as _icons;
import 'package:portfolio/ui/core/components/mono_button.dart' as _mono_button;
import 'package:portfolio/ui/core/components/node_link.dart' as _node_link;
import 'package:portfolio/ui/core/components/section_heading.dart'
    as _section_heading;
import 'package:portfolio/ui/core/components/section_shell.dart'
    as _section_shell;
import 'package:portfolio/ui/core/components/spec_card.dart' as _spec_card;
import 'package:portfolio/ui/core/components/spec_entry_card.dart'
    as _spec_entry_card;
import 'package:portfolio/ui/core/components/status_dot.dart' as _status_dot;
import 'package:portfolio/ui/core/components/tag_pill.dart' as _tag_pill;
import 'package:portfolio/ui/core/view/app_shell.dart' as _app_shell;
import 'package:portfolio/ui/core/view/site_footer.dart' as _site_footer;
import 'package:portfolio/ui/core/view/site_header.dart' as _site_header;
import 'package:portfolio/ui/core/theme.dart' as _theme;
import 'package:portfolio/ui/home/view/sections/contact.dart' as _contact;
import 'package:portfolio/ui/home/view/sections/hero.dart' as _hero;
import 'package:portfolio/ui/home/view/sections/projects.dart' as _projects;
import 'package:portfolio/ui/home/view/sections/signals_dock.dart'
    as _signals_dock;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _contact_form.ContactForm: ClientTarget<_contact_form.ContactForm>(
      'contact_form',
    ),
    _copy_email_button.CopyEmailButton:
        ClientTarget<_copy_email_button.CopyEmailButton>(
          'copy_email_button',
          params: __copy_email_buttonCopyEmailButton,
        ),
  },
  styles: () => [
    ..._theme.styles,
    ..._icons.iconStyles,
    ..._contact_form.ContactFormState.styles,
    ..._copy_email_button.CopyEmailButtonState.styles,
    ..._mono_button.MonoButton.styles,
    ..._node_link.NodeLink.styles,
    ..._section_heading.SectionHeading.styles,
    ..._section_shell.SectionShell.styles,
    ..._spec_card.SpecCard.styles,
    ..._spec_entry_card.SpecEntryCard.styles,
    ..._status_dot.StatusDot.styles,
    ..._tag_pill.TagPill.styles,
    ..._app_shell.AppShell.styles,
    ..._site_footer.SiteFooter.styles,
    ..._site_header.SiteHeader.styles,
    ..._contact.Contact.styles,
    ..._hero.Hero.styles,
    ..._projects.Projects.styles,
    ..._signals_dock.SignalsDock.styles,
  ],
);

Map<String, Object?> __copy_email_buttonCopyEmailButton(
  _copy_email_button.CopyEmailButton c,
) => {'isIconOnly': c.isIconOnly};
