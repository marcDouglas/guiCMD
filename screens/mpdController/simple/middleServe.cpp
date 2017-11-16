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
            

        std::string data;
        int dataLength, tempVar;
        std::string substring;
        std::string isOKsubstring;
        bool isMore = false;
        std::string::size_type index;
        
        ClientSocket mpd_socket ( "localhost", 6600 );
        //mpd_socket >> data;  //get welcome message
        //clientServer_socket[i] << data;  //pass on welcome message            
	      while ( true )
		{
          do {  
            mpd_socket >> data;
            dataLength = data.length();
            if (isMore || (dataLength == MAXRECV)) {
                isOKsubstring = data.substr(dataLength-3, 2);
                if (isOKsubstring == "OK") {
                    //std::cout << "isOK found.\n";
                    if (isMore) {
                        data.insert(0,substring);
                        dataLength = data.length();
                        isMore = false;
                    }
                } else {
                    if (isMore) {                         
                        data.insert(0,substring);
                        dataLength = data.length();
                    } else {
                        isMore = true;   
                    }
                    index = data.rfind( "\n" );
                    if (index != (dataLength-1)) {
                        tempVar=dataLength-index-1;
                        substring = data.substr(index+1, tempVar);                    
                        data.erase (index+1, tempVar);
                    }
                }
            }

            

           // std::cout << "mpd-data\n" << data;
            std::cout << "mpd:" << data.length() << "\n";
            clientServer_socket[i] << data;
          } while (isMore);
          
          do {          
            clientServer_socket[i] >> data;
            dataLength = data.length();
            if (isMore || (dataLength == MAXRECV)) {
            std::cout << "client[" << i << "]:" << data;
            mpd_socket << data;
            
            substring = data.substr(0, 12);
            if (substring == "command_list") {
                if (!isMore) {
                    if (data.length() == MAXRECV) {
                        isMore = true; 
                    }
                }else {
                    isMore = false;
                }
            }
           } while (data.length() == MAXRECV || isMore);
            isMore = false;
		}
	    }
	  catch ( SocketException& ) {}    

}
