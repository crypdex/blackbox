package server

import (
	"admin/validator"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func New() *echo.Echo {
	e := echo.New()
	e.HideBanner = true
	e.Debug = true

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Validator = validator.New()

	e.Use(middleware.RecoverWithConfig(middleware.RecoverConfig{
		DisableStackAll:   true,
		DisablePrintStack: true,
		StackSize:         1,
	}))

	env := NewEnv()

	// The default index page
	e.File("/", "index.html")
	e.Static("/images", "images")

	e.GET("/config", env.GetConfigHandler)
	e.POST("/config", env.SetConfigHandler)

	e.GET("/status", env.StatusHandler)

	return e
}
