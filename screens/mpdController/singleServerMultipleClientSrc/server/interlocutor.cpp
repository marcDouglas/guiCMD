
/
// A simple Internet server application.
// It listens to the port written in command line (default 1234),
// accepts a connection, and sends the "Hello!\r\n" message
// to a client. Then it receives the answer from a client and terminates.
//
// Usage:
//      server [port_to_listen]
// Default is the port 1234.
//
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h> 
#include <thread>

#include "mySocket.h"
#include "myLog.h"
#include "myException.h"
#include "myHostInfo.h"
#include "mySemaphore.h"
#include "myThread.h"
#include "myThreadArgument.h"


static void usage();
static void middleServer(int argc, char *argv[]);

int main(int argc, char *argv[]) {
    
    //
    // server side
    //
    myTcpSocket myServer(PORTNUM);  // create the socket using the given port numberx
    myServer.bindSocket();          // bind the socket to the port number
    myServer.listenToClient();      // listening to the port/socket
    
    while ( 1 )
    {
       // waiting for the client call...
       string clientName;
       myTcpSocket* newClient = myServer.acceptClient(clientName);   
    
       // if we reach here, the server got a call already...
       // declare string messageToClient,messageFromClient;
    
       // receive message from client
       newClient->receiveMessage(messageFromClient);
    
       // send message to client
       newClient->sendMessage(messageToClient);
    
       // other stuff here ...
    } 

    return 0;
}
