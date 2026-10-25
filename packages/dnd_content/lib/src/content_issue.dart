/// Problème de validation d'un contenu, localisé par son chemin JSON.
final class ContentIssue {
  const ContentIssue(this.path, this.message);

  final String path;
  final String message;

  @override
  String toString() => '$path : $message';
}
