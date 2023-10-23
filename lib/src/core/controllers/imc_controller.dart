import 'package:flutter_imc_local_storage/src/core/models/imc_sqlite_model.dart';

class IMCController {
  double calcularIMC(IMCSQLiteModel imc) {
    if (imc.altura > 0 && imc.peso > 0) {
      return double.parse(
        (imc.peso / (imc.altura * imc.altura)).toStringAsFixed(1),
      );
    } else {
      return 0.0;
    }
  }

  String classificacao(double imc) {
    var classificacao = "";

    if (imc == 0) {
      return "IMC incorreto";
    }

    if (imc < 16) {
      classificacao = "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      classificacao = "Magreza moderada";
    } else if (imc >= 17 && imc < 18.5) {
      classificacao = "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      classificacao = "Saudável";
    } else if (imc >= 25 && imc < 30) {
      classificacao = "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      classificacao = "Obesidade Grau I";
    } else if (imc >= 35 && imc < 40) {
      classificacao = "Obesidade Grau II (severa)";
    } else {
      classificacao = "Obesidade Grau III (mórbida)";
    }

    return classificacao;
  }
}
