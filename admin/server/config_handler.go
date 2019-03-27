package server

import (
	"github.com/labstack/echo"
	"github.com/pkg/errors"
)

type ConfigRequest struct {
	Chains []string `json:"chains"`
}

func (env *Env) GetConfigHandler(c echo.Context) (err error) {
	return c.JSON(200, env.config.AllSettings())
}

func (env *Env) SetConfigHandler(c echo.Context) (err error) {
	defer handle(&err)

	request := new(ConfigRequest)
	err = c.Bind(request)
	check(errors.Wrap(err, "could not bind request"))

	err = env.config.SetChains(request.Chains...)
	check(err)

	return c.JSON(200, env.config.AllSettings())
}
