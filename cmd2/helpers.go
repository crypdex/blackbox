package cmd2

import (
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"

	"github.com/joho/godotenv"
	"github.com/logrusorgru/aurora"
	"github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

// Application space
var appspace = "/var/lib/blackbox"

// User space
var userspace = ".blackbox"

// A slice of absolute paths, sorted in priority order, used as search roots
func searchPaths() []string {
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
	return []string{
		pwd,
		filepath.Join(home, userspace),
		appspace,
	}
}

func loadConfig(configFile string) *viper.Viper {
	// Create an empty config
	var v *viper.Viper

	if configFile == "" {
		v = loadDefaultConfig()
	} else {
		trace("info", fmt.Sprintf("Loading specified config: %s", configFile))
		v = viper.New()
		v.SetConfigFile(configFile)
		if err := v.ReadInConfig(); err != nil {
			trace("fatal", err.Error())
		}

	}

	return v
}

// loadDefault attempts to load a default "blackbox.yaml" file
func loadDefaultConfig() *viper.Viper {

	v := viper.New()
	v.SetConfigName("blackbox")

	for _, p := range searchPaths() {
		v.AddConfigPath(p)
	}

	if err := v.ReadInConfig(); err == nil {
		trace("info", fmt.Sprintf("[init] ✓ blackbox file found: %s", v.ConfigFileUsed()))
	} else {
		trace("error", "[init] ⨯ no blackbox file found", err.Error())
	}

	return v
}

func loadDotEnv() map[string]string {

	var files []string
	for _, p := range searchPaths() {
		file := path.Join(p, ".env")
		//  godotenv is not kind to files that dont exist ...
		if _, err := os.Stat(file); !os.IsNotExist(err) {
			files = append(files, file)
		}
	}

	if len(files) != 0 {
		trace("info", fmt.Sprintf("Found .env: %s", files))
	} else {
		trace("info", "no .env found ")
	}

	env, err := godotenv.Read(files...)
	if err != nil {
		fmt.Println(err)
	}

	return env
}

// getRecipe ...
func getRecipe(v *viper.Viper) string {
	legacy := v.GetString("recipe")
	if legacy != "" {
		return legacy
	}
	return v.GetString("x-blackbox.recipe")
}

// getRecipeFile returns a full path to a service definition
func getRecipeFile(name string) (string, error) {
	// Given a name, look for a file
	for _, path := range searchPaths() {
		recipePath := filepath.Join(path, "recipes", name+".yml")

		// Does the recipes directory exist in this path?
		if _, err := os.Stat(recipePath); os.IsNotExist(err) {
			continue
		}

		trace("info", fmt.Sprintf("✓ found recipe: %s", recipePath))
		return recipePath, nil
	}
	return "", fmt.Errorf("no recipe found named %s", name)
}

func trace(level string, args ...string) {
	if len(args) == 0 {
		fmt.Println(aurora.Brown("✪ "), aurora.Green(level))
		return
	}

	for _, msg := range args {
		switch level {

		case "error":
			fmt.Println(aurora.Brown("✪ "), aurora.Red(msg))
		default:
			fmt.Println(aurora.Brown("✪ "), aurora.Green(msg))
		}
	}
}
