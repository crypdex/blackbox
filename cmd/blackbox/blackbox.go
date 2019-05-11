package blackbox

import (
	"fmt"
	"io/ioutil"
	logger "log"
	"os"
	"path"
	"path/filepath"

	"github.com/joho/godotenv"
	homedir "github.com/mitchellh/go-homedir"
	funk "github.com/thoas/go-funk"

	"github.com/logrusorgru/aurora"
	"github.com/spf13/viper"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

// getRecipe ...
func getRecipe(v *viper.Viper) string {
	legacy := v.GetString("recipe")
	if legacy != "" {
		return legacy
	}
	return v.GetString("x-blackbox.recipe")
}

// loadDefault attempts to load a default "blackbox.yaml" file
func loadDefault() *viper.Viper {
	v := viper.New()
	v.SetConfigName("blackbox")

	// Add search paths
	paths := configPaths()
	trace(fmt.Sprintf("[init] searching paths ... %s", paths))
	for _, path := range paths {
		v.AddConfigPath(path)
	}

	if err := v.ReadInConfig(); err == nil {
		trace(fmt.Sprintf("[init] ✓ blackbox file found: %s", v.ConfigFileUsed()))
	} else {
		trace("[init] ⨯ no blackbox file found", err.Error())
	}

	return v
}

func loadDotEnv() map[string]string {

	// Add search paths
	paths := configPaths()
	trace(fmt.Sprintf("[init] searching paths for .env ... %s", paths))

	var files []string
	for _, p := range paths {
		files = append(files, path.Join(p, ".env"))
	}

	env, _ := godotenv.Read(files...)

	return env
}

// configPaths is a slice of absolute paths, sorted in priority order, used as search roots
func configPaths() []string {
	// User space:
	// Get the executing user's home directory.
	pwd, err := os.Getwd()
	if err != nil {
		logger.Fatal(err)
	}

	home, err := homedir.Dir()
	if err != nil {
		logger.Fatal(err)
	}

	// A priority ordered slice
	return []string{
		pwd,
		filepath.Join(home, userspace),
		appspace,
	}
}

// registerServices returns a slice of all defined services found by searching the configPaths for "services" dirs
func registerServices() map[string]*Service {
	services := make(map[string]*Service)

	for _, path := range configPaths() {
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

	trace(fmt.Sprintf("[init] available services: %s", funk.Keys(services)))
	return services
}

func trace(args ...string) {
	for _, msg := range args {
		fmt.Println(aurora.Brown("✪ "), aurora.Green(msg))
	}
}

// getRecipeFile returns a full path to a service definition
func getRecipeFile(name string) (string, error) {
	// Given a name, look for a file
	for _, path := range configPaths() {
		recipePath := filepath.Join(path, "recipes", name+".yml")

		// Does the recipes directory exist in this path?
		if _, err := os.Stat(recipePath); os.IsNotExist(err) {
			continue
		}

		trace(fmt.Sprintf("[init] ✓ found recipe: %s", recipePath))
		return recipePath, nil
	}
	return "", fmt.Errorf("no recipe found named %s", name)
}
