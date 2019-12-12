package main

import (
	"log"
	"os"
	"time"
)

func main() {

	// Logging ====================
	log := log.New(os.Stdout, "restAPI: ", log.LstdFlags|log.Lmicroseconds|log.Lshortfile)

	// App starting ==================
	log.Printf("app starting")

	// Config
	var cfg struct{
		Web struct{
			Port int
			SSL bool
			ReadTimeout	time.Duration
			WriteTimeout time.Duration
			ShutdownTimeout time.Duration
		}
		DB struct{
			User string
			Password string
			Host string
			Name string
			DisableTLS bool
		}

	}

	// parse config


	// Start API Service

}
