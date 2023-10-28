class ExchangeRate {
  final int year;
  final double rate;

  ExchangeRate(this.year, this.rate);

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'rate': rate,
    };
  }

  factory ExchangeRate.fromMap(Map<String, dynamic> map) {
    return ExchangeRate(
      map['year'],
      map['rate'],
    );
  }
}
