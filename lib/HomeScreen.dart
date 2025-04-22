//import 'package:apka2/modules/Mdl_Alerts.dart';
import 'package:flutter/material.dart';
import 'Libraries/functions.dart';
import 'Mdl_AlertGetter.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedValue;

    return Scaffold(
      body: Stack(
        children: [
          // Pozadie s obrázkom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/main.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  // Horná časť s textom
                  Padding(
                    padding: EdgeInsets.only(top: 95),
                    child: Text(
                      daysSince(),
                      style: TextStyle(
                        fontSize: 80,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),

                  Spacer(),
                  Spacer(),
                  Text(
                    "ppuuff",
                    style: TextStyle(
                        fontSize: 40,
                        color: const Color.fromRGBO(50, 222, 235, 1)),
                  ),
                  Spacer(),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          MetGetStart(context, pickedTime);
                          print(
                              "Nastavený začiatok pôstu: ${pickedTime.format(context)}");
                        }
                      },
                      child: Text('Start time'),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Vyberte možnosť'),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return DropdownButton<String>(
                                    hint: Text('Vyberte možnosť'),
                                    value: selectedValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                    items: <String>['16:8', '18:6', '20:4']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    if (selectedValue != null) {
                                      MtdGetInput(context, selectedValue!);
                                      print(
                                          "Nastavený typ pôstu: $selectedValue");
                                    }
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(' 🔔 Tvoj nastavený čas'),
                                          content: Text(vypis3),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Zatvorí toto okno
                                              },
                                              child: Text('Zatvoriť'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Zatvoriť'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Fasting type"),
                    ),
                  ),
                  Spacer(),
                  Spacer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
