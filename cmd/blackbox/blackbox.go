package blackbox

import (
	"fmt"
	"github.com/crypdex/blackbox/cmd/service"
	"io/ioutil"
	logger "log"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/pkg/errors"

	"github.com/joho/godotenv"
	homedir "github.com/mitchellh/go-homedir"

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
func loadDefault() (*viper.Viper, error) {
	v := viper.New()
	v.SetConfigName("blackbox")

	// Add search paths
	paths := configPaths()
	for _, p := range paths {
		v.AddConfigPath(p)
	}

	if err := v.ReadInConfig(); err != nil {
		Trace("error", "error: BlackboxOS config could not be loaded")
		return nil, err
	}

	return v, nil
}

// loadEnv loads a .env file. This should be modified to only current working directory/
func loadEnv() map[string]string {

	// Add search paths
	paths := configPaths()
	// Trace(fmt.Sprintf("Searching paths for .env ... %s", paths))

	var files []string
	for _, p := range paths {
		file := path.Join(p, ".env")
		//  godotenv is not kind to files that dont exist ...
		if _, err := os.Stat(file); !os.IsNotExist(err) {
			files = append(files, file)
		}
	}

	if len(files) != 0 {
		// Trace(fmt.Sprintf("Found .env %s", files))
	} else {
		Trace("info", "warning: no '.env' file found")
		return nil
	}

	err := godotenv.Load(files...)
	if err != nil {
		// fmt.Println(err)
	}

	env, err := godotenv.Read(files...)
	if err != nil {
		// fmt.Println(err)
	}

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

// registerServices returns a map of all defined services found by searching the configPaths for "services" dirs
func registerServices() map[string]*service.Service {
	services := make(map[string]*service.Service)

	for _, path := range configPaths() {
		servicesPath := filepath.Join(path, "services")

		// Does the services directory exist in this path?
		entries, err := ioutil.ReadDir(servicesPath)
		if err != nil {

			continue
		}
		// Trace("debug", fmt.Sprintf("Registering services in %s", servicesPath))

		// Trace("debug", fmt.Sprintf("Registering services in %s", servicesPath))
		for _, entry := range entries {
			if !entry.IsDir() {
				continue
			}
			servicePath := filepath.Join(servicesPath, entry.Name())
			service, err := service.FromDir(servicePath, environmentMap())
			if err != nil {
				Trace("error", errors.Wrap(err, "cannot load service").Error())
				continue
			}

			services[service.Name] = service
		}

	}

	return services
}

func environmentMap() map[string]interface{} {
	params := make(map[string]interface{})
	for _, v := range os.Environ() {
		parts := strings.Split(v, "=")
		params[parts[0]] = parts[1]
	}
	return params
}

// Trace gives us nice wrapped output
func Trace(level string, args ...string) {
	if Quiet {
		return
	}
	for _, msg := range args {
		switch level {
		case "error":
			fmt.Printf("%s %s\n", aurora.Brown("❯"), aurora.Red(msg))
		case "debug":
			fmt.Println(aurora.Brown("❯"), aurora.Cyan(msg))
		default:
			fmt.Printf("%s %s\n", aurora.Brown("❯"), aurora.Green(msg))
		}
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

		Trace(fmt.Sprintf("Found recipe: %s", recipePath))
		return recipePath, nil
	}
	return "", fmt.Errorf("No recipe found named %s", name)
}

// ScriptsDir returns the directory to the scripts which is either in the pwd (useful for development)
// or its in the install location.
func ScriptsDir() (string, error) {
	pwd, err := os.Getwd()
	if err != nil {
		return "", err
	}
	// "scripts" dir exists in `pwd`
	if _, err := os.Stat(path.Join(pwd, "scripts")); !os.IsNotExist(err) {
		return path.Join(pwd, "scripts"), nil
	}

	// This depends upon where it is installed.
	// On linux its "appspace", but maybe not so on mac/windows
	if _, err := os.Stat(path.Join(appspace, "scripts")); !os.IsNotExist(err) {
		return path.Join(appspace, "scripts"), nil
	}

	return "", errors.New("could not find a valid dir for scripts")
}
