class Telefon {
  int id;
  String producent;
  String model;
  String wersjaAndroida;
  String stronaWww;

  Telefon(
      this.id, this.producent, this.model, this.wersjaAndroida, this.stronaWww);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producent': producent,
      'model': model,
      'wersjaAndroida': wersjaAndroida,
      'stronaWww': stronaWww,
    };
  }

  @override
  String toString() {
    return 'Telefon{id: $id, producent: $producent, model: $model, wersjaAndroida: $wersjaAndroida, stronaWww: $stronaWww}';
  }
}
