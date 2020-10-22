import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;


  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  //Function get emit => this._socket.emit;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    // Dart client
    this._socket = IO.io('http://192.168.1.27:3000/',<String, dynamic>{
      'transports' :['websocket'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
     print('connect');
     this._serverStatus=ServerStatus.Online;
     notifyListeners();
    });
     
    this._socket.on('disconnect', (_) { 
     this._serverStatus=ServerStatus.Offline;
     notifyListeners();
     print('disconnect');
    });

    socket.on('nuevo-mensaje', (payload) { 
     print('nuevo-mensaje');
     print('dato1:${payload['dato1']}');
     print('dato2:${payload['dato2']}');
     print(payload.containsKey('mensaje2')?payload['mensaje2']:'No hay');
    });  
     
  }

}