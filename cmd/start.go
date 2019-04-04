package cmd

import (
	"fmt"

	"github.com/crypdex/blackbox/docker"
	"github.com/spf13/cobra"
)

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Start your Blackbox app",
	Run: func(cmd *cobra.Command, args []string) {
		// When we start up, let's assure that we are in swarm mode
		client := docker.NewClient(env)

		env.Prestart()

		fmt.Println("Ensuring that the Docker daemon is in swarm mode ...")
		client.SwarmInit()
		status := client.StackDeploy("blackbox")
		if status.Exit != 0 {
			fatal(status.Error)
		}
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
