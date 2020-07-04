import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../DropDown_Model.dart';
import 'package:simactivator/planceList.dart';

class NcellSimActivation extends StatefulWidget {
  NcellSimActivation({Key key}) : super(key: key);

  @override
  _NcellSimActivationState createState() => _NcellSimActivationState();
}

class _NcellSimActivationState extends State<NcellSimActivation> {
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
//Parmanent Address Dropdown List
  List zoneList = List();
  List districtList = List();
  List placesList = List();
  List tempDistrictList = List();
  List tempPlaceList = List();

  String _zone;
  String _district;
  String _place;

  Future<String> loadStatesProvincesFromFile() async {
    return await rootBundle.loadString('json/address.json');
  }

  Future<String> _populateDropdown() async {
    String getPlaces = await loadStatesProvincesFromFile();
    final jsonResponse = json.decode(getPlaces);

    Localization places = new Localization.fromJson(jsonResponse);

    setState(() {
      zoneList = places.zone;
      districtList = places.district;
      placesList = places.places;
    });
  }

  //sms message and receiver number
  List<String> _phone = ["9988"];

  void _sendSMS(String _message, List<String> _phone) async {
    try {
      String _result = await sendSMS(message: _message, recipients: _phone);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  //controlles
  final numberControll = TextEditingController();
  final dateControll = TextEditingController();
  final docNumberControll = TextEditingController();
  //list of docs types
  var _docTypeList = ["Passport", "Citizenship", "License", "Voter ID"];
  var _currentSelectedDocType;
  var _docTypeValue = "0";

  //List of Issue District

  var _currentSelectedIssueDistrict;

  //List of date types
  var _issueDateTypeList = ["Nepali-BS", "English-AD"];
  var _currentSelectedIssueDateType;
  var _issueDateTypeValue = "N";

  //for changing focus
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    this._populateDropdown();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ncell Sim Activator'),
      ),
      body: Form(
        key: _formKeyValue,
        autovalidate: true,
        //List View Starts From Here
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          children: <Widget>[
            //Mobile Number Text Field
            TextFormField(
                controller: numberControll,
                decoration: InputDecoration(
                    labelText: "Mobile Number",
                    hintText: "Type Mobile Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(10),
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                focusNode: _numberFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _numberFocus, _dateFocus);
                }),
            SizedBox(
              height: 10.0,
            ),

            TextFormField(
              controller: docNumberControll,
              decoration: InputDecoration(
                  labelText: "Document Number",
                  hintText: "Type Document Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.next,
            ),

            SizedBox(
              height: 15.0,
            ),

            //Select Document Type Drop Down
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        labelText: "Document Type",
                        hintText: "Select",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    items: _docTypeList.map((String dropdownString) {
                      return DropdownMenuItem<String>(
                          value: dropdownString, child: Text(dropdownString));
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        switch (newValueSelected) {
                          case "Passport":
                            this._docTypeValue = "0";
                            break;

                          case "Citizenship":
                            this._docTypeValue = "1";
                            break;
                          case "License":
                            this._docTypeValue = "2";
                            break;
                          case "Voter ID":
                            this._docTypeValue = "12";
                            break;

                          default:
                        }

                        this._currentSelectedDocType = newValueSelected;
                      });
                    },
                    value: _currentSelectedDocType,
                  ),
                ),
                SizedBox(width: 5),

