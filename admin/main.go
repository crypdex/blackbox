package main

import (
	"fmt"
	"os"

	"github.com/labstack/echo"
)

// This app is a tiny server to assist with updating the package via web interface
// It has two endpoints
//
// GET /update
// POST /update
//
func main() {
	e := echo.New()
	e.HideBanner = true
	e.Debug = true
	port := "8888"

	// Middleware
	// e.Use(middleware.Logger())
	// e.Use(middleware.Recover())

	e.GET("update", func(context echo.Context) error {
		fmt.Println("apt-get update")
		return nil
	})

	// Start the service
	e.Logger.Fatal(e.Start(":" + getenv("PORT", port)))
}

func getenv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
