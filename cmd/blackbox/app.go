package blackbox

import (
	"fmt"
	"os"
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
	if configFile != "" {
		v := viper.New()
		v.SetConfigFile(configFile)
		v.ReadInConfig()

		return &App{
			config:             v,
			Debug:              debug,
			ConfigFile:         v.ConfigFileUsed(),
			RegisteredServices: registerServices(),
		}
	}
	// Create an empty config
	v := loadDefault()

	// Load recipe if defined
	// LEGACY SUPPORT
	recipe := getRecipe(v)
	if recipe != "" {
		file, err := getRecipeFile(recipe)
		if err != nil {
			panic(err)
		}
		v2 := viper.New()
		v2.SetConfigFile(file)
		v2.ReadInConfig()
		// Inherit settings ...
		v2.Set("x-blackbox", v.Get("x-blackbox"))
		v = v2
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
		err := app.PrestartScript(service)
		if err != nil {
			fmt.Println(err)
		}
	}
}

func (app *App) PrestartScript(service *Service) error {
	trace(fmt.Sprintf("[prestart] running pre-start for %s", service.Name))
	for _, path := range service.FilePaths {
		path := fmt.Sprintf("%s/pre-start.sh", path)

		if _, err := os.Stat(path); os.IsNotExist(err) {
			return fmt.Errorf("%s pre-start.sh not found", service.Name)
		}
		status := ExecCommand("bash", []string{"-c", path}, app.ServiceEnvVars(service), app.Debug)

		app.log("debug", status.Stdout...)
		app.log("error", status.Stderr...)
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
