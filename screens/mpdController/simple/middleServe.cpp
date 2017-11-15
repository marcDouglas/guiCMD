#include "ServerSocket.h"
#include "ClientSocket.h"
#include "SocketException.h"
#include <string>
#include <iostream>
#include <thread>

static void clientServerThread ( int i );

std::thread clientThreads[10];
ServerSocket clientServer_socket[10];

int main ( int argc, char *argv[] )
{
  std::cout << "running....\n";

  try
    {
      // Create the socket
      ServerSocket server ( 6601 );
        
      int threadCount = 0;
        
      while ( true )
	{
      std::cout << "starting server.\n";
	  //ServerSocket clientServer_socket;
	  server.accept ( clientServer_socket[threadCount] );
      std::cout << "Client connected.\n";
      
      clientThreads[threadCount] = std::thread(clientServerThread, threadCount);
      threadCount++;
	  

	}
    }
  catch ( SocketException& e )
    {
      std::cout << "Exception was caught:" << e.description() << "\nExiting.\n";
    }

  return 0;
}

static void clientServerThread ( int i )
{
try
	    {
            
        ClientSocket mpd_socket ( "localhost", 6600 );
        std::string data;
        std::string substring;
        bool isMore = false;
            
	      while ( true )
		{
          do {  
            mpd_socket >> data;
            std::cout << "mpd:" << data.length() << "\n";
            clientServer_socket[i] << data;
          } while (data.length() == MAXRECV);
          
          do {          
            clientServer_socket[i] >> data;
          
            std::cout << "client:" << data << "\n";
            mpd_socket << data;
            
            substring = data.substr(0, 12);
            //std::cout << "substring:" << substring << "\n";
            if (substring == "command_list") {
                if (!isMore) {
                std::cout << "command_list: isMore\n";
                isMore = true;
                }else {
                    std::cout << "command_list: end\n";
                    isMore = false;
                }
            }
           } while (data.length() == MAXRECV || isMore);
          // isMore=false;
		}
	    }
	  catch ( SocketException& ) {}    

}
