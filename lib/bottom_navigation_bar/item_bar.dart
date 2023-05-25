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

class ItemBar extends StatefulWidget {
  const ItemBar({Key? key}) : super(key: key);

  @override
  _ItemBarState createState() => _ItemBarState();
}

class _ItemBarState extends State<ItemBar> {
  final itemController = TextEditingController();
  late List<Employee> employees;
  late EmployeeDataSource employeeDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    employees = [];
    employeeDataSource = EmployeeDataSource(employeeData: employees);
    getDataFromDatabase("");
  }

  void signUserOut() {
    FirebaseDatabase.instance.ref().child("users").push().set({
      "name": "Fedeeeeee",
      "age": 1
    });
    log('SONO DENTROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
  }

  void cercaDb() {
    String cerca = itemController.text;
    setState(() {
      isLoading = true;
      employees.clear();
    });
    getDataFromDatabase(cerca);
  }

  Future<void> getDataFromDatabase(String cerca) async {
    var value = FirebaseDatabase.instance.ref();
    var getValue = await value.child('barcode/employee').once();
    dynamic showData = getValue.snapshot.value;
    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      employees = keyList.map<Employee>((key) {
        final data = dataMap[key];
        return Employee(
          id: data['id'],
          name: data['name'],
          designation: data['designation'],
          salary: data['salary'],
        );
      }).toList();

      employeeDataSource = EmployeeDataSource(employeeData: employees);

      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Vicini'),
      ),
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
                onPressed: cercaDb,
                child: const Text('Cerca'),
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator()
              else
                Expanded(
                  child: SfDataGrid(
                    source: employeeDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'id',
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
                        columnName: 'designation',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Designation',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'salary',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Salary'),
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
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(
          columnName: 'designation', value: e.designation),
      DataGridCell<int>(columnName: 'salary', value: e.salary),
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

class Employee {
  final int id;
  final String name;
  final String designation;
  final int salary;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.salary,
  });
}
