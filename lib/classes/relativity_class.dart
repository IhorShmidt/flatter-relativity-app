class Relativity {
  double n1;
  double n2;
  double n3;
  double n4;

  Relativity() {
    reset();
  }

  void set1tNumber(double val) {
    n1 = val;
  }

  void set2tNumber(double val) {
    n2 = val;
  }

  void set3tNumber(double val) {
    n3 = val;
  }

  void set4tNumber(double val) {
    n4 = val;
  }

  reset() {
    n1 = 0;
    n2 = 0;
    n3 = 0;
    n4 = 0;
//    print('reset');
  }

  get conditions {
    return [n1 == 0, n2 == 0, n3 == 0, n4 == 0];
  }

  get formulas {
    return [(n3 * n2) / n4, (n1 * n4) / n3, (n1 * n4) / n2, (n3 * n2) / n1];
  }

  getResult() {
    var res = 0.0;
    conditions
        .asMap()
        .forEach((index, value) => value ? res = formulas[index] : null);

    return res;
  }

//  void onReset(Null Function() param0) {
//    reset();
//  }
}
