import 'package:flutter/material.dart';

/*Padding parameter(String asset, String headText, List<String> text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 63, 63, 63),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        child: Row(
          children: [

            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              height: 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              child: Row(
                children: [
                  Image.asset(asset, height: 96, width: 96),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(headText, style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Monda-Bold",
                    )),
                    
                    for (String i in text) 
                      Text(i, style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda",
                      )),
                    
                  ]),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 159, 145, 110),
                          title: const Text(
                            "Enter your name", 
                            style: TextStyle(
                              fontFamily: "Monda-Bold",
                              fontSize: 16
                            )),
                          content: TextFormField(
                            autofocus: false,
                            textInputAction: TextInputAction.done,

                            keyboardType: TextInputType.text,
                            
                            autocorrect: true,
                            enableSuggestions: true,

                            cursorRadius: const Radius.circular(10.0),
                            cursorColor: const Color.fromARGB(255, 63, 63, 63),

                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Color.fromARGB(255, 63, 63, 63), width: 2.0),
                              ),
                              
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Color.fromARGB(255, 63, 63, 63), width: 2.0),
                              ),
                            ),
                            
                            onChanged: (String value) { 
                              settings["player_name"] = value;
                            }

                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel", style: TextStyle(color: Color.fromARGB(255, 63, 63, 63), fontFamily: "Monda-Regular", fontSize: 16)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            TextButton(
                              child: const Text("Save", style: TextStyle(color: Color.fromARGB(255, 63, 63, 63), fontFamily: "Monda-Regular", fontSize: 16)),
                              onPressed: () {
                                saveSettings(settings["player_name"]!);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }, 
                  icon: Image.asset("assets/edit_icon.png", height: 22)
                ),
              ]
            ),
            
          ]
        )
      )
    );
  }*/