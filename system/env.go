package system

import (
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
)

type Env struct {
	globals *viper.Viper
	Debug   bool
}

func NewEnv(config *viper.Viper, debug bool) *Env {
	return &Env{globals: config, Debug: debug}
}

// -----------
// GLOBAL VARS
// -----------

func (env *Env) DataDir() string {
	return env.globals.GetString("data_dir")
}

func (env *Env) ServicesDir() string {
	return env.globals.GetString("services_dir")
}

func (env *Env) Services() map[string]interface{} {
	return env.globals.GetStringMap("services")
}

func (env *Env) GetServiceConfig(service string) map[string]interface{} {
	return env.globals.GetStringMap("services." + service)
}

// Prestart runs the pre-start.sh script for all services if they exist
func (env *Env) Prestart() {
	// Add up all the services files
	for service := range env.Services() {
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
	ExecCommand("bash", []string{"-c", path}, env.GetServiceEnv(service), env.Debug)
	return nil
}

func (env *Env) PrestartScript(service string) (string, error) {
	path := fmt.Sprintf("%s/%s/pre-start.sh", env.ServicesDir(), service)

	if _, err := os.Stat(path); os.IsNotExist(err) {
		return "", fmt.Errorf("%s pre-start.sh not found", service)
	}

	return path, nil
}

func (env *Env) GetServiceEnv(service string) map[string]string {
	prefix := strings.ToUpper(service) + "_"

	// This is a map so that we can override
	output := make(map[string]string)
	// Default DATA_DIR namespaced for each service
	output[prefix+"DATA_DIR"] = env.DataDir() + "/" + service

	for key, value := range env.GetServiceConfig(service) {
		output[prefix+strings.ToUpper(key)] = value.(string)
	}
	return output
}

// GetEnv needs to be move dout
// There environment variables are made available by default to the docker stack command
func (env *Env) GetEnv() map[string]string {
	// This is a map so that we can override
	output := map[string]string{
		"DATA_DIR": env.DataDir(),
	}

	for service := range env.Services() {
		serviceEnv := env.GetServiceEnv(service)
		for k, v := range serviceEnv {
			output[k] = v
		}
	}

	return output
}
