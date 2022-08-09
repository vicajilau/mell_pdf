import 'dart:isolate';

import '../model/models.dart';
import 'helpers.dart';

class IsolateHelper {
  static Future createRotateIsolate(FileRead file) async {
    /// Where I listen to the message from Mike's port
    ReceivePort myReceivePort = ReceivePort();

    /// Spawn an isolate, passing my receivePort sendPort
    Isolate.spawn<SendPort>(rotateImageWasPressed, myReceivePort.sendPort);

    /// Mike sends a senderPort for me to enable me to send him a message via his sendPort.
    /// I receive Mike's senderPort via my receivePort
    SendPort mikeSendPort = await myReceivePort.first;

    /// I set up another receivePort to receive Mike's response.
    ReceivePort mikeResponseReceivePort = ReceivePort();

    /// I send Mike a message using mikeSendPort. I send him a list,
    /// which includes my message, preferred type of coffee, and finally
    /// a sendPort from mikeResponseReceivePort that enables Mike to send a message back to me.
    mikeSendPort.send([file, mikeResponseReceivePort.sendPort]);

    /// I get Mike's response by listening to mikeResponseReceivePort
    await mikeResponseReceivePort.first;
  }

  static void rotateImageWasPressed(SendPort mySendPort) async {
    /// Set up a receiver port for Mike
    ReceivePort mikeReceivePort = ReceivePort();

    /// Send Mike receivePort sendPort via mySendPort
    mySendPort.send(mikeReceivePort.sendPort);

    /// Listen to messages sent to Mike's receive port
    await for (var message in mikeReceivePort) {
      if (message is List) {
        final file = message[0];
        AppSession.singleton.mfl.rotateImageInMemoryAndFile(file);

        /// Get Mike's response sendPort
        final SendPort mikeResponseSendPort = message[1];

        /// Send Mike's response via mikeResponseSendPort
        mikeResponseSendPort.send("DONE"); // DONE
      }
    }
  }

  static Future createResizeIsolate(
      FileRead file, int width, int height) async {
    /// Where I listen to the message from Mike's port
    ReceivePort myReceivePort = ReceivePort();

    /// Spawn an isolate, passing my receivePort sendPort
    Isolate.spawn<SendPort>(resizeImageWasPressed, myReceivePort.sendPort);

    /// Mike sends a senderPort for me to enable me to send him a message via his sendPort.
    /// I receive Mike's senderPort via my receivePort
    SendPort mikeSendPort = await myReceivePort.first;

    /// I set up another receivePort to receive Mike's response.
    ReceivePort mikeResponseReceivePort = ReceivePort();

    /// I send Mike a message using mikeSendPort. I send him a list,
    /// which includes my message, preferred type of coffee, and finally
    /// a sendPort from mikeResponseReceivePort that enables Mike to send a message back to me.
    mikeSendPort.send([file, width, height, mikeResponseReceivePort.sendPort]);

    /// I get Mike's response by listening to mikeResponseReceivePort
    await mikeResponseReceivePort.first;
  }

  static void resizeImageWasPressed(SendPort mySendPort) async {
    /// Set up a receiver port for Mike
    ReceivePort mikeReceivePort = ReceivePort();

    /// Send Mike receivePort sendPort via mySendPort
    mySendPort.send(mikeReceivePort.sendPort);

    /// Listen to messages sent to Mike's receive port
    await for (var message in mikeReceivePort) {
      if (message is List) {
        final file = message[0];
        final width = message[1];
        final height = message[2];
        AppSession.singleton.mfl
            .resizeImageInMemoryAndFile(file, width, height);

        /// Get Mike's response sendPort
        final SendPort mikeResponseSendPort = message[3];

        /// Send Mike's response via mikeResponseSendPort
        mikeResponseSendPort.send("DONE"); // DONE
      }
    }
  }
}
