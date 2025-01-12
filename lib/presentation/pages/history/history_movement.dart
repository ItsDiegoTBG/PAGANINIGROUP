import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/models/transaction_model.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/list_title_transaction.dart';

class HistoryMovement extends StatefulWidget {
  const HistoryMovement({super.key});

  @override
  State<HistoryMovement> createState() => _HistoryMovementState();
}

class _HistoryMovementState extends State<HistoryMovement> {
  bool showAllMovements = false; // Estado para controlar la expansión.
  List<TransactionModel> movements = [
    TransactionModel(
        name: 'Grocery Shopping',
        originator: 'Walmart',
        amount: -50.75,
        date: '13/12/2022',
        paymentMethods: [
          'Saldo: \$10',
          'Tarjeta Mastercard: \$40.75',
        ]),
    TransactionModel(
        name: 'Utility Payment',
        originator: 'Electric Company',
        amount: -30.00,
        date: '15/12/2022',
        paymentMethods: [
          'Saldo: \$15',
          'Tarjeta de mama: \$15',
        ]),
    TransactionModel(
        name: 'Received Transfer',
        originator: 'John Doe',
        amount: 100.00,
        date: '14/12/2022',
      ),
    TransactionModel(
        name: 'Balance Top-Up',
        originator: 'XYZ Bank',
        amount: 20.00,
        date: '12/12/2022',
        ),
    TransactionModel(
        name: 'Restaurant Payment',
        originator: 'McDonald\'s',
        amount: -15.50,
        date: '16/12/2022',
        paymentMethods: [
          
          'Tarjeta Mastercard: \$15.50',
        ]),
    TransactionModel(
        name: 'Monthly Subscription',
        originator: 'Netflix',
        amount: -10.00,
        date: '10/12/2022',
        paymentMethods: [
          'Saldo: \$5',
          'Tarjeta de papa: \$5',
        ]),
    TransactionModel(
        name: 'Movie Tickets',
        originator: 'Cinema World',
        amount: -25.00,
        date: '11/12/2022',
        paymentMethods: [
          'Saldo: \$10',
          'Tarjeta de mama: \$7.50',
          'Tarjeta de papa: \$7.50',
        ]),
    TransactionModel(
        name: 'Book Purchase',
        originator: 'Amazon',
        amount: -35.99,
        date: '18/12/2022',
        paymentMethods: [
          'Saldo: \$35.99',
          
        ]),
    TransactionModel(
        name: 'Received Bonus',
        originator: 'Employer',
        amount: 500.00,
        date: '20/12/2022',
        ),
    TransactionModel(
        name: 'Online Course',
        originator: 'Udemy',
        amount: -19.99,
        date: '22/12/2022',
        paymentMethods: [
          
          'Mi tarjeta: \$19.99',
        ]),
  ];

  List<TransactionModel> filteredMovements = []; // Lista filtrada.
  String searchQuery = ""; // Consulta de búsqueda.

  @override
  void initState() {
    super.initState();
    filteredMovements = movements; // Inicializa con todos los movimientos.
  }

  void _filterMovements(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredMovements = movements;
      } else {
        filteredMovements = movements
            .where((movement) =>
                movement.originator.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, title: const ContentAppBar()),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 22, right: 8, bottom: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Últimos Movimientos",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar movimientos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                onChanged: _filterMovements, // Filtrar al escribir.
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 22, top: 10, bottom: 10),
                  child: Text(
                    "Movimientos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredMovements.length,
                itemBuilder: (context, index) {
                  final TransactionModel transaction = filteredMovements[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTitleTransaction(
                      transaction: transaction,
                      withDescription: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
