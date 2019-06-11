package blackbox

import (
	"fmt"
	"github.com/crypdex/blackbox/cmd/service"
	"io/ioutil"
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
	RegisteredServices map[string]*service.Service
	ConfigFile         string
}

// NewApp ...
// Overriding the configfile used should be done from outside this func
//
// This constructor does the following
// - "registers" services
func NewApp(debug bool, configFile string) (*App, error) {
	// Loads from .env files and assures we have the env vars
	loadEnv()

	// Let's start with some assumed basic configuration
	// Create an empty config
	var v *viper.Viper
	var err error

	if configFile == "" {
		v, err = loadDefault()
		if err != nil {
			return nil, err
		}

	} else {
		v = viper.New()
		v.SetConfigFile(configFile)
		err := v.ReadInConfig()
		if err != nil {
			return nil, err
		}
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

	return config, nil
}

// DataDir is the global data directory. It may be overridden in each service using x-blackbox
func (app *App) DataDir() (string, error) {
	if os.Getenv("DATA_DIR") != "" {
		return os.Getenv("DATA_DIR"), nil
	}

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
func (app *App) Services() map[string]*service.Service {
	services := make(map[string]*service.Service)

	for key, _ := range app.config.GetStringMap("services") {
		service, ok := app.RegisteredServices[key]
		if !ok {
			// Trace("debug", fmt.Sprintf("no registered service: %s", key))
			continue
		}
		services[key] = service

		// This is likely unnecessary
		// envvars := parseEnVars(app.config.GetStringSlice(fmt.Sprintf("services.%s.environment", key)))
		//
		// service.Env = envvars

		// env_file
		// envFiles := app.config.GetStringSlice(fmt.Sprintf("services.%s.env_file", key))
		//
		// env, err := godotenv.Read(envFiles...)
		// if err != nil {
		// 	fmt.Println(err)
		// }
		// for k, v := range env {
		// 	service.Env[k] = v
		// }
	}
	// Trace(fmt.Sprintf("configured services: %s", funk.Keys(services)))
	return services
}

func (app *App) Install(bin string, force bool) error {
	var binPath string

	// Loop through all the services
	for name, _ := range app.RegisteredServices { // range app.Services() {
		// Check for the service in each of the config paths ...
		for _, p := range configPaths() {
			// Does the bin exist here?
			candidate := path.Join(p, "services", name, "bin", bin)
			if _, err := os.Stat(candidate); os.IsNotExist(err) {
				continue
			}
			// This will get overwritten for multi hits
			binPath = candidate
		}
		// We have found our bin, we can stop looking
		if binPath != "" {
			break
		}
	}

	if binPath == "" {
		return fmt.Errorf("no bin found for %s", bin)
	}

	Trace("info", fmt.Sprintf("Found %s", bin))
	Trace("info", fmt.Sprintf("Installing %s to /usr/local/bin", bin))

	targetPath := path.Join("/usr/local/bin", bin)
	// Does the file already exist?
	_, err := os.Stat(targetPath)
	if !os.IsNotExist(err) && !force {
		return fmt.Errorf("%s exists -- use -f to force installation", bin)
	}

	// COPY THE FILE INTO PLACE
	var input []byte
	if input, err = ioutil.ReadFile(binPath); err != nil {
		return err
	}

	if err = ioutil.WriteFile(targetPath, input, 0777); err != nil {
		return err
	}

	return nil
}

func (app *App) Remove(bin string) error {
	Trace("info", fmt.Sprintf("Removing %s", bin))

	if err := os.Remove(path.Join("/usr/local/bin", bin)); err != nil {
		return err
	}

	return nil
}

func (app *App) ListBinaryWrappers() (map[string][]string, error) {
	cache := make(map[string][]string)
	// Loop through all the registered services
	for name := range app.Services() {
		// Check for the service in each of the config paths ...
		for _, p := range configPaths() {
			// Does the bin exist here?
			dir := path.Join(p, "services", name, "bin")
			if _, err := os.Stat(dir); os.IsNotExist(err) {
				continue
			}

			files, err := ioutil.ReadDir(dir)
			if err != nil {
				return nil, err
			}

			for _, file := range files {
				if cache[name] == nil {
					cache[name] = make([]string, 0)
				}

				cache[name] = append(cache[name], file.Name())
			}
		}
	}

	return cache, nil
}

// EnvVars extends the native orchestration methods of loading environment
// variables. One advantage is that this allows for both variable substitution
// in docker-compose.yml files as well as in service lifecycle scripts.

// Order of precedence for values:
// - .env
// -	'services: service: environment:'
// - 'x-blackbox: environment:'
func (app *App) EnvVars() map[string]string {

	output := parseEnVars(app.config.GetStringSlice("x-blackbox.environment"))

	// datadir, _ := app.DataDir()
	// output["DATA_DIR"] = datadir

	for _, service := range app.Services() {

		for k, v := range app.ServiceEnvVars(service) {
			output[k] = v
		}
	}

	// While Docker Compose loads .env by default,
	// we want to make the vars available to the scripts
	for k, v := range loadEnv() {
		output[k] = v
	}

	// app.log("debug", fmt.Sprintf("%#v", output))
	return output
}

func parseEnVars(vars []string) map[string]string {
	output := map[string]string{}
	if len(vars) == 0 {
		return output
	}

	for _, assignment := range vars {
		fmt.Println(assignment)
		pair := strings.Split(assignment, "=")
		output[pair[0]] = pair[1]
	}
	return output
}

func (app *App) ServiceEnvVars(service *service.Service) map[string]string {
	output := map[string]string{}

	if service == nil {
		return output
	}

	datadir, _ := app.DataDir()

	output[strings.ToUpper(service.Name)+"_DATA_DIR"] = filepath.Join(datadir, service.Name)
	for k, v := range service.Env {
		output[k] = v
	}

	return output
}

// Prestart runs the pre-start.sh script for all services if they exist
func (app *App) Prestart() error {
	// Add up all the services files
	for _, service := range app.Services() {
		Trace("info", fmt.Sprintf("Running prestart script for %s", service.Name))
		err := app.runScript(service, "prestart")
		if err != nil {
			return err
		}
	}
	return nil
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

func (app *App) runScript(service *service.Service, name string) error {
	script := fmt.Sprintf("%s.sh", name)
	Trace(fmt.Sprintf("Running '%s' for service: %s", name, service.Name))

	scriptpath := path.Join(service.Dir, "scripts", script)
	if _, err := os.Stat(scriptpath); os.IsNotExist(err) {
		Trace("error", fmt.Sprintf("%s %s not found", service.Name, script))
		return nil
	}

	err := RunSync(scriptpath, []string{}, app.EnvVars(), app.Debug)
	if err != nil {
		return err
	}
	// Trace("info", status.Stdout...)
	// if status.Exit == 1 {
	// 	Trace("error", status.Stderr...)
	// 	return fmt.Errorf("script error: [%s] %s", service.Name, name)
	// }

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
