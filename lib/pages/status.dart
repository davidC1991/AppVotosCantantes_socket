import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_online/services/socket_service.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final socketService= Provider.of<SocketService>(context);
    

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}'),
          ],
        ),
        
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){
         print('---');
         socketService.socket.emit('tareaMensaje',{'dato1':'1','dato2':'2'});
       }),
   );
  }
}