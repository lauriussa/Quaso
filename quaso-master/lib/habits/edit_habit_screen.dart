import 'package:flutter/material.dart';
import 'package:quaso/constants.dart';
import 'package:quaso/habits/habits_manager.dart';
import 'package:quaso/model/habit_data.dart';
import 'package:quaso/navigation/routes.dart';
import 'package:quaso/notifications.dart';
import 'package:quaso/widgets/text_container.dart';
import 'package:provider/provider.dart';

class EditHabitScreen extends StatefulWidget {
  static MaterialPage page(HabitData? data) {
    return MaterialPage(
      name: (data != null) ? Routes.editHabitPath : Routes.createHabitPath,
      key: (data != null)
          ? ValueKey(Routes.editHabitPath)
          : ValueKey(Routes.createHabitPath),
      child: EditHabitScreen(habitData: data),
    );
  }

  const EditHabitScreen({Key? key, required this.habitData}) : super(key: key);

  final HabitData? habitData;

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController cue = TextEditingController();
  TextEditingController routine = TextEditingController();
  TextEditingController reward = TextEditingController();
  TimeOfDay notTime = const TimeOfDay(hour: 12, minute: 0);
  bool twoDayRule = false;
  bool showReward = false;
  bool advanced = false;
  bool notification = false;

  Future<void> setNotificationTime(context) async {
    TimeOfDay? selectedTime;
    TimeOfDay initialTime = notTime;
    selectedTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (selectedTime != null) {
      setState(() {
        notTime = selectedTime!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.habitData != null) {
      title.text = widget.habitData!.title;
      cue.text = widget.habitData!.cue;
      routine.text = widget.habitData!.routine;
      reward.text = widget.habitData!.reward;
      twoDayRule = widget.habitData!.twoDayRule;
      showReward = widget.habitData!.showReward;
      advanced = widget.habitData!.advanced;
      notification = widget.habitData!.notification;
      notTime = widget.habitData!.notTime;
    }
  }

  @override
  void dispose() {
    title.dispose();
    cue.dispose();
    routine.dispose();
    reward.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.habitData != null) ? 'Editar Hábito' : 'Criar Hábito',
        ),
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          if (widget.habitData != null)
            IconButton(
              icon: const Icon(
                Icons.delete,
                semanticLabel: 'Excluir',
              ),
              color: QuasoColors.red,
              tooltip: 'Excluir',
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.habitData != null) {
                  Provider.of<HabitsManager>(context, listen: false)
                      .deleteHabit(widget.habitData!.id!);
                }
              },
            ),
        ],
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            if (title.text.isNotEmpty) {
              if (widget.habitData != null) {
                Provider.of<HabitsManager>(context, listen: false).editHabit(
                  HabitData(
                    id: widget.habitData!.id,
                    title: title.text.toString(),
                    twoDayRule: twoDayRule,
                    cue: cue.text.toString(),
                    routine: routine.text.toString(),
                    reward: reward.text.toString(),
                    showReward: showReward,
                    advanced: advanced,
                    notification: notification,
                    notTime: notTime,
                    position: widget.habitData!.position,
                    events: widget.habitData!.events,
                  ),
                );
              } else {
                Provider.of<HabitsManager>(context, listen: false).addHabit(
                  title.text.toString(),
                  twoDayRule,
                  cue.text.toString(),
                  routine.text.toString(),
                  reward.text.toString(),
                  showReward,
                  advanced,
                  notification,
                  notTime,
                );
              }
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  behavior: SnackBarBehavior.floating,
                  content: const Text("O título do hábito não pode estar vazio"),
                ),
              );
            }
          },
          child: const Icon(
            Icons.check,
            semanticLabel: 'Salvar',
            color: Colors.white,
            size: 35.0,
          ),
        );
      }),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                TextContainer(
                  title: title,
                  hint: 'Exercitar',
                  label: 'Hábito',
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        onChanged: (bool? value) {
                          setState(() {
                            twoDayRule = value!;
                          });
                        },
                        value: twoDayRule,
                      ),
                      const Text("Usar a Regra de Dois Dias"),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Tooltip(
                          message:
                              "Com a regra de dois dias, você pode perder um dia e não perder uma sequência se o dia seguinte for bem-sucedido.",
                          child: Icon(
                            Icons.info,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(
                      "Construção de Hábitos Avançada",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  initiallyExpanded: advanced,
                  onExpansionChanged: (bool value) {
                    advanced = value;
                  },
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Center(
                        child: Text(
                          "Esta seção ajuda você a definir melhor seus hábitos. Você deve definir deixa, rotina e recompensa para cada hábito.",
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    TextContainer(
                      title: cue,
                      hint: 'Às 07:00 horas',
                      label: 'Deixa',
                    ),
                    if (platformSupportsNotifications())
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        title: const Text("Notificações"),
                        trailing: Switch(
                            value: notification,
                            onChanged: (value) {
                              notification = value;
                              setState(() {});
                            }),
                      ),
                    if (platformSupportsNotifications())
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        enabled: notification,
                        title: const Text("Horário da Notificação"),
                        trailing: InkWell(
                          onTap: () {
                            if (notification) {
                              setNotificationTime(context);
                            }
                          },
                          child: Text(
                            "${notTime.hour.toString().padLeft(2, '0')}:${notTime.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                                color: (notification)
                                    ? null
                                    : Theme.of(context).disabledColor),
                          ),
                        ),
                      ),
                    TextContainer(
                      title: routine,
                      hint: 'Fazer 50 flexões',
                      label: 'Rotina',
                    ),
                    TextContainer(
                      title: reward,
                      hint: '15 minutos de videogame',
                      label: 'Recompensa',
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            onChanged: (bool? value) {
                              setState(() {
                                showReward = value!;
                              });
                            },
                            value: showReward,
                          ),
                          const Text("Mostrar recompensa"),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Tooltip(
                              message:
                                  "O restante da recompensa após uma rotina bem-sucedida.",
                              child: Icon(
                                Icons.info,
                                semanticLabel: 'Dica',
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 110,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