                // Document Issuing District  Drop Down
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        labelText: "Issue District ",
                        hintText: "Select",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    items: districtList.map((item) {
                      return DropdownMenuItem<String>(
                          value: item.name, child: Text(item.name));
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        this._currentSelectedIssueDistrict = newValueSelected;
                      });
                    },
                    value: _currentSelectedIssueDistrict,
                  ),
                ),
              ],
            ),

            //Document Number Text Field
            SizedBox(
              height: 10.0,
            ),

            SizedBox(height: 10.0),

            //  Date Type Drop Down
            Row(
              children: <Widget>[
                //Document Issue Date Text Field
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    controller: dateControll,
                    decoration: InputDecoration(
                        labelText: "Doc Issue Date",
                        hintText: "YYYYMMDD",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(8),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    focusNode: _dateFocus,
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        labelText: "Date Type",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    items: _issueDateTypeList.map((String dropdownIssueDate) {
                      return DropdownMenuItem<String>(
                          value: dropdownIssueDate,
                          child: Text(dropdownIssueDate));
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        switch (newValueSelected) {
                          case "Nepali-BS":
                            this._issueDateTypeValue = "N";

                            break;
                          case "English-AD":
                            this._issueDateTypeValue = "E";
                            break;
                          default:
                        }
                        this._currentSelectedIssueDateType = newValueSelected;
                      });
                    },
                    value: _currentSelectedIssueDateType,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10.0,
            ),
            Text("Parmanent Address"),
            SizedBox(
              height: 10.0,
            ),

            //Parmanent Address Drop down List

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        labelText: "Select Zone",
                        hintText: "-Select-",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    items: zoneList.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.name),
                        value: item.id.toString(),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        _district = null;
                        _place = null;

                        _zone = newValueSelected;
                        tempDistrictList = districtList
                            .where((x) =>
                                x.zoneId.toString() == (_zone.toString()))
                            .toList();
                      });
                    },
                    value: _zone,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        labelText: " Select District",
                        hintText: "-Select-",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    items: tempDistrictList.map((item) {
                      return DropdownMenuItem<String>(
                        value: item.id.toString(),
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        tempPlaceList = null;
                        _place = null;

                        this._district = newValueSelected;

                        switch (_district) {
                          case "1":
                            tempPlaceList = jhapa.toList();

                            break;
                          case "2":
                            tempPlaceList = ilam.toList();

                            break;
                          case "3":
                            tempPlaceList = panchthar.toList();
                            break;

                          case "4":
                            tempPlaceList = taplejung.toList();
                            break;

                          case "5":
                            tempPlaceList = bhojpur.toList();
                            break;

                          case "6":
                            tempPlaceList = dhankuta.toList();
                            break;
                          case "7":
                            tempPlaceList = morang.toList();
                            break;
                          case "8":
                            tempPlaceList = sankhuwasava.toList();
                            break;
                          case "9":
                            tempPlaceList = sunsari.toList();
                            break;
                          case "10":
                            tempPlaceList = terhathum.toList();
                            break;
                          case "11":
                            tempPlaceList = khotang.toList();
                            break;
                          case "12":
                            tempPlaceList = okhaldhunga.toList();
                            break;

                          case "13":
                            tempPlaceList = saptari.toList();
                            break;
                          case "14":
                            tempPlaceList = siraha.toList();
                            break;
                          case "15":
                            tempPlaceList = solukhumbu.toList();
                            break;
                          case "16":
                            tempPlaceList = udayapur.toList();
                            break;
                          case "17":
                            tempPlaceList = dhanusha.toList();
                            break;
                          case "18":
                            tempPlaceList = dolakha.toList();
                            break;
                          case "19":
                            tempPlaceList = mahottari.toList();
                            break;
                          case "20":
                            tempPlaceList = jhapa.toList();
                            break;
                          case "21":
                            tempPlaceList = ramechhap.toList();
                            break;
                          case "22":
                            tempPlaceList = sarlahi.toList();
                            break;
                          case "23":
                            tempPlaceList = bhaktapur.toList();
                            break;
                          case "24":
                            tempPlaceList = dhading.toList();
                            break;
                          case "25":
                            tempPlaceList = kathmandu.toList();
                            break;
                          case "26":
                            tempPlaceList = kavrepalanchowk.toList();
                            break;
                          case "27":
                            tempPlaceList = lalitpur.toList();
                            break;
                          case "28":
                            tempPlaceList = nuwakot.toList();
                            break;
                          case "29":
                            tempPlaceList = rasuwa.toList();
                            break;
                          case "30":
                            tempPlaceList = sindhupalchowk.toList();
                            break;
                          case "31":
                            tempPlaceList = bara.toList();
                            break;
                          case "32":
                            tempPlaceList = chitwan.toList();
                            break;
                          case "33":
                            tempPlaceList = makwanpur.toList();
                            break;
                          case "34":
                            tempPlaceList = parsa.toList();
                            break;
                          case "35":
                            tempPlaceList = rautahat.toList();
                            break;
                          case "36":
                            tempPlaceList = gorkha.toList();
                            break;
                          case "37":
                            tempPlaceList = kaski.toList();
                            break;
                          case "38":
                            tempPlaceList = lamjung.toList();
                            break;
                          case "39":
                            tempPlaceList = manang.toList();
                            break;
                          case "40":
                            tempPlaceList = syangja.toList();
                            break;
                          case "41":
                            tempPlaceList = tanahun.toList();
                            break;
                          case "42":
                            tempPlaceList = arghakhanchi.toList();
                            break;
                          case "43":
                            tempPlaceList = gulmi.toList();
                            break;
                          case "44":
                            tempPlaceList = kapilvastu.toList();
                            break;
                          case "45":
                            tempPlaceList = nawalparasi.toList();
                            break;
                          case "46":
                            tempPlaceList = palpa.toList();
                            break;
                          case "47":
                            tempPlaceList = rupandehi.toList();
                            break;
                          case "48":
                            tempPlaceList = baglung.toList();
                            break;
                          case "49":
                            tempPlaceList = mustang.toList();
                            break;
                          case "50":
                            tempPlaceList = myagdi.toList();
                            break;
                          case "51":
                            tempPlaceList = parbat.toList();
                            break;
                          case "52":
                            tempPlaceList = dang.toList();
                            break;
                          case "53":
                            tempPlaceList = pyuthan.toList();
                            break;
                          case "54":
                            tempPlaceList = rolpa.toList();
                            break;
                          case "55":
                            tempPlaceList = rukum.toList();
                            break;
                          case "56":
                            tempPlaceList = salyan.toList();
                            break;
                          case "57":
                            tempPlaceList = dolpa.toList();
                            break;
                          case "58":
                            tempPlaceList = humla.toList();
                            break;
                          case "59":
                            tempPlaceList = jumla.toList();
                            break;
                          case "60":
                            tempPlaceList = kalikot.toList();
                            break;
                          case "61":
                            tempPlaceList = mugu.toList();
                            break;
                          case "62":
                            tempPlaceList = banke.toList();
                            break;
                          case "63":
                            tempPlaceList = bardiya.toList();
                            break;
                          case "64":
                            tempPlaceList = dailekh.toList();
                            break;
                          case "65":
                            tempPlaceList = jajarkot.toList();
                            break;
                          case "66":
                            tempPlaceList = surkhet.toList();
                            break;
                          case "67":
                            tempPlaceList = achham.toList();
                            break;
                          case "68":
                            tempPlaceList = bajhang.toList();
                            break;
                          case "69":
                            tempPlaceList = bajura.toList();
                            break;
                          case "70":
                            tempPlaceList = doti.toList();
                            break;
                          case "71":
                            tempPlaceList = kailali.toList();
                            break;
                          case "72":
                            tempPlaceList = baitadi.toList();
                            break;
                          case "73":
                            tempPlaceList = dadeldhura.toList();
                            break;
                          case "74":
                            tempPlaceList = darchula.toList();
                            break;
                          case "75":
                            tempPlaceList = kanchanpur.toList();
                            break;

                          default:
                        }
                      });
                    },
                    value: _district,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                  labelText: "Select Place",
                  hintText: "-Select-",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              items: tempPlaceList.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String newValueSelected) {
                setState(() {
                  this._place = newValueSelected;
                });
              },
              value: _place,
            ),
            SizedBox(
              height: 15.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 150.0,
                  child: RaisedButton(
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      color: Color(0XFF6a1b9a),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(),
                        child:
                            Text("Active Sim", style: TextStyle(fontSize: 20)),
                      ),
                      onPressed: () {
                        _sendSMS(
                            numberControll.text +
                                "*" +
                                _docTypeValue +
                                "*" +
                                docNumberControll.text +
                                "*" +
                                _currentSelectedIssueDistrict +
                                "*" +
                                dateControll.text +
                                "*" +
                                _issueDateTypeValue +
                                "*" +
                                _place,
                            _phone);
                      }),
                ),
                SizedBox(
                  width: 150.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    color: Color(0XFF6a1b9a),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Text("Clear", style: TextStyle(fontSize: 20)),
                    ),
                    onPressed: () {
                      setState(() {
                        numberControll.clear();
                        dateControll.clear();
                        docNumberControll.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// This function is for Next Focus

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
