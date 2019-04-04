package system

import (
	"fmt"
	"os"
	"strings"

	funk "github.com/thoas/go-funk"

	"github.com/spf13/viper"
)

type Env struct {
	config *viper.Viper
	Debug  bool
}

func NewEnv(config *viper.Viper, debug bool) *Env {
	return &Env{config: config, Debug: debug}
}

func (env *Env) ConfigDir() string {
	return env.config.GetString("config_dir")
}

func (env *Env) Recipe() string {
	return env.config.GetString("recipe")
}

// At the root
func (env *Env) ServicesDir() string {
	return env.config.GetString("services_dir")
}

// At the root
func (env *Env) RecipesDir() string {
	return env.config.GetString("recipes_dir")
}

// At the root
func (env *Env) DataDir() string {
	return env.config.GetString("data_dir")
}

func (env *Env) inherited(service string) map[string]string {
	prefix := strings.ToUpper(service) + "_"
	return map[string]string{
		prefix + "DATA_DIR": env.DataDir() + "/" + service,
	}
}

func (env *Env) Environment() map[string]string {
	// output := make(map[string]string)
	output := map[string]string{
		"DATA_DIR": env.DataDir(),
	}

	environment := env.config.Sub("environment")
	if environment != nil {
		for k, v := range environment.AllSettings() {
			output[strings.ToUpper(k)] = v.(string)
		}
	}

	services := env.ServiceNames()

	for _, service := range services {
		serviceEnv := env.ServiceEnvironment(service)

		for key, value := range serviceEnv {
			output[key] = value
		}
	}

	return output
}

func (env *Env) ServiceEnvironment(service string) map[string]string {
	// This is a map so that we can override
	output := make(map[string]string)

	services := env.config.Sub("services")
	if services != nil {

		for key, value := range env.inherited(service) {
			output[key] = value
		}

		prefix := strings.ToUpper(service) + "_"

		for key, value := range services.GetStringMapString(service) {
			output[prefix+strings.ToUpper(key)] = value
		}
	}

	return output
}

// ServiceNames returns a slice of all defined service names
func (env *Env) ServiceNames() []string {
	services := env.config.GetStringMap("services")
	if services == nil {
		return []string{}
	}
	return funk.Keys(services).([]string)
}

// Prestart runs the pre-start.sh script for all services if they exist
func (env *Env) Prestart() {
	// Add up all the services files
	for _, service := range env.ServiceNames() {
		err := env.PrestartService(service)
		if err != nil {
			PrintError(err)
		}
	}
}

func (env *Env) PrestartService(service string) error {
	PrintInfo(fmt.Sprintf("Running pre-start for %s", service))
	path, err := env.PrestartScript(service)
	if err != nil {
		return err
	}
	ExecCommand("bash", []string{"-c", path}, env.ServiceEnvironment(service), env.Debug)
	return nil
}

func (env *Env) PrestartScript(service string) (string, error) {
	path := fmt.Sprintf("%s/%s/pre-start.sh", env.ServicesDir(), service)

	if _, err := os.Stat(path); os.IsNotExist(err) {
		return "", fmt.Errorf("%s pre-start.sh not found", service)
	}

	return path, nil
}
