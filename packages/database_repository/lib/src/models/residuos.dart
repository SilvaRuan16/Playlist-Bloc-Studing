/// {@template residuos}
/// residuos model
///
/// [Residuos.empty] represents a new residuos.
/// {@endtemplate}
class Residuos {
  /// {@macro residuos}
  Residuos({
    required this.id,
    required this.name,
    this.size,
    this.solution,
    this.date
  });
  /// The current residuos id.
  late final String id;

  /// The current residuos name (display name).
  String name;

  // The current residuos size
  int? size;

  // The corrent residuos solution
  String? solution;

  // The current residuos date
  DateTime? date;

  // Empty residuos which represents a residuos.
  static Residuos get empty => Residuos(id: '', name: '');

  Residuos get clone => Residuos(
    id: this.id,
    name: this.name,
    size: this.size,
    solution: this.solution,
    date: this.date
  );

  // Convenience getter to determine whether the current residuos is empty.
  bool get isEmpty => this.id.isEmpty;

  bool get isValid => !this.name.isEmpty;
}