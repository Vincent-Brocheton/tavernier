import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

/// Demande au navigateur de ne pas évincer les données du site (ENF-07) ;
/// `false` si le navigateur refuse ou n'offre pas l'API (contexte non
/// sécurisé). Firefox peut laisser la réponse en attente tant que
/// l'utilisateur n'a pas répondu à son invite : ne pas l'attendre au
/// démarrage.
Future<bool> requestPersistentStorage() async {
  if (!window.navigator.has('storage')) return false;
  return (await window.navigator.storage.persist().toDart).toDart;
}
