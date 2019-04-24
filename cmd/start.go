package cmd

import (
	"fmt"

	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(startCmd)
}

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start [name]",
	Short: "Start your Blackbox app",
	Args:  cobra.MaximumNArgs(1),

	Run: func(cmd *cobra.Command, args []string) {
		name := "blackbox"
		if len(args) > 0 {
			name = args[0]
		}

		// When we start up, let's assure that we are in swarm mode
		client := blackbox.NewDockerClient(config)
		err := client.EnsureSwarmMode()
		if err != nil {
			fatal(err)
		}

		config.Prestart()

		log("info", fmt.Sprintf("Deploying stack '%s' ...", name))

		status := client.StackDeploy(name)
		if status.Exit != 0 {
			log("info", status.Stdout...)
			log("error", status.Stderr...)
			fatal(status.Error)
			return
		}

		log("info", status.Stdout...)
	},
}
