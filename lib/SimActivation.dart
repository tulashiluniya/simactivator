import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'DropDown_Model.dart';

class SimActivation extends StatefulWidget {
  SimActivation({Key key}) : super(key: key);

  @override
  _SimActivationState createState() => _SimActivationState();
}

class _SimActivationState extends State<SimActivation> {
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
  var _currentSelectedDocType ;
  var _docTypeValue = "0";

  //List of Issue District

  var _currentSelectedIssueDistrict;

  //List of date types
  var _issueDateTypeList = ["Nepali-BS", "English-AD"];
  var _currentSelectedIssueDateType ;
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
    return Form(
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
                      _zone = newValueSelected;
                      tempDistrictList = districtList
                          .where(
                              (x) => x.zoneId.toString() == (_zone.toString()))
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 5, 50, 5),
                        child: Text(item.name),
                      ),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    setState(() {
                      this._district = newValueSelected;
                      tempPlaceList = placesList
                          .where((x) =>
                              x.districtId.toString() == (_district.toString()))
                          .toList();
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
                value: item.name,
                child: Text(item.name),
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
                      child: Text("Active Sim", style: TextStyle(fontSize: 20)),
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
                              "*"+_place,
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
    );
  }
}
// This function is for Next Focus

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
