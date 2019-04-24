package system

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/logrusorgru/aurora"

	"github.com/mitchellh/go-homedir"

	"github.com/thoas/go-funk"

	"github.com/spf13/viper"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

// Config contains common variables and defaults used by blackbd
type Config struct {
	config      *viper.Viper
	Debug       bool
	ServicesDir string
	ForceSwarm  bool
	DataDir     string
	ConfigFile  string
}

// Overriding the configfile used should be done from outside this func
func NewConfig(debug bool) *Config {
	// Create an empty config
	v := viper.New()
	v.SetConfigName("blackbox")

	// Add search paths
	for _, approot := range ConfigPaths() {
		v.AddConfigPath(approot)
	}

	// ENV OVERRIDES ALL OTHER SETTINGS!
	v.AutomaticEnv()

	if err := v.ReadInConfig(); err == nil {
		fmt.Printf("config file => %s\n", v.ConfigFileUsed())
	} else {
		fmt.Println("no config file found")
	}

	// LEGACY SPECIAL SUPPORT
	if v.GetString("recipe") != "" {
		configFile := GetRecipePath(v.GetString("recipe"))
		v2 := viper.New()
		v2.SetConfigFile(configFile)
		v2.ReadInConfig()

		fmt.Println("")
		fmt.Println(configFile)
		fmt.Printf("%#v\n", v2.AllKeys())
		fmt.Println("")
		// f, err := os.Open(viper.GetString("recipes_dir") + "/" + viper.GetString("recipe") + ".yml")
		// if err != nil {
		// 	panic(err)
		// }
		//
		// err = viper.MergeConfig(bufio.NewReader(f))
		// if err != nil {
		// 	panic(err)
		// }

	}

	config := &Config{config: v,
		Debug:       debug,
		ConfigFile:  v.ConfigFileUsed(),
		ServicesDir: v.GetString("services_dir"),
		DataDir:     v.GetString("x-env.data_dir"),
		ForceSwarm:  v.GetBool("swarm"),
	}

	return config
}

// GetRecipePath returns a full path to a service definition
func GetRecipePath(name string) string {
	// Given a name, look for a file
	for _, path := range ConfigPaths() {
		recipesPath := filepath.Join(path, "recipes", name+".yml")

		// Does the recipes directory exist in this path?
		if _, err := os.Stat(recipesPath); os.IsNotExist(err) {
			continue
		}

		fmt.Println("found recipe:", aurora.Cyan(recipesPath))
		return recipesPath
		//
		// if _, err := os.Stat(recipesPath); os.IsNotExist(err) {
		// 	continue
		// }

	}
	return ""
}

type Service struct {
	Name        string
	FilePaths   []string
	Environment map[string]interface{}
}

func (service *Service) DockerComposePaths() []string {
	var paths []string
	for _, path := range service.FilePaths {
		paths = append(paths, fmt.Sprintf("%s/docker-compose.yml", path))
	}
	return paths
}

// RegisteredServices returns a slice of all defined service names
// that are found by searching the approots for "services" dir
func (env *Config) RegisteredServices() map[string]*Service {
	services := make(map[string]*Service)

	for _, path := range ConfigPaths() {
		servicesPath := filepath.Join(path, "services")

		// Does the services directory exist in this path?
		if _, err := os.Stat(servicesPath); os.IsNotExist(err) {
			continue
		}

		entries, _ := ioutil.ReadDir(servicesPath)
		for _, entry := range entries {
			if !entry.IsDir() {
				continue
			}

			name := entry.Name()
			servicePath := filepath.Join(path, "services", name)
			service, ok := services[name]
			if !ok {
				services[name] = &Service{Name: name, FilePaths: []string{servicePath}}
				continue
			}

			service.FilePaths = append(service.FilePaths, servicePath)
		}
	}

	fmt.Println(aurora.Green("Available services:"), funk.Keys(services))
	return services
}

// Services are those defined in the root blackbox.yml file
//
func (env *Config) Services() map[string]*Service {
	available := env.RegisteredServices()
	services := make(map[string]*Service)

	for key, _ := range env.config.GetStringMap("services") {
		service, ok := available[key]
		if !ok {
			fmt.Println(aurora.Red("WARN: no registered service:"), key)
			continue
		}
		services[key] = service

		envvars := env.config.GetStringMap(fmt.Sprintf("services.%s.x-env", key))
		service.Environment = envvars
		fmt.Println(service)
	}
	fmt.Println(aurora.Green("Configured services:"), funk.Keys(services))
	return services
}

func (env *Config) GetService(name string) *Service {
	services := env.Services()
	if service, ok := services[name]; ok {
		return service
	}
	return nil
}

func ConfigPaths() []string {
	// User space:
	// Get the executing user's home directory.
	pwd, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}

	home, err := homedir.Dir()
	if err != nil {
		log.Fatal(err)
	}

	// A priority ordered slice
	paths := []string{
		pwd,
		filepath.Join(home, userspace),
		appspace,
	}

	return paths
}

// ----------------
// ----------------
// ----------------
// ----------------

func (env *Config) Environment() map[string]string {
	output := map[string]string{
		"DATA_DIR": env.DataDir,
	}

	for _, service := range env.Services() {
		e := env.ServiceEnvironment(service)
		for k, v := range e {
			output[k] = v
		}
	}

	return output
}

func (env *Config) ServiceEnvironment(service *Service) map[string]string {
	// This is a map so that we can override
	output := make(map[string]string)

	name := strings.ToUpper(service.Name)
	// Add defined environment variables
	for k, v := range service.Environment {
		output[name+"_"+strings.ToUpper(k)] = v.(string)
	}
	output[name+"_DATA_DIR"] = filepath.Join(env.DataDir, service.Name)

	return output
}

// ServiceNames returns a slice of all defined service names
func (env *Config) ServiceNames() []string {
	services := env.config.GetStringMap("services")
	if services == nil {
		return []string{}
	}
	return funk.Keys(services).([]string)
}

// Prestart runs the pre-start.sh script for all services if they exist
func (env *Config) Prestart() {
	fmt.Println("Running prestart for", env.ServiceNames())
	// Add up all the services files
	for _, service := range env.Services() {
		err := env.PrestartService(service)
		if err != nil {
			fmt.Println(err)
		}
	}
}

func (env *Config) PrestartService(service *Service) error {
	fmt.Println(fmt.Sprintf("Running pre-start for %s", service))
	path, err := env.PrestartScript(service)
	if err != nil {
		return err
	}
	ExecCommand("bash", []string{"-c", path}, env.ServiceEnvironment(service), env.Debug)
	return nil
}

func (env *Config) PrestartScript(service *Service) (string, error) {
	path := fmt.Sprintf("%s/%s/pre-start.sh", env.ServicesDir, service.Name)

	if _, err := os.Stat(path); os.IsNotExist(err) {
		return "", fmt.Errorf("%s pre-start.sh not found", service.Name)
	}

	return path, nil
}
