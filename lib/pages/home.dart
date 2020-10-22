import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:vote_online/model/band.dart';
import 'package:vote_online/services/socket_service.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   List<Band> bands =[
    /* Band(id:'1', name: 'Ivan Villazon', votes: 5),
    Band(id:'2', name: 'Silvestre Dangon', votes: 3),
    Band(id:'3', name: 'Diomedes Diaz', votes: 15),
    Band(id:'4', name: 'Los Betos', votes: 13), */
  ]; 

  @override
  void initState() {
    // TODO: implement initState
    final socketService= Provider.of<SocketService>(context,listen:false);
    socketService.socket.on('active-bands',_handleActiveBands);

         
    
    
    super.initState();
  }

  _handleActiveBands(dynamic payload){
      this.bands = (payload as List).
                   map((band) => Band.fromMap(band))
                   .toList();
      setState(() { });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    final socketService= Provider.of<SocketService>(context,listen:false);
    socketService.socket.off('active-bands');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

     final socketService= Provider.of<SocketService>(context);
    print('${socketService.serverStatus}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Cantantes', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
               socketService.serverStatus.toString().contains('Online')?
               Icon(Icons.check_circle, color:Colors.blue[300]):
               Icon(Icons.check_circle, color:Colors.red)
                      
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: ( context, i)=> bandTile(bands[i])   
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand
      ),  
   );
  }


  Widget bandTile(Band band) {
    final socketService= Provider.of<SocketService>(context,listen:false);
    
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_)=>socketService.socket.emit('delete-band',{'id':band.id}),
      background: Container(
        padding: EdgeInsets.only(left:8.0),
        color:Colors.red,
        child:Align(
          alignment: Alignment.centerLeft,
          child: Text('Borrar cantante',style: TextStyle(color: Colors.white,)
        )
      ),),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
            onTap: ()=>socketService.socket.emit('vote-band',{'id':band.id}),
            
            
          ),
    );
  }

  addNewBand(){
   final textController = new TextEditingController(); 

   if(Platform.isAndroid){
   return showDialog(
     context: context,
     builder: (context){
       return AlertDialog(
         title: Text('Nuevo cantante'),
         content: TextField(
           controller: textController,
         ),
         actions: <Widget>[
           MaterialButton(
             child: Text('Add'),
             elevation: 5,
             textColor: Colors.blue,
             onPressed:()=> addBandToList(textController.text) 
           )
         ],
       );
     } 
   );
   }

   showCupertinoDialog(
     context: context,
     builder: (_){
       return CupertinoAlertDialog(
         title: Text('Nuevo cantante'),
         content: CupertinoTextField(
           controller: textController,
         ),
         actions: <Widget>[
           CupertinoDialogAction(
             isDefaultAction: true,
             child:Text('Add') ,
             onPressed: ()=> addBandToList(textController.text),
           ),
           CupertinoDialogAction(
             isDestructiveAction: true,
             child:Text('Dismiss') ,
             onPressed: ()=> Navigator.pop(context),
           )
         ],
       );
     }
   );
  }

  void addBandToList(String name){
    final socketService = Provider.of<SocketService>(context,listen:false);
    if(name.length>1){
     socketService.socket.emit('add-band',{'name':name});
    }
    Navigator.pop(context);
  }
  _showGraph(){
    Map<String, double> dataMap = {
    /* "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2, */
  };
  bands.forEach((band) {
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
   });
   final List<Color> colorList =[
     Colors.blue[300],
     Colors.blue[100],
     Colors.red[300],
     Colors.red[100],
     Colors.yellow[300],
     Colors.yellow[100],
     Colors.brown[300],
     Colors.brown[100],
   ];
  return Container(
    width: double.infinity,
    height: 200,
    child: PieChart(
       dataMap: dataMap,
       
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 70,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 42,
      centerText: "BANDAS",
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        //legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
      ));
  }
}