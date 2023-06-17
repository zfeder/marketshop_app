import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../prodotto.dart';
import '../components_login/my_buttonAddCode.dart';
import '../components_login/my_buttonReg.dart';
import '../components_login/my_textfield.dart';
import '../firebase_options.dart';
import 'dart:developer';
import 'package:marketshop_app/bottom_navigation_bar/home_bar.dart';

import '../registration_page.dart';


class ItemBar extends StatefulWidget {
  const ItemBar(String data, {Key? key}) : super(key: key);

  get data => null;

  @override
  _ItemBarState createState() => _ItemBarState();
}

class _ItemBarState extends State<ItemBar> {
  final itemController = TextEditingController();
  late List<Prodotto> prodotto;
  late EmployeeDataSource employeeDataSource;
  bool isLoading = true;
  String data = '';

  void signUserOut() {
    FirebaseDatabase.instance.ref().child("users").push().set({
      "name": "Fedeeeeee",
      "age": 1
    });
  }

  Future<void> getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref();
    String barcode = 'barcode/';
    String a = barcode + itemController.text;
    var getValue = await value.child(a).once();
    dynamic showData = getValue.snapshot.value;
    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.map<Prodotto>((key) {
        final data = dataMap[key];
        return Prodotto(
          Barcode: data['barcode'],
          Nome: data['nome'],
          Peso: data['peso'],
          Valutazione: data['valutazione'],
        );
      }).toList();

      employeeDataSource = EmployeeDataSource(employeeData: prodotto);

      setState(() {
        isLoading = false;
      });
    }
  }

  void scannerOn() async {
    final ItemBar args = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeBar(),
      ),
    );
    log("args ${args.data}");
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                MyTextField(
                    controller: itemController,
                    hintText: 'Cerca per nome',
                    obscureText: false,
                  ),
                    ElevatedButton(
                      onPressed: getDataFromDatabase,
                      child: const Text('Cerca'),
                    ),
                    ElevatedButton(
                      onPressed: scannerOn,
                      child: const Text('Scansiona BARCODE'),
                    ),
              const SizedBox(height: 20),
              if (isLoading)
                const Expanded(child:  Text(''))
              else
                Expanded(
                  child: SfDataGrid(
                    source: employeeDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'Barcode',
                        label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: const Text('ID'),
                        ),
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Name'),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Peso',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Peso',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Valutazione',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Valutazione'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Prodotto> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'Barcode', value: e.Barcode),
      DataGridCell<String>(columnName: 'Nome', value: e.Nome),
      DataGridCell<String>(
          columnName: 'Peso', value: e.Peso),
      DataGridCell<int>(columnName: 'Valutazione', value: e.Valutazione),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}

class Prodotto {
  final int Barcode;
  final String Nome;
  final String Peso;
  final int Valutazione;

  Prodotto({
    required this.Barcode,
    required this.Nome,
    required this.Peso,
    required this.Valutazione,
  });
}
