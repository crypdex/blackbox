package cmd

import (
	"path/filepath"

	"github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

type Config struct {
	*viper.Viper
	Debug bool
}

func NewConfig(debug bool) *Config {
	v := viper.New()

	return &Config{
		Viper: v,
		Debug: debug,
	}
}

func AppRoot() ([]string, error) {
	// User space:
	// Get the executing user's home directory.
	home, err := homedir.Dir()
	if err != nil {
		return nil, err
	}

	// A priority ordered slice
	paths := []string{
		filepath.Join(home, userspace),
		appspace,
	}

	return paths, nil
}
