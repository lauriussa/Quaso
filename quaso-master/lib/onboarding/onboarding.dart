import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quaso/constants.dart';
import 'package:quaso/settings/settings_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      titleWidget: const Text(
        'Defina seus hábitos',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      image: SvgPicture.asset(
        'assets/images/onboard/1.svg',
        semanticsLabel: 'Lista Vazia',
        width: 250,
      ),
      bodyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Para acompanhar melhor os seus hábitos, você pode definir:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '1. Deixa',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '2. Rotina',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3. Recompensa',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      titleWidget: const Text(
        'Registre os seus dias',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      image: SvgPicture.asset(
        'assets/images/onboard/2.svg',
        semanticsLabel: 'Lista vazia',
        width: 250,
      ),
      bodyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check,
                    color: QuasoColors.primary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sucesso',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.close,
                    color: QuasoColors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sem sucesso',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.last_page,
                    color: QuasoColors.skip,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Pular (não afeta suas sequências)',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: QuasoColors.orange,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Comentário',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Observe seu progresso",
      image: SvgPicture.asset(
        'assets/images/onboard/3.svg',
        semanticsLabel: 'Lista vazia',
        width: 250,
      ),
      bodyWidget: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Você pode acompanhar seu progresso por meio da visualização do calendário em cada hábito ou na página de estatísticas',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Feito", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        if (Provider.of<SettingsManager>(context, listen: false)
            .getSeenOnboarding) {
          Navigator.pop(context);
        } else {
          Provider.of<SettingsManager>(context, listen: false)
              .setSeenOnboarding = true;
        }
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text("Pular"),
    );
  }
}
