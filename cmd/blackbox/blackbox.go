package blackbox

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/logrusorgru/aurora"
	"github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
	"github.com/thoas/go-funk"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

// Blackbox contains common variables and defaults used by blackboxd
type Blackbox struct {
	config             *viper.Viper
	Debug              bool
	ForceSwarm         bool
	ServicesDir        string
	DataDir            string
	RegisteredServices map[string]*Service
}

// New ...
// Overriding the configfile used should be done from outside this func
func New(debug bool) *Blackbox {
	// Create an empty config
	v := loadDefault()

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

	config := &Blackbox{config: v,
		Debug:              debug,
		ServicesDir:        v.GetString("services_dir"),
		DataDir:            v.GetString("x-env.data_dir"),
		ForceSwarm:         v.GetBool("swarm"),
		RegisteredServices: registerServices(),
	}

	return config
}

func loadDefault() *viper.Viper {
	trace("loading default config ...")
	v := viper.New()
	v.SetConfigName("blackbox")

	// Add search paths
	paths := ConfigPaths()
	trace(fmt.Sprintf("searching for config in %s", paths))
	for _, path := range paths {
		v.AddConfigPath(path)
	}

	if err := v.ReadInConfig(); err == nil {
		trace(fmt.Sprintf("✓ config file found: '%s'\n", v.ConfigFileUsed()))
	} else {
		trace("⨯ no config file found", err.Error())
	}

	return v
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

// RegisteredServices returns a slice of all defined service names
// that are found by searching the approots for "services" dir
func registerServices() map[string]*Service {
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

	trace(fmt.Sprintf("available services: %s", funk.Keys(services)))
	return services
}

// Services are those defined in the root blackbox.yml file
//
func (b *Blackbox) Services() map[string]*Service {
	available := registerServices()
	services := make(map[string]*Service)

	for key, _ := range b.config.GetStringMap("services") {
		service, ok := available[key]
		if !ok {
			fmt.Println(aurora.Red("WARN: no registered service:"), key)
			continue
		}
		services[key] = service

		envvars := b.config.GetStringMap(fmt.Sprintf("services.%s.x-env", key))
		service.Environment = envvars
		fmt.Println(service)
	}
	fmt.Println(aurora.Green("Configured services:"), funk.Keys(services))
	return services
}

func trace(args ...string) {
	for _, msg := range args {
		fmt.Println(aurora.Brown("⊙"), aurora.Green(msg))
	}
}
