package cmd

import (
	"github.com/crypdex/blackbox/docker"
	"github.com/crypdex/blackbox/system"
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

		system.PrintInfo("Ensuring that the Docker daemon is in swarm mode ...")
		client.SwarmInit()
		client.StackDeploy("blackbox")
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
