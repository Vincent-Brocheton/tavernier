// Spec account : « Nouveau mot de passe » (EF-CPT-08).
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/password_policy.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('longueur', () {
    test('10 caractères au moins', () {
      expect(longEnough('123456789'), isFalse);
      expect(longEnough('1234567890'), isTrue);
    });
  });

  group('différent de l\'e-mail et du pseudo', () {
    test('e-mail, partie locale ou pseudo, sans la casse : refusé', () {
      bool differs(String password) => differsFromIdentity(
        password,
        email: 'hugo.martin@exemple.fr',
        pseudonym: 'Grimoire42',
      );
      expect(differs('HUGO.MARTIN@exemple.fr'), isFalse);
      expect(differs('Hugo.Martin'), isFalse);
      expect(differs('grimoire42'), isFalse);
      expect(differs('un-tout-autre'), isTrue);
    });

    test('sans pseudo : seul l\'e-mail compte', () {
      expect(differsFromIdentity('un-mot-de-passe', email: 'a@b.fr'), isTrue);
    });
  });

  group('robustesse, de 0 à 4', () {
    test('court : faible', () {
      expect(strength(''), 0);
      expect(strength('abcdefgh'), 1);
    });

    test('long et varié : fort', () {
      expect(strength('abcdefghij'), 1);
      expect(strength('abcdefghijkl'), 2);
      expect(strength('Abcdefgh-12k'), 3);
      expect(strength('Correct-Cheval-Pile-42'), 4);
    });
  });

  group('Have I Been Pwned', () {
    test('empreinte SHA-1 en hexadécimal majuscule', () {
      expect(sha1Hex('password'), '5BAA61E4C9B93F3F0682250B6CF8331B7EE68FD8');
    });

    test('ne transmet que les 5 premiers caractères de l\'empreinte', () async {
      Uri? asked;
      final checker = BreachedPasswords(
        MockClient((request) async {
          asked = request.url;
          expect(request.headers['Add-Padding'], 'true');
          return http.Response(
            '0000000000000000000000000000000000A:0\r\n',
            200,
          );
        }),
      );
      await checker.isBreached('motdepasse');
      expect(
        asked.toString(),
        startsWith('https://api.pwnedpasswords.com/range/'),
      );
      expect(asked!.pathSegments.last, hasLength(5));
    });

    test('suffixe présent avec un compte > 0 : divulgué', () async {
      final hash = sha1Hex('motdepasse');
      final checker = BreachedPasswords(
        MockClient(
          (_) async =>
              http.Response('AAAAA:3\r\n${hash.substring(5)}:42\r\n', 200),
        ),
      );
      expect(await checker.isBreached('motdepasse'), isTrue);
    });

    test('suffixe de remplissage (compte 0) : non divulgué', () async {
      final hash = sha1Hex('motdepasse');
      final checker = BreachedPasswords(
        MockClient(
          (_) async => http.Response('${hash.substring(5)}:0\r\n', 200),
        ),
      );
      expect(await checker.isBreached('motdepasse'), isFalse);
    });

    test('réponse en erreur : exception, la règle reste à vérifier', () {
      final checker = BreachedPasswords(
        MockClient((_) async => http.Response('', 503)),
      );
      expect(checker.isBreached('motdepasse'), throwsA(anything));
    });
  });
}
