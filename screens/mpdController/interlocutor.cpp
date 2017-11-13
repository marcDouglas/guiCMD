
//
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

//#define threadCount 0

//int* clientThreads[0];
int clients[0];
std::thread clientThreads[0];

static void usage();
static void middleServer(int argc, char *argv[]);
static void clientServerThread(int i);

int main(int argc, char *argv[]) {
    //std::thread t1(middleServer, argc, argv);
    //t1.join();
    middleServer(argc, argv);
    return 0;
}

static void usage() {
    printf(
        "A simple Internet server application.\n"
        "It listens to the port written in command line (default 1234),\n"
        "accepts a connection, and sends the \"Hello!\" message to a client.\n"
        "Then it receives the answer from a client and terminates.\n\n"
        "Usage:\n"
        "     server [port_to_listen]\n"
        "Default is the port 1234.\n"
    );
}

static void middleServer(int argc, char *argv[]) {
    int threadCount;
    threadCount = 0;
    
    if (argc > 1 && *(argv[1]) == '-') {
        usage(); exit(1);
    }

    int listenPort = 1234;
    if (argc > 1)
        listenPort = atoi(argv[1]);


    // Create a socket
    int serverReceiveSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverReceiveSocket < 0) {
        perror("Cannot create a socket"); exit(1);
    }

    // Fill in the address structure containing self address
    struct sockaddr_in myaddr;
    memset(&myaddr, 0, sizeof(struct sockaddr_in));
    myaddr.sin_family = AF_INET;
    myaddr.sin_port = htons(listenPort);        // Port to listen
    myaddr.sin_addr.s_addr = htonl(INADDR_ANY);

    // Bind a socket to the address
    int res = bind(serverReceiveSocket, (struct sockaddr*) &myaddr, sizeof(myaddr));
    if (res < 0) {
        perror("Cannot bind a socket"); exit(1);
    }

    // Set the "LINGER" timeout to zero, to close the listen socket
    // immediately at program termination.
    struct linger linger_opt = { 1, 0 }; // Linger active, timeout 0
    setsockopt(serverReceiveSocket, SOL_SOCKET, SO_LINGER, &linger_opt, sizeof(linger_opt));

    // Now, listen for a connection
    res = listen(serverReceiveSocket, 1);    // "1" is the maximal length of the queue
    if (res < 0) {
        perror("Cannot listen"); exit(1);
    }

    // Accept a connection (the "accept" command waits for a connection with
    // no timeout limit...)
    struct sockaddr_in peeraddr;
    socklen_t peeraddr_len;
    while (true) 
    {
        int clientSocket;
        clientSocket = accept(serverReceiveSocket, (struct sockaddr*) &peeraddr, &peeraddr_len);
        if (clientSocket < 0) {
            perror("Cannot accept"); exit(1);
        }
       // res = close(serverReceiveSocket);    // Close the listen socket
        printf(
            "Connection from IP %d.%d.%d.%d, port %d\n",
            (ntohl(peeraddr.sin_addr.s_addr) >> 24) & 0xff, // High byte of address
            (ntohl(peeraddr.sin_addr.s_addr) >> 16) & 0xff, // . . .
            (ntohl(peeraddr.sin_addr.s_addr) >> 8) & 0xff,  // . . .
            ntohl(peeraddr.sin_addr.s_addr) & 0xff,         // Low byte of addr
            ntohs(peeraddr.sin_port)
        );           
        write(clientSocket, "Hello!\r\n", 8);
        
        clientThreads[threadCount] = std::thread(clientServerThread, clientSocket);
        
        threadCount++;

    
       // close(client);          // Close the data socket
    }
}

static void clientServerThread(int clientSocket) {
  char buffer[1024];
  int res;

  while (true) 
  {
    res = read(clientSocket, buffer, 1023);
    if (res < 0) {
        perror("Read error"); exit(1);
    }
    buffer[res] = 0;
    printf("%s", buffer);
    //write(clientSocket, "Hello!\r\n", 8);
  }  
}
