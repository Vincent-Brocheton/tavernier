// Demande pour rejoindre une table (US-14, EF-TAB-08) : gardée sur l'appareil
// tant qu'elle n'a pas abouti, elle part au retour du réseau ou à la
// connexion du compte.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../settings/device_settings.dart';

enum JoinStatus { idle, waiting, needsAccount, joining, joined, failed }

final class JoinState {
  const JoinState(this.status, {this.code, this.tableId, this.error});

  final JoinStatus status;

  /// Code en attente ; `null` une fois la demande aboutie ou refusée.
  final String? code;

  /// Table rejointe.
  final String? tableId;

  /// Motif du refus du serveur (`invalid_code`, `expired_code`…).
  final String? error;
}

final pendingJoinProvider = NotifierProvider<PendingJoin, JoinState>(
  PendingJoin.new,
);

class PendingJoin extends Notifier<JoinState> {
  static const _key = 'pending_join';

  /// Sans stockage (tests), le code reste en mémoire.
  String? _memory;

  String? get _stored =>
      ref.read(sharedPreferencesProvider)?.getString(_key) ?? _memory;

  set _stored(String? code) {
    _memory = code;
    final prefs = ref.read(sharedPreferencesProvider);
    if (code == null) {
      prefs?.remove(_key);
    } else {
      prefs?.setString(_key, code);
    }
  }

  @override
  JoinState build() {
    ref
      ..listen(onlineProvider, (_, next) {
        if (next.value ?? false) attempt();
      })
      ..listen(currentUserProvider, (_, next) {
        if (next.value != null) attempt();
      });
    final code = _stored;
    if (code == null) return const JoinState(JoinStatus.idle);
    Future.microtask(attempt);
    return JoinState(JoinStatus.waiting, code: code);
  }

  /// Garde [code] et tente de rejoindre.
  Future<void> submit(String code) {
    _stored = code.trim().toUpperCase();
    state = JoinState(JoinStatus.waiting, code: _stored);
    return attempt();
  }

  /// Tente de rejoindre avec le code gardé, si le compte et le réseau le
  /// permettent.
  Future<void> attempt() async {
    final code = _stored;
    if (code == null || state.status == JoinStatus.joining) return;
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null || ref.read(currentUserProvider).value == null) {
      state = JoinState(JoinStatus.needsAccount, code: code);
      return;
    }
    if (!(ref.read(onlineProvider).value ?? false)) {
      state = JoinState(JoinStatus.waiting, code: code);
      return;
    }
    state = JoinState(JoinStatus.joining, code: code);
    final ({String? tableId, String? error}) result;
    try {
      result = await gateway.joinTable(code);
    } on Object {
      // Réseau perdu en route : le code reste, la demande repartira.
      state = JoinState(JoinStatus.waiting, code: code);
      return;
    }
    _stored = null;
    state = result.tableId != null
        ? JoinState(JoinStatus.joined, tableId: result.tableId)
        : JoinState(JoinStatus.failed, error: result.error);
  }

  /// Oublie l'issue affichée (table rejointe ou refus).
  void acknowledge() {
    if (state.status case JoinStatus.joined || JoinStatus.failed) {
      state = const JoinState(JoinStatus.idle);
    }
  }
}
