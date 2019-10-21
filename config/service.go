package config

import (
	"github.com/mitchellh/go-homedir"
	"os"
	"path/filepath"
)

var appspace = "/var/lib/blackbox"
var userspace = ".blackbox"

// ServicePaths is a slice of absolute paths, sorted in priority order, used as search roots
func ServicePaths() ([]string, error) {
	// User space:
	// Get the executing user's home directory.
	pwd, err := os.Getwd()
	if err != nil {
		return nil, err
	}

	home, err := homedir.Dir()
	if err != nil {
		return nil, err
	}

	// A priority ordered slice
	return []string{
		pwd,
		filepath.Join(home, userspace),
		appspace,
	}, nil
}
