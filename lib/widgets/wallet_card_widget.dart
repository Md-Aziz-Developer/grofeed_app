import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final String orderNumber;
  final String creditDate;
  final String collectedAmount;
  final String actualAmount;
  final String commissionAmount;
  final String withdrawalStatus;
  final bool isSelected;
  final Function(bool) onSelectCard;

  WalletCard({
    required this.orderNumber,
    required this.creditDate,
    required this.collectedAmount,
    required this.actualAmount,
    required this.commissionAmount,
    required this.withdrawalStatus,
    required this.isSelected,
    required this.onSelectCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectCard(!isSelected);
      },
      child: Card(
        color: withdrawalStatus == 'dispute'
            ? Colors.red.shade500
            : isSelected
                ? Colors.blue.shade200
                : Color.fromRGBO(57, 57, 58, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderNumber,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Date: ${creditDate}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.black : Colors.grey),
                  ),
                ],
              ),
              // Order Number
              SizedBox(
                height: 5,
              ),
              // Collected Amount and Actual Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Collected: $collectedAmount}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.black : Colors.white),
                  ),
                  Text(
                    'Actual: $actualAmount}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.teal),
                  ),
                ],
              ),

              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Commission Amount
                  // Text(
                  //   'Commission: ${commissionAmount}',
                  //   style: TextStyle(fontSize: 12, color: Colors.red[400]),
                  // ),
                  // Withdrawal Status
                  Text(
                    'Withdrawl Status : ${withdrawalStatus.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: withdrawalStatus == 'dispute'
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
