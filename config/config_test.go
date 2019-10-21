package config

import (
	"fmt"
	"testing"
)

func TestConfig(t *testing.T) {
	c, err := ReadFile()

	fmt.Println(err)
	c.Services = map[string]Service{
		"bitcoin": {},
	}
	c.WriteFile()
}
