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

  List zoneList = List();
  List districtList = List();
  List tempList = List();
  String _zone;
  String _district;

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
  var _currentSelectedDocType = "Passport";
  var _docTypeValue = "0";

  //List of Issue District
  
  var _currentSelectedIssueDistrict = "Morang";

  //List of date types
  var _issueDateTypeList = ["Nepali-BS", "English-AD"];
  var _currentSelectedIssueDateType = "Nepali-BS";
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
            height: 20.0,
          ),

          //Select Document Type Drop Down
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: "Select Document Type",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
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

          SizedBox(
            height: 15.0,
          ),

          //Document Number Text Field
          TextFormField(
            controller: docNumberControll,
            decoration: InputDecoration(
                labelText: "Document Number",
                hintText: "Type Document Number",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: 20.0,
          ),

          // Document Issuing District  Drop Down
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: "Select Doc Issues District ",
                hintText: "Select",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            items: districtList.map((item) {
              return DropdownMenuItem<String>(
                  value: item.name, 
                  child: Text(item.name));
            }).toList(),
            onChanged: (String newValueSelected) {
              setState(() {
                this._currentSelectedIssueDistrict = newValueSelected;
              });
            },
            value: _currentSelectedIssueDistrict,
          ),

          SizedBox(height: 10.0),

          //  Date Type Drop Down
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: "Select Date Type",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            items: _issueDateTypeList.map((String dropdownIssueDate) {
              return DropdownMenuItem<String>(
                  value: dropdownIssueDate, child: Text(dropdownIssueDate));
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

          SizedBox(height: 10.0),

          //Document Issue Date Text Field
          TextFormField(
            controller: dateControll,
            decoration: InputDecoration(
                labelText: "Document Issue Date",
                hintText: "YYYYMMDD(20531011)",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(8),
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            focusNode: _dateFocus,
          ),

          SizedBox(
            child: Text("Parmanent Address"),
            height: 25.0,
          ),

          //Parmanent Address Drop down List
 
          Column(
                     
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Dropdown Zone
                DropdownButtonFormField(
                  
                  decoration: InputDecoration(
                    labelText: "Zone",
                    hintText: "-Select-",
                      border: OutlineInputBorder(
                        
                        
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  items: zoneList.map((item) {
                    return DropdownMenuItem(
                      child: Text(item.name),
                      value: item.id.toString(),
                    );
                  }).toList(),


                  onChanged: (String newValueSelected) {
                    setState(() {
                      _district = null; 
                      _zone= newValueSelected; 
                      tempList= districtList.where((x)=>x.zoneId.toString()==(_zone.toString())).toList();


                    });
                  },
                  value: _zone,
                ),
                SizedBox(
                  height: 15.0,
                ),


               DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "District",
                    hintText: "-Select-",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),


                  items: tempList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.id.toString(),
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    setState(() {
                      this._district = newValueSelected;
                    });
                  },
                  value: _district,
                )
              ],
          
          ),

          SizedBox(height: 10.0),

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
                              "*",
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
