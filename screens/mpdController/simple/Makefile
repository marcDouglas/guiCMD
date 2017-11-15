# Makefile for the socket programming example
#

simple_server_objects = ServerSocket.o Socket.o simple_server_main.o
simple_client_objects = ClientSocket.o Socket.o simple_client_main.o
middleServe_objects = ServerSocket.o Socket.o ClientSocket.o middleServe.cpp

all : simple_server simple_client middleServe

simple_server: $(simple_server_objects)
	g++ -o simple_server $(simple_server_objects)


simple_client: $(simple_client_objects)
	g++ -o simple_client $(simple_client_objects)

middleServe: $(middleServe_objects)
	g++ -pthread -o middleServe $(middleServe_objects)

Socket: Socket.cpp
ServerSocket: ServerSocket.cpp
ClientSocket: ClientSocket.cpp
simple_server_main: simple_server_main.cpp
simple_client_main: simple_client_main.cpp
middleServe: middleServe.cpp

clean:
	rm -f *.o simple_server simple_client middleServe
