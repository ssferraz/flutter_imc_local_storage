import 'package:flutter/material.dart';
import 'package:flutter_imc_local_storage/src/core/controllers/imc_controller.dart';
import 'package:flutter_imc_local_storage/src/core/models/imc_sqlite_model.dart';
import 'package:flutter_imc_local_storage/src/core/repositories/imc_sqlite_repository.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = IMCSQLiteRepository();
  List<IMCSQLiteModel> imcs = [];
  final controller = IMCController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getImcs();
  }

  void getImcs() async {
    imcs = await repository.getIMCs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: imcs.isEmpty
              ? const Text(
                  "Nenhum IMC cadastrado",
                  style: TextStyle(fontSize: 16),
                )
              : ListView.builder(
                  itemCount: imcs.length,
                  itemBuilder: (context, index) {
                    double imc = controller.calcularIMC(imcs[index]);
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Peso: ${imcs[index].peso}",
                          ),
                          Text(
                            "Altura: ${imcs[index].altura}",
                          ),
                          Text("IMC: $imc"),
                        ],
                      ),
                      subtitle: Text(
                          "Classificação: ${controller.classificacao(imc)}"),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets +
                    const EdgeInsets.symmetric(vertical: 5),
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pesoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Peso', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _alturaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Altura', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final peso = double.tryParse(
                              _pesoController.text.replaceAll(',', '.'));
                          final altura = double.tryParse(
                              _alturaController.text.replaceAll(',', '.'));
                          if (peso != null && altura != null) {
                            await repository.save(
                                IMCSQLiteModel(peso: peso, altura: altura));
                            _pesoController.clear();
                            _alturaController.clear();
                            Navigator.of(context).pop();
                            setState(() {});
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.calculate_outlined),
      ),
    );
  }
}
