import 'package:flutter/material.dart';
import 'package:simactivator/SimActivation/NcellSimActivator.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: (100.0 / 60.0),
      crossAxisCount: 2,
      children: <Widget>[
        LandingPageButtons(
          color: Colors.pinkAccent,
          icon: Icon(Icons.account_balance_wallet),
          text: "Check Balance",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
        LandingPageButtons(
          color: Colors.lightGreen,
          icon: Icon(Icons.payment),
          text: "Scan To Recharge",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
        LandingPageButtons(
          color: Colors.green,
          icon: Icon(Icons.signal_cellular_4_bar),
          text: "Data, Voice & SMS",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
        LandingPageButtons(
          color: Colors.purple[300],
          icon: Icon(Icons.account_balance),
          text: "Credit/Loan",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
        LandingPageButtons(
          color: Colors.orangeAccent,
          icon: Icon(Icons.phone_in_talk),
          text: "Transfer Balance",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
        LandingPageButtons(
          color: Colors.blueAccent,
          icon: Icon(Icons.sim_card),
          text: "Sim Activator",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NcellSimActivation()),
            );
          },
        ),
      ],
    );
  }
}

class LandingPageButtons extends StatelessWidget {
  LandingPageButtons(
      {this.child, this.color, this.icon, this.onTap, this.text});
  final Widget child;
  final Color color;
  final Icon icon;
  final VoidCallback onTap;
  final text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: icon,
              ),
              Text(
                "$text",
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
