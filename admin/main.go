package main

import (
	"admin/server"
)

var port = "8888"

func main() {
	e := server.New()

	// Start the service
	e.Logger.Fatal(e.Start(":" + port))
}
