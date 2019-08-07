package service

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strings"
)

type Service struct {
	Name   string `yaml:"name"`
	Config Config `yaml:"config"`
	Dir    string
	Env    map[string]string
	Params map[string]interface{}
}

func (service *Service) MarshalJSON() ([]byte, error) {
	return json.Marshal(&struct {
		Name string `json:"name"`
		Dir  string `json:"dir"`
	}{
		Name: service.Name,
		Dir:  service.Dir,
	})
}

// New loads a new Service object in the context of the given directory
func FromDir(dir string, params map[string]interface{}) (*Service, error) {
	name := path.Base(dir)

	// fmt.Printf("Loading '%s'\n", name)

	service := &Service{
		Name:   name,
		Dir:    dir,
		Params: params,
	}

	return service, nil
}

// WARNING DATA_DIR MUST BE SET!
func (service *Service) DataDir() string {
	dataDir := os.Getenv(strings.ToUpper(service.Name) + "_DATA_DIR")
	if dataDir != "" {
		return dataDir
	}

	return path.Join(os.Getenv("DATA_DIR"), service.Name)
}

func (service *Service) Configs() []*Config {
	configs := make([]*Config, 0)
	root := path.Join(service.Dir, "config")

	visit := func(path string, f os.FileInfo, err error) error {
		if f == nil || f.IsDir() {
			return nil
		}

		fn := strings.Replace(path, root, "", -1)
		destination := strings.TrimSuffix(fn, filepath.Ext(fn))

		configs = append(configs, &Config{
			Destination: destination,
			Template:    path,
		})
		return nil
	}

	if err := filepath.Walk(root, visit); err != nil {
	}

	return configs
}

func (service *Service) CompiledConfigs() (map[string]string, error) {
	compiled := make(map[string]string)
	for _, config := range service.Configs() {
		c, err := config.WriteString(service.Params)
		if err != nil {
			return compiled, err
		}
		compiled[path.Join(service.DataDir(), config.Destination)] = c
	}
	return compiled, nil
}

// WriteConfigFile writes the service's config file to it's data directory
func (service *Service) WriteConfigFiles() error {
	configs, err := service.CompiledConfigs()
	if err != nil {
		return err
	}

	for path, config := range configs {
		d, _ := filepath.Split(path)

		err := os.MkdirAll(d, os.ModePerm)
		if err != nil {
			return err
		}

		if err = os.Chmod(d, 0777); err != nil {
			return err
		}

		if err := ioutil.WriteFile(path, []byte(config), 0777); err != nil {
			return err
		}

		if err = os.Chmod(path, 0777); err != nil {
			return err
		}
	}

	return nil
}

func (service *Service) DockerComposePath() string {
	return path.Join(service.Dir, "docker-compose.yml")
}
