package blackbox

import (
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strings"

	yaml "gopkg.in/yaml.v2"
)

type Service struct {
	Name   string        `yaml:"name"`
	Config ServiceConfig `yaml:"config"`
	Dir    string
	Env    map[string]string
}

type ServiceConfig struct {
	Name     string            `yaml:"name"`
	Defaults map[string]string `yaml:config.defaults`
}

func LoadService(dir string) (*Service, error) {
	name := path.Base(dir)
	Trace("debug", fmt.Sprintf("Loading '%s'", name))

	service := &Service{Name: name, Dir: dir}

	// LOAD THE SERVICE YAML
	raw, err := ioutil.ReadFile(filepath.Join(dir, "service.yml"))
	if err != nil {
		// Trace("debug", err.Error())
		return service, nil
	}

	err = yaml.Unmarshal(raw, &service)

	return service, err
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
	return path.Join(service.DataDir(), service.Config.Name)
}

func (service *Service) DockerComposePath() string {
	return path.Join(service.Dir, "docker-compose.yml")
}

// func (service *Service) EnvVars() map[string]string {
// 	// This is a map so that we can override
// 	output := make(map[string]string)
// 	// Add defined environment variables
// 	for k, v := range service.Env {
// 		var value string
// 		switch i := v.(type) {
// 		case string:
// 			value = i
// 		case int:
// 			value = strconv.Itoa(i)
// 		case bool:
// 			value = strconv.FormatBool(i)
// 		default:
// 			fmt.Printf("I don't know about type %T!\n", v)
// 		}
// 		output[strings.ToUpper(service.Name)+"_"+strings.ToUpper(k)] = value
// 	}
// 	return output
// }
