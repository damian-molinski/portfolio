/// Joins the class names that are actually present, dropping nulls and blanks.
///
/// The call sites are all the same shape — a base class, then modifiers that depend on a variant, a
/// flag or a caller-supplied extra — and writing that shape out by hand produced a different answer
/// each time: a `join`, a ternary that repeated the base, and string interpolation.
String classNames(List<String?> names) {
  return names.nonNulls.where((name) => name.isNotEmpty).join(' ');
}

/// The attributes every outbound link carries, with [ariaLabel] when the visible text does not say
/// where the link goes on its own.
///
/// `rel="noopener noreferrer"` is the reason this is shared rather than typed out: it is a security
/// default, and a link that quietly forgets it hands the destination a handle on this page.
Map<String, String> externalLinkAttributes({String? ariaLabel}) {
  return {'rel': 'noopener noreferrer', if (ariaLabel != null) 'aria-label': ariaLabel};
}
