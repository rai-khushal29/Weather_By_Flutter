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
  ios_ui({Key? key,
    required this.city_name,
    required this.temp,
    required this.ico_url,
    required this.desc,
    required this.fl,
    required this.temp_max,
    required this.temp_min,
    required this.pressure,
    required this.humidity,
    required this.forecast_list}) : super(key: key);

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
    return  Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(

          child: ImageFiltered(

            imageFilter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Image.network(
              (widget.city_name == "Jodhpur")
                  ? 'https://www.wtravelmagazine.com/wp-content/uploads/2018/12/23.28.2-Traditional-blue-windows-and-wall-in-Blue-City-Jodhpur.jpg'
                  : ('widget.city_name' == "Jaipur")
                  ? 'assets/images/jaipur_day.png'
                  : "",
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
                                    color: Color(0x971A237E),
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
                                  color: Color(0x6639D2C0),
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
                             Container(
                                    width: 500,
                                    height: 290,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Color(0x6639D2C0),
                                      elevation: 10,
                                      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                                        //String time = widget.forecast_list[index].time.toString();
                                        //String icon = widget.forecast_list[index].icon.toString();
                                        //String desc = widget.forecast_list[index].description.toString();
                                        return ListTile(
                                          leading: Text(
                                              'time'
                                          ),
                                          title: Text('desc'),
                                          trailing: Image.network('icon'),
                                        );
                                      },itemCount: widget.forecast_list.length,),
                                    ))
                          ],
                        )),
                  ],
                )))
      ],
    );
  }
}
