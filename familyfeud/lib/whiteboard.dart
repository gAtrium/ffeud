import 'dart:collection';
import 'dart:io';

class ClientHandler {
  Socket client;
  String assignedVariable;

  ClientHandler(this.client, this.assignedVariable);
  Queue<String> commandQueue = Queue<String>();

  void handleData(String data) {
    // add data to command queue
    commandQueue.add(data);
  }

  void sendData(String data) {
    client.writeln(data);
  }
}

class Server {
  ServerSocket? serverSocket;
  List<ClientHandler> clients = [];
  Map<String, ClientHandler?> assignedVariables = {
    'RED': null,
    'BLU': null,
    'GRN': null,
    'HARVEY': null,
  };

  void handleCommand(String data, ClientHandler clientHandler) {
    var parts = data.split(' ');
    if (parts.length == 2 && parts[0] == 'ASSIGN') {
      // assign variable to client
      var variableName = parts[1];
      if (assignedVariables.containsKey(variableName)) {
        if (assignedVariables[variableName] != null) {
          // variable already assigned
          clientHandler.sendData('Variable $variableName is already assigned');
        } else {
          assignedVariables[variableName] = clientHandler;
          clientHandler.assignedVariable = variableName;
          clientHandler.sendData('Assigned to $variableName');
        }
      } else {
        // unknown variable
        clientHandler.sendData('Unknown variable: $variableName');
      }
    } else if (parts.length >= 2 && parts[0] == 'COMMAND') {
      // send command to assigned client
      var variableName = parts[1];
      if (assignedVariables.containsKey(variableName)) {
        var client = assignedVariables[variableName];
        if (client != null) {
          var command = parts.sublist(2).join(' ');
          client.sendData('$variableName: $command');
        } else {
          clientHandler.sendData('Variable $variableName is not assigned');
        }
      } else {
        // unknown variable
        clientHandler.sendData('Unknown variable: $variableName');
      }
    } else {
      // unknown command
      clientHandler.sendData('Unknown command: $data');
    }
  }
}
