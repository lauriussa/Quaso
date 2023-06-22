import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStatisticsImage extends StatelessWidget {
  const EmptyStatisticsImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: SvgPicture.asset('assets/images/noDataStatistics.svg',
                  semanticsLabel: 'Lista vazia'),
            ),
            const Text(
              "Não há nenhum dado disponível sobre hábitos",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
