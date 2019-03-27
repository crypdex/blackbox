package main

import (
	"fmt"

	"admin/config"
	"admin/server"
)

func main() {
	e := server.New()

	// Attempt to load the config
	cfg, err := config.Load("./../.env")
	if err != nil {
		fmt.Println(err)
	}

	cfg.AddChain("zcoin")

	// Start the service
	e.Logger.Fatal(e.Start(":" + cfg.Port()))
}
