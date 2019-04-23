package cmd

import (
	"path/filepath"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

type Env struct {
	*viper.Viper
	Debug bool
}

func NewEnv(debug bool) *Env {
	v := viper.New()

	return &Env{
		Viper: v,
		Debug: debug,
	}
}

// AppRoot returns a priority sorted list of application root paths
func (e *Env) AppRoot() ([]string, error) {
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

type Service struct {
}

// // Config makes concrete the structure expected in `blackbox.yml`
// type Config struct {
// 	DataDir  string                 `yaml:"data_dir"`
// 	Recipe   string                 `yaml:"recipe,omitempty"`
// 	RegisteredServices map[string]interface{} `yaml:"services,omitempty"`
// }
