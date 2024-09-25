import 'package:flutter/material.dart';

class OrderCardWidget extends StatelessWidget {
  final String orderNumber;
  final String userName;
  final String orderDate;
  final String orderStatus;
  final String contentType;
  final String contentTitle;
  final String orderAmount;
  final String paymentId;
  const OrderCardWidget(
      {super.key,
      required this.orderNumber,
      required this.userName,
      required this.orderDate,
      required this.orderStatus,
      required this.contentType,
      required this.contentTitle,
      required this.orderAmount,
      required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(232, 99, 153, 1),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: orderStatus == 'success' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    orderStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // User Information
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Order Date
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Order Date: $orderDate',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Content Type
            Row(
              children: [
                const Icon(Icons.lock, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Title: $contentTitle',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Order Amount
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Amount: ' + orderAmount,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Payment ID
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Payment ID: $paymentId',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
