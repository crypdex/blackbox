package service

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"os"
	"path"
	"strings"
)

type Service struct {
	Name   string `yaml:"name"`
	Config Config `yaml:"config"`
	Dir    string
	Env    map[string]string
	Params map[string]interface{}
}

// New loads a new Service object in the context of the given directory
func FromDir(dir string, params map[string]interface{}) (*Service, error) {
	name := path.Base(dir)

	// fmt.Printf("Loading '%s'\n", name)

	service := &Service{
		Name: name,
		Dir:  dir,
		Config: Config{
			Template: path.Join(dir, "config.tmpl"),
		},
		Params: params,
	}

	// Load the service YAML if it exists
	yamlFile := path.Join(dir, "service.yml")
	if _, err := os.Stat(yamlFile); !os.IsNotExist(err) {
		raw, err := ioutil.ReadFile(yamlFile)
		if err != nil {
			return nil, err
		}
		// This will put in any "default" Params
		if err = yaml.Unmarshal(raw, &service); err != nil {
			return nil, err
		}
	}

	return service, nil
}

// WriteConfigFile writes the service's config file to it's data directory
func (service *Service) WriteConfigFile() error {
	return service.Config.WriteFile(service.DataDir(), service.Params)
}

func (service *Service) ConfigFileString() (string, error) {
	return service.Config.WriteString(service.Params)
}

// WARNING DATA_DIR MUST BE SET!
func (service *Service) DataDir() string {
	dataDir := os.Getenv(strings.ToUpper(service.Name) + "_DATA_DIR")
	if dataDir != "" {
		return dataDir
	}

	return path.Join(os.Getenv("DATA_DIR"), service.Name)
}

func (service *Service) ConfigPath() string {
	return path.Join(service.DataDir(), service.Config.Filename)
}

func (service *Service) DockerComposePath() string {
	return path.Join(service.Dir, "docker-compose.yml")
}
