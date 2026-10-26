import 'package:material_ui/material_ui.dart';
import 'package:path_parsing/path_parsing.dart';

import 'game_icons.dart';

/// Icône de jeu dessinée depuis son tracé, à la taille et à la couleur de
/// l'[IconTheme] courant. Avec [semanticLabel], les lecteurs d'écran la
/// lisent ; sans, elle est décorative et exclue (COMPOSANTS §1).
class GameIcon extends StatelessWidget {
  const GameIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final GameIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final side = size ?? theme.size ?? 24;
    final paint = CustomPaint(
      size: Size.square(side),
      painter: _GameIconPainter(icon, color ?? theme.color!),
    );
    final label = semanticLabel;
    return label == null
        ? ExcludeSemantics(child: paint)
        : Semantics(label: label, image: true, child: paint);
  }
}

/// Tracés déjà convertis, par icône : la conversion n'a lieu qu'une fois.
final _paths = Expando<Path>();

Path _pathOf(GameIconData icon) => _paths[icon] ??= () {
  final path = Path();
  writeSvgPathDataToPath(icon.path, _PathAdapter(path));
  return path;
}();

final class _PathAdapter extends PathProxy {
  _PathAdapter(this._path);

  final Path _path;

  @override
  void close() => _path.close();
  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) => _path.cubicTo(x1, y1, x2, y2, x3, y3);
  @override
  void lineTo(double x, double y) => _path.lineTo(x, y);
  @override
  void moveTo(double x, double y) => _path.moveTo(x, y);
}

class _GameIconPainter extends CustomPainter {
  _GameIconPainter(this.icon, this.color);

  final GameIconData icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    canvas.drawPath(
      _pathOf(icon),
      Paint()
        ..color = color
        ..isAntiAlias = true
        ..style = icon.filled ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = icon.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_GameIconPainter old) =>
      old.icon != icon || old.color != color;
}
