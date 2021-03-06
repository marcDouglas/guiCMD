
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
#include <thread>
#include <mutex> 
#include <condition_variable>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>
#include <errno.h>
#include <assert.h>
#include <signal.h>

static void usage();
static void middleServer(int argc, char *argv[]);
static void clientServerThread(int i);
static void mpdClientThread(int i);
static void sigHandler(int sigID);  // Handler of SIGPIPE signal    

int clients[100];
int mpdClientCount;
std::thread clientThreads[0];
std::condition_variable mpdIsOnlineCV[100];
std::condition_variable clientIsOnlineCV[100];
bool mpdIsOnline_bool[100];
bool clientIsOnline_bool[100];

//std::thread mpdThreads[100];
int clientSocket[100];
int mpdSocket[100];

int finished;
const int MAX_LINE_LENGTH = 65534;
std::mutex clientLock[100];
std::mutex mpdLock[100];

std::condition_variable cv; // condition variable for critical section  

int main(int argc, char *argv[]) {
    finished = 0;
    
    //std::thread t1(middleServer, argc, argv);
    //t1.join();
    middleServer(argc, argv);
    //mpdClientThread(0);
    //mpdThreads[0] = std::thread(mpdClientThread, 0);
    //mpdThreads[0].join();
    return 0;
}


static void middleServer(int argc, char *argv[]) {
    
    int threadCount;
    int connected;
    threadCount = 0;
    
    if (argc > 1 && *(argv[1]) == '-') {
        usage(); exit(1);
    }

    int listenPort = 6601;
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
    //printf("middleServer 2");
    

    while (true) 
    {
        connected = false;
        do
        {
            clientSocket[threadCount] = accept(serverReceiveSocket, (struct sockaddr*) &peeraddr, &peeraddr_len);
            if (clientSocket[threadCount] < 0) {
                perror("Cannot accept clientSocket");
                sleep (1);
            } else {
                connected = true;
            }
        } while (!connected);
       // res = close(serverReceiveSocket);    // Close the listen socket
        printf(
            "clientServer connected: %d.%d.%d.%d, port %d\n",
            (ntohl(peeraddr.sin_addr.s_addr) >> 24) & 0xff, // High byte of address
            (ntohl(peeraddr.sin_addr.s_addr) >> 16) & 0xff, // . . .
            (ntohl(peeraddr.sin_addr.s_addr) >> 8) & 0xff,  // . . .
            ntohl(peeraddr.sin_addr.s_addr) & 0xff,         // Low byte of addr
            ntohs(peeraddr.sin_port)
        );           
        //write(clientSocket[threadCount], "Hello!\r\n", 8);
        clientThreads[threadCount] = std::thread(clientServerThread, threadCount);
        //mpdThreads[threadCount] = std::thread(mpdClientThread, threadCount);
        //sleep(1);
         //clientThreads[1] = std::thread(mpdClientThread2, 1);
        //mpdThreads[0].join();
        //mpdClientThread(threadCount);
        threadCount++;

    
       // close(client);          // Close the data socket
    }
}

static void clientServerThread(int i) {
    //sleep(3);
    char buffer[MAX_LINE_LENGTH];
    int results;
    int bufferLen;
    mpdIsOnline_bool[i]=false;
    clientIsOnline_bool[i]=false;
    
    std::thread mpdThread;
    // mpdClientThread(clientSocket, mpdSocket);
    mpdThread = std::thread(mpdClientThread,i);
    // mpdClientCount++;
    //printf("connecting clientServerThread\n");
  while (true) 
  {
    results = read(clientSocket[i], buffer, 1023);
    if (results < 0) {
        perror("Read error"); exit(1);
    }
    buffer[results] = 0;
    //printf("%s", buffer);

    //write(clientSocket, "Hello!\r\n", 8);
    clientIsOnline_bool[i]=true;
    clientIsOnlineCV[i].notify_one();
    std::unique_lock<std::mutex> locker(mpdLock[i]);
    while(!mpdIsOnline_bool[i]) // used to avoid spurious wakeups 
    {
        mpdIsOnlineCV[i].wait(locker);
    }
    
    bufferLen = strlen(buffer);
    if (!finished && bufferLen > 0) {
        results = write(mpdSocket[i], buffer, bufferLen);
        if (results < 0) {
            if (errno != EAGAIN) {
                perror("Write error");
                break;              // Write error
            } else {
                perror("Incompleted send");
            }
        } else if (results == 0) {
            printf("Connection closed");
            break;
        } else if (results > 0) {
            bufferLen=0;
            //writePos += results;
            //writeBufferLen -= results;
        }
    }
    mpdIsOnline_bool[i]=false;
  }  
}


