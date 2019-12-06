package main

import (
	"log"
	"os"
)

func main() {

	// Logging ====================
	log := log.New(os.Stdout, "restAPI: ", log.LstdFlags|log.Lmicroseconds|log.Lshortfile)

	// App starting ==================
	log.Printf("app starting")

	// Config
	//var cfg struct{
	//	Web struct{
	//		Port int
	//		SSL bool
	//	}
	//
	//}


	// Start API Service

}
