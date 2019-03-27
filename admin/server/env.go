package server

import (
	"admin/config"
	"fmt"
)

type Env struct {
	config *config.Config
}

func NewEnv() *Env {
	file := "./../.env"
	// Attempt to load the config
	cfg, err := config.Load(file)
	if err != nil {
		fmt.Println(err)
	}

	return &Env{config: cfg}
}
