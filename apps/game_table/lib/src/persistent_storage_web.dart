import 'dart:js_interop';

import 'package:web/web.dart';

/// Demande au navigateur de ne pas évincer les données du site (ENF-07) ;
/// `false` si le navigateur refuse.
Future<bool> requestPersistentStorage() async =>
    (await window.navigator.storage.persist().toDart).toDart;
