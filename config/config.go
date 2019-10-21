package config

import (
	"github.com/pkg/errors"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"os"
	"os/user"
	"path"
	"path/filepath"
)

var version = "3.7"

type Service struct {
	Environment map[string]interface{} `yaml:"environment,omitempty"`
}

type Config struct {
	filepath string
	Version  string             `yaml:"version"`
	Services map[string]Service `yaml:"services"`
}

func ReadFile(options ...string) (*Config, error) {
	var filepath string
	var err error

	// Handle the passed in config file path
	if len(options) > 0 {
		filepath = options[0]
		_, err := os.Stat(filepath)
		if !os.IsNotExist(err) {
			return nil, errors.Wrapf(err, "%s does not exist", filepath)
		}
	} else {
		filepath, err = defaultFilepath()
		if err != nil {
			return nil, err
		}
	}

	config := &Config{
		Version:  "3.7",
		filepath: filepath,
	}

	yamlFile, err := ioutil.ReadFile(filepath)
	if err != nil {
		return nil, err
	}
	err = yaml.Unmarshal(yamlFile, config)
	if err != nil {
		return nil, err
	}

	return config, nil
}

func (config *Config) WriteFile() error {
	data, err := yaml.Marshal(config)
	if err != nil {
		return err
	}

	return ioutil.WriteFile(config.filepath, data, os.ModePerm)
}

// Default names for the BlackboxOS config file
var filenames = []string{
	"blackbox",
	"config",
}

func defaultFilepath() (string, error) {
	// Get the current user executing this script
	usr, err := user.Current()
	if err != nil {
		return "", err
	}

	var matches []string
	for _, filename := range filenames {
		m, err := filepath.Glob(path.Join(usr.HomeDir, ".blackbox", filename) + ".*")
		if err != nil {
			return "", err
		}
		matches = append(matches, m...)
	}

	if len(matches) == 0 {
		return "", errors.New("No config found in default locations")
	}

	// Return the first match
	return matches[0], nil
}
