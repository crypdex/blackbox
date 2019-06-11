package service

import (
	"fmt"
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
}

// New loads a new Service object in the context of the given directory
func FromDir(dir string) (*Service, error) {
	name := path.Base(dir)

	fmt.Printf("Loading '%s'\n", name)

	service := &Service{
		Name: name,
		Dir:  dir,
		Config: Config{
			Template: path.Join(dir, "config.tmpl"),
		},
	}

	// LOAD THE SERVICE YAML
	raw, err := ioutil.ReadFile(path.Join(dir, "service.yml"))
	if err != nil {
		return service, nil
	}

	err = yaml.Unmarshal(raw, &service)
	return service, err
}

func (service *Service) ConfigString(args ...map[string]interface{}) (string, error) {
	data := map[string]interface{}{}
	if len(args) > 0 {
		data = args[0]
	}

	for _, v := range os.Environ() {
		parts := strings.Split(v, "=")
		data[parts[0]] = parts[1]
	}
	return service.Config.WriteString(data)
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
