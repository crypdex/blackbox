package main

import (
	"fmt"
	"os"
	"runtime"
	"time"

	"github.com/crypdex/blackbox/admin/apt"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"github.com/logrusorgru/aurora"
)

// This app is a tiny server to assist with updating the package via web interface
// It has two endpoints
//
// GET /update
// POST /update
//
func main() {
	if runtime.GOOS != "linux" {
		fmt.Println(aurora.Red("Sorry mate, this is a Linux app"))
		return
	}

	e := echo.New()
	e.HideBanner = true
	e.Debug = true
	e.Server.ReadTimeout = 1 * time.Minute
	e.Server.WriteTimeout = 1 * time.Minute

	port := "8888"
	if os.Getenv("PORT") != "" {
		port = os.Getenv("PORT")
	}

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("info", getInfo)
	e.POST("upgrade", doUpgrade)

	// Start the service
	e.Logger.Fatal(e.Start(":" + port))
}

func getInfo(context echo.Context) error {
	info, err := apt.GetPackageInfo("blackboxd")
	if err != nil {
		return err
	}

	return context.JSON(200, info)
}

func doUpgrade(context echo.Context) error {
	_, err := apt.Upgrade("blackboxd")
	if err != nil {
		return err
	}

	info, err := apt.GetPackageInfo("blackboxd")
	if err != nil {
		return err
	}

	return context.JSON(200, info)
}
