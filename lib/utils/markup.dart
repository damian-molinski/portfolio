String classNames(List<String?> names) {
  return names.nonNulls.where((name) => name.isNotEmpty).join(' ');
}

Map<String, String> externalLinkAttributes({String? ariaLabel}) {
  return {'rel': 'noopener noreferrer', if (ariaLabel != null) 'aria-label': ariaLabel};
}
