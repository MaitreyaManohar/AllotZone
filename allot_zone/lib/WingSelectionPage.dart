import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WingSelectionPage extends StatelessWidget {
  const WingSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AllotZone',
        ),
      ),
      body: InteractiveViewer(

        child: Column(
          children: [
            GestureDetector(
              onTap: (){},
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 5, color: Theme.of(context).primaryColorLight),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 5, color: Theme.of(context).primaryColorLight),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
