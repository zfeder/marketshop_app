
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
  const ItemBar({super.key});
  @override
  State<ItemBar> createState() => _ItemBar();
}

final itemController = TextEditingController();

void signUserOut() {
  FirebaseDatabase.instance.reference().child("users").push().set({
    "name": "John Smith",
    "age": 30
  });
  log('SONO DENTROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
}

void cercaDb() {
  cerca: itemController.text;
  getDataFromDatabase();
}

List<Employee> getEmployeeData() {
  List<Employee> employees = <Employee>[];
  future: getDataFromDatabase();
  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      var showData = snapshot.data;
      Map<dynamic, dynamic> values = showData.value;
      List<dynamic> key = values.keys.toList();

      for (int i = 0; i < key.length; i++) {
        final data = values[key[i]];
        employees.add(Employee(id: data['id'], name: data['name'], designation: data['designation'],
            salary: data['salary']));
      }
    }
  };
  return employees;
}

getDataFromDatabase() async {
  var value = FirebaseDatabase.instance.reference();
  var getValue = await value.child('barcode/employee').once();
  return getValue;
}



class _ItemBar extends State<ItemBar> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
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
              const ElevatedButton(
                onPressed: getEmployeeData,
                  child: Text('Cerca')
              ),
              SfDataGrid(
                source: employeeDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'id',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'ID',
                          ))),
                  GridColumn(
                      columnName: 'name',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Name'))),
                  GridColumn(
                      columnName: 'designation',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Designation',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'salary',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Salary'))),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

}


class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
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
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}


class Employee {
  final int id;
  final String name;
  final String designation;
  final int salary;

  Employee(
      {required this.id,
        required this.name,
        required this.designation,
        required this.salary});
}