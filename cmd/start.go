package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/crypdex/blackbox/docker"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Start your Blackbox app",
	Run: func(cmd *cobra.Command, args []string) {
		// When we start up, let's assure that we are in swarm mode
		client := docker.NewClient(viper.GetViper())
		info("Ensuring that the Docker daemon is in swarm mode ...")
		prestart()
		client.SwarmInit()
		client.StackDeploy("blackbox")
	},
}

// prestart needs to
// - get all services
// - for each service, is there a pre-start.sh script
// - if so, execute it
func prestart() {
	services := viper.GetStringMap("services")

	// Add up all the services files
	for service := range services {

		path := fmt.Sprintf("%s/%s/pre-start.sh", viper.GetString("services_dir"), service)

		if _, err := os.Stat(path); !os.IsNotExist(err) {
			info(fmt.Sprintf("calling pre-start script for %s => %s", service, path))
			env := GetServiceEnv(service, map[string]string{
				"DATA_DIR": viper.GetString("data_dir"),
			})
			docker.ExecCommand("bash", []string{"-c", path}, env)
		}

	}
}

func init() {
	rootCmd.AddCommand(startCmd)
}

func envPrefix(prefix string) string {
	return strings.ToUpper(prefix) + "_"
}

func GetServiceEnv(service string, globals map[string]string) map[string]string {
	// This is a map so that we can override
	env := make(map[string]string)
	// Default DATA_DIR namespaced for each service
	env[envPrefix(service)+"DATA_DIR"] = globals["DATA_DIR"] + "/" + service

	for key, value := range viper.GetStringMap("services." + service) {
		env[envPrefix(service)+strings.ToUpper(key)] = value.(string)
	}
	return env
}
