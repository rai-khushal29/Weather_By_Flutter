import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Forecast_Model.dart';

class ios_ui extends StatefulWidget {
  String city_name = "cityname";
  String temp = "temp";
  String ico_url = "ico_url";
  String desc = "desc";
  String fl = 'fl';
  String temp_max = 'temp+max';
  String temp_min = 'temp_min';
  String pressure = 'pressure';
  String humidity = 'humidity';
  List<Forecast_Model> forecast_list;

  ios_ui(
      {Key? key,
      required this.city_name,
      required this.temp,
      required this.ico_url,
      required this.desc,
      required this.fl,
      required this.temp_max,
      required this.temp_min,
      required this.pressure,
      required this.humidity,
      required this.forecast_list})
      : super(key: key);

  @override
  State<ios_ui> createState() => _ios_uiState();
}

class _ios_uiState extends State<ios_ui> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),
            child: Image.network(
              (widget.city_name == "Jodhpur")
                  ? 'https://images.unsplash.com/photo-1569001852726-323fd51b26f3?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                  : (widget.city_name == "Jaipur")
                      ? 'https://images.unsplash.com/photo-1603262110263-fb0112e7cc33?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80'
                      : (widget.city_name == "Mumbai")
                          ? 'https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bXVtYmFpfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'
                          : (widget.city_name == "Jaisalmer")
                              ? 'https://images.unsplash.com/photo-1589510337472-4307ab0087f7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80'
                              : (widget.city_name == 'London')
                                  ? 'https://images.unsplash.com/photo-1486299267070-83823f5448dd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80'
                                  : 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fG5hdHVyZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: Stack(
                  children: [
                    Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Container(
                              width: 500,
                              height: 300,
                              child: Card(
                                color: (widget.city_name == "Jodhpur")
                                    ? Color(0x971A237E)
                                    : (widget.city_name == 'Jaipur')
                                        ? Color(0x71FF00AD)
                                        : (widget.city_name == "Jaisalmer")
                                            ? Color(0x71FFAD02)
                                            : Color(0x35FFFFFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(widget.city_name,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 35,
                                                  color: Colors.white))
                                        ]),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          widget.ico_url,
                                          alignment: Alignment.center,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(widget.temp,
                                            style: GoogleFonts.poppins(
                                                fontSize: 35,
                                                color: Colors.white))
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(widget.desc,
                                            style: GoogleFonts.poppins(
                                                fontSize: 35,
                                                color: Colors.white))
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(padding: EdgeInsets.all(15)),
                        Text(
                          "Description",
                          style: GoogleFonts.poppins(
                              fontSize: 30, color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Container(
                          width: 500,
                          height: 290,
                          child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: (widget.city_name == "Jodhpur")
                                  ? Color(0x971A237E)
                                  : (widget.city_name == 'Jaipur')
                                      ? Color(0x71FF00AD)
                                      : (widget.city_name == "Jaisalmer")
                                          ? Color(0x71FFAD02)
                                          : Color(0x35FFFFFF),
                              elevation: 10,
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        GridView(
                                            padding: EdgeInsets.all(5),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                              childAspectRatio: 5,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            children: [
                                              Text(
                                                'Feels Like',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                widget.fl,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                'Max Temperature',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                widget.temp_max,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                'Min Temperature',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                widget.temp_min,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                'Pressure',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                widget.pressure,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                'Humidity',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                widget.humidity,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                            ])
                                      ],
                                    ),
                                  ])),
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        Text(
                          "3 Hour Forecast",
                          style: GoogleFonts.poppins(
                              fontSize: 30, color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Container(
                            width: 500,
                            height: 250,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: (widget.city_name == "Jodhpur")
                                  ? Color(0x971A237E)
                                  : (widget.city_name == 'Jaipur')
                                      ? Color(0x71FF00AD)
                                      : (widget.city_name == "Jaisalmer")
                                          ? Color(0x71FFAD02)
                                          : Color(0x35FFFFFF),
                              elevation: 10,
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  String time = widget.forecast_list[index].time
                                      .toString();
                                  String icon = widget.forecast_list[index].icon
                                      .toString();
                                  String desc = widget
                                      .forecast_list[index].description
                                      .toString();
                                  return ListTile(
                                    leading: Text(
                                      time,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                    title: Text(desc,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white)),
                                    trailing: Image.network(icon),
                                  );
                                },
                                itemCount: widget.forecast_list.length,
                              ),
                            ))
                      ],
                    )),
                  ],
                )))
      ],
    );
  }
}
