package blackbox

import (
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	. "github.com/logrusorgru/aurora"
	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

// App contains common variables and defaults used by blackboxd
type App struct {
	config             *viper.Viper
	Debug              bool
	RegisteredServices map[string]*Service
	ConfigFile         string
}

// NewApp ...
// Overriding the configfile used should be done from outside this func
func NewApp(debug bool, configFile string) *App {
	// Let's start with some assumed basic configuration
	// Create an empty config
	var v *viper.Viper

	if configFile == "" {
		v = loadDefault()
	} else {
		v = viper.New()
		v.SetConfigFile(configFile)
		v.ReadInConfig()
	}

	// Load recipe if defined
	// LEGACY SUPPORT
	recipe := getRecipe(v)
	if recipe != "" {
		file, err := getRecipeFile(recipe)
		if err != nil {
			panic(err)
		}

		// v2 := viper.New()
		v.SetConfigFile(file)
		// v2.ReadInConfig()

		// Inherit settings ...
		v.Set("x-blackbox", v.Get("x-blackbox"))
		v.MergeInConfig()
		// v = v2
	}

	config := &App{
		config:             v,
		Debug:              debug,
		ConfigFile:         v.ConfigFileUsed(),
		RegisteredServices: registerServices(),
	}

	return config
}

// DataDir is the global data directory. It may be overridden in each service using x-blackbox
//
func (app *App) DataDir() (string, error) {
	// If a root data directory is defined ...
	datadir := app.config.GetString("x-blackbox.data_dir")
	if datadir != "" {
		return datadir, nil
	}

	// The default datadir is at ~/.blackbox/data
	home, err := homedir.Dir()
	return filepath.Join(home, userspace, "data"), err
}

// Services are those defined in the root blackbox.yml file
//
func (app *App) Services() map[string]*Service {
	services := make(map[string]*Service)

	for key, _ := range app.config.GetStringMap("services") {
		service, ok := app.RegisteredServices[key]
		if !ok {
			fmt.Println(Red("WARN: no registered service:"), key)
			continue
		}
		services[key] = service

		envvars := app.config.GetStringMap(fmt.Sprintf("services.%s.x-env", key))
		service.Env = envvars
	}

	// trace(fmt.Sprintf("configured services: %s", funk.Keys(services)))

	return services
}

func (app *App) ForceSwarm() bool {
	return app.config.GetBool("swarm") || app.config.GetBool("x-blackbox.swarm")
}

func (app *App) EnvVars() map[string]string {

	datadir, _ := app.DataDir()
	output := map[string]string{
		"DATA_DIR": datadir,
	}

	for _, service := range app.Services() {
		for k, v := range app.ServiceEnvVars(service) {
			output[k] = v
		}
	}

	// Add environment variables from .env files
	// This should overrride variables set by the service definitions
	// as well as variables set by the main "recipe"
	for k, v := range loadDotEnv() {
		output[k] = v
	}

	// app.log("debug", fmt.Sprintf("%#v", output))
	return output
}

func (app *App) ServiceEnvVars(service *Service) map[string]string {
	output := map[string]string{}

	if service == nil {
		return output
	}

	datadir, _ := app.DataDir()

	output[strings.ToUpper(service.Name)+"_DATA_DIR"] = filepath.Join(datadir, service.Name)
	for k, v := range service.EnvVars() {
		output[k] = v
	}

	return output
}

// Prestart runs the pre-start.sh script for all services if they exist
func (app *App) Prestart() {
	// Add up all the services files
	for _, service := range app.Services() {
		err := app.runScript(service, "pre-start")
		if err != nil {
			fmt.Println(err)
		}
	}
}

// RESET

// Prestart runs the pre-start.sh script for all services if they exist
func (app *App) Reset() {
	// Add up all the services files
	for _, service := range app.Services() {
		err := app.runScript(service, "reset")
		if err != nil {
			fmt.Println(err)
		}
	}
}

func (app *App) runScript(service *Service, name string) error {
	script := fmt.Sprintf("%s.sh", name)
	trace(fmt.Sprintf("Running '%s' for service: %s", name, service.Name))

	for _, p := range service.FilePaths {
		if _, err := os.Stat(path.Join(p, script)); os.IsNotExist(err) {
			return fmt.Errorf("%s %s not found", service.Name, script)
		}
		status := ExecCommand("bash", []string{"-c", path.Join(p, script)}, app.ServiceEnvVars(service), app.Debug)

		trace(status.Stdout...)
		trace(status.Stderr...)
	}

	return nil
}

func (app *App) log(level string, msg ...string) {
	for _, m := range msg {
		switch level {
		case "error":
			fmt.Println(Red(m))
		default:
			if app.Debug {
				fmt.Println(Gray(20-1, fmt.Sprintf(" %s ", m)).BgGray(4 - 1))
			}
		}
	}
}
