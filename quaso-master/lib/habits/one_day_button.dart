import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quaso/constants.dart';
import 'package:quaso/habits/habit.dart';
import 'package:quaso/habits/habits_manager.dart';
import 'package:quaso/habits/in_button.dart';
import 'package:quaso/helpers.dart';
import 'package:quaso/settings/settings_manager.dart';
import 'package:provider/provider.dart';

class OneDayButton extends StatelessWidget {
  OneDayButton(
      {Key? key,
      required date,
      this.color,
      this.child,
      required this.id,
      required this.parent,
      required this.callback,
      required this.event})
      : date = transformDate(date),
        super(key: key);

  final int id;
  final DateTime date;
  final Color? color;
  final Widget? child;
  final HabitState parent;
  final void Function() callback;
  final List? event;

  @override
  Widget build(BuildContext context) {
    List<InButton> icons = [
      InButton(
        key: const Key('Data'),
        text: child ??
            Text(
              date.day.toString(),
              style:
                  TextStyle(color: (date.weekday > 5) ? Colors.red[300] : null),
              textAlign: TextAlign.center,
            ),
      ),
      InButton(
        key: const Key('Feito'),
        icon: Icon(
          Icons.check,
          color:
              Provider.of<SettingsManager>(context, listen: false).checkColor,
          semanticLabel: 'Feito',
        ),
      ),
      InButton(
        key: const Key('Não feito'),
        icon: Icon(
          Icons.close,
          color: Provider.of<SettingsManager>(context, listen: false).failColor,
          semanticLabel: 'Não feito',
        ),
      ),
      InButton(
        key: const Key('Pular'),
        icon: Icon(
          Icons.last_page,
          color: Provider.of<SettingsManager>(context, listen: false).skipColor,
          semanticLabel: 'Pular',
        ),
      ),
      const InButton(
        key: Key('Comentar'),
        icon: Icon(
          Icons.chat_bubble_outline,
          semanticLabel: 'Comentar',
          color: QuasoColors.orange,
        ),
      )
    ];

    int index = 0;
    String comment = "";

    if (event != null) {
      if (event![0] != 0) {
        index = (event![0].index);
      }

      if (event!.length > 1 && event![1] != null && event![1] != "") {
        comment = (event![1]);
      }
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(4.0),
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 2,
            shadowColor: Theme.of(context).shadowColor,
            child: Container(
              alignment: Alignment.center,
              child: DropdownButton<InButton>(
                iconSize: 0,
                elevation: 3,
                alignment: Alignment.center,
                dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                underline: Container(),
                items: icons.map(
                  (InButton value) {
                    return DropdownMenuItem<InButton>(
                      key: value.key,
                      value: value,
                      child: Center(child: value),
                    );
                  },
                ).toList(),
                value: icons[index],
                onTap: () {
                  parent.setSelectedDay(date);
                },
                onChanged: (value) {
                  if (value != null) {
                    if (value.key == const Key('Feito') ||
                        value.key == const Key('Não feito') ||
                        value.key == const Key('Pular')) {
                      Provider.of<HabitsManager>(context, listen: false)
                          .addEvent(id, date, [
                        DayType.values[icons
                            .indexWhere((element) => element.key == value.key)],
                        comment
                      ]);
                      parent.events[date] = [
                        DayType.values[icons
                            .indexWhere((element) => element.key == value.key)],
                        comment
                      ];
                      if (value.key == const Key('Feito')) {
                        parent.showRewardNotification(date);
                      }
                    } else if (value.key == const Key('Comentar')) {
                      showCommentDialog(context, index, comment);
                    } else {
                      if (comment != "") {
                        Provider.of<HabitsManager>(context, listen: false)
                            .addEvent(id, date, [DayType.clear, comment]);
                        parent.events[date] = [DayType.clear, comment];
                      } else {
                        Provider.of<HabitsManager>(context, listen: false)
                            .deleteEvent(id, date);
                        parent.events.remove(date);
                      }
                    }
                    callback();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  showCommentDialog(BuildContext context, int index, String comment) {
    TextEditingController commentController =
        TextEditingController(text: comment);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              const Text("Comentar"),
              TextField(
                controller: commentController,
                autofocus: true,
                maxLines: 5,
                showCursor: true,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(11),
                  border: InputBorder.none,
                  hintText: "O seu comentário aqui",
                ),
              ),
            ],
          ),
        ),
      ),
      btnOkText: "Salvar",
      btnCancelText: "Fechar",
      btnCancelColor: Colors.grey,
      btnOkColor: QuasoColors.primary,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Provider.of<HabitsManager>(context, listen: false).addEvent(
            id, date, [DayType.values[index], commentController.text]);
        parent.events[date] = [DayType.values[index], commentController.text];
        callback();
      },
    ).show();
  }
}
