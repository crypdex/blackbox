package server

import (
	"admin/validator"

	"github.com/joho/godotenv"
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

	e.Static("/images", "images")
	e.File("/", "index.html")

	e.GET("/status", StatusHandler)
	e.GET("/config", func(c echo.Context) error {
		var env map[string]string
		env, err := godotenv.Read()

		if err != nil {
			return err
		}
		return c.JSON(200, env)
	})

	return e
}