static void mpdClientThread(int i) {
   // int mpdSocket;  // Network socket
    printf("connecting to mpd.\n");

    char readBuffer[MAX_LINE_LENGTH];  // Read buffer

    //char writeBuffer[MAX_LINE_LENGTH]; // Write buffer
    //char *writePos = writeBuffer;          // current position
    int writeBufferLen = 0;                // write buffer length

    

    struct timeval tv;  // Timeout value

    // Set signal handler for the "SIGPIPE" signal
    // (used to intercept the signal about broken connection).
    if (signal(SIGPIPE, &sigHandler) == SIG_ERR) {
        perror("Cannot install a signal handler");
        exit(1);
    }


    // Create a socket
    mpdSocket[i] = socket(AF_INET, SOCK_STREAM, 0);
    if (mpdSocket[i] < 0) {
        perror("Cannot create a socket"); exit(1);
    }

    // Fill in the address of server
    struct sockaddr_in peeraddr2;
    //int peeraddr2_len;
    memset(&peeraddr2, 0, sizeof(peeraddr2));
    char* peerHost = (char*)"localhost";


    // Resolve the server address (convert from symbolic name to IP number)
    struct hostent *host = gethostbyname(peerHost);
    if (host == NULL) {
        perror("Cannot define host address"); exit(1);
    }
    peeraddr2.sin_family = AF_INET;
    short peerPort = 6600;


    peeraddr2.sin_port = htons(peerPort);

    // Print a resolved address of server (the first IP of the host)
    printf(
        "mpd connect addr = %d.%d.%d.%d, port %d\n",
        host->h_addr_list[0][0] & 0xff,
        host->h_addr_list[0][1] & 0xff,
        host->h_addr_list[0][2] & 0xff,
        host->h_addr_list[0][3] & 0xff,
        (int) peerPort
    );

    // Write resolved IP address of a server to the address structure
    memmove(&(peeraddr2.sin_addr.s_addr), host->h_addr_list[0], 4);

    // Connect to a remote server
    int res = connect(mpdSocket[i], (struct sockaddr*) &peeraddr2, sizeof(peeraddr2));
    if (res < 0) {
        perror("Cannot connect mpd."); exit(1);
    }
    //printf("Connected. Type a message and press \"Enter\".\n");

    // Define socket as non-blocking
    // res = fcntl(mpdSocket[i], F_SETFL, O_NONBLOCK);
    // if (res < 0) {
    //     perror("Cannot set a socket as non-blocking");
    //     exit(1);
    // }
    fd_set readfds;     // Set of socket descriptors for select

    while (!finished) {

        // Read all incoming data
        int received = 0;
        while (received < MAX_LINE_LENGTH) {
            FD_ZERO(&readfds);    // Erase the set of socket descriptors
            FD_SET(mpdSocket[i], &readfds); // Add the socket "mpdSocket" to the set

            tv.tv_sec = 0;        // Define the timeout value
            tv.tv_usec = 100000;  // 0.1 sec (in microseconds)

            //=== "select" is the key poit of the program! ============
            res = select(
                mpdSocket[i] + 1,   // Max. number of socket in all sets + 1
                &readfds, // Set of socket descriptors for reading
                NULL,     // Set of sockets for writing -- not used
                NULL,     // Set of sockets with exceptions -- not used
                &tv       // Timeout value
            );
            //=========================================================

            if (res < 0) {
                perror("Select error");
                finished = 1;
                break;
            } else if (res == 0) {
                break;  // No data is availible yet
            }

            // At this point, we can read an incoming data
            assert(FD_ISSET(mpdSocket[i], &readfds));

            res = read(
                mpdSocket[i],
                readBuffer + received,
                MAX_LINE_LENGTH - received
            );
            if (res > 0) {
                received += res;
            } else {
                if (res < 0 && errno != EAGAIN) {
                    perror("Read error");
                    finished = 1;
                }
                break;
            }
        } // end of reading

        if (received > 0) {
            readBuffer[received] = 0;
            //printf("%s", readBuffer);
        }
     
        mpdIsOnline_bool[i]=true;
        mpdIsOnlineCV[i].notify_one();


        
        writeBufferLen = strlen(readBuffer);
        if (!finished && writeBufferLen > 0) {
            res = write(clientSocket[i], readBuffer, writeBufferLen);
            if (res < 0) {
                if (errno != EAGAIN) {
                    perror("Write error");
                    break;              // Write error
                } else {
                    perror("Incompleted send");
                }
            } else if (res == 0) {
                printf("Connection closed");
                break;
            } else if (res > 0) {
                //writePos += results;
                //writeBufferLen -= results;
                writeBufferLen=0;
            }
        }
        
        std::unique_lock<std::mutex> locker(clientLock[i]);
        while(!clientIsOnline_bool[i]) // used to avoid spurious wakeups 
        {
            clientIsOnlineCV[i].wait(locker);
        }
        clientIsOnline_bool[i]=false;

    } // end while

    shutdown(mpdSocket[i], 2);
    close(mpdSocket[i]);
   // return 0;
}


static void sigHandler(int sigID) {
    printf("The SIGPIPE signal (connection is broken).\n");
    finished = 1;
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
