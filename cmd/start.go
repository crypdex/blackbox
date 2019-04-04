package cmd

import (
	"fmt"
	"strings"

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

		if env.ForceSwarm() {
			fmt.Println("Found force_swarm setting.")
			isManager, err := client.IsSwarmManager()
			if err != nil {
				fatal(err)
			}
			if isManager {
				fmt.Println("Already a swarm manager, no need to force.")
			} else {
				fmt.Println("Forcing the Docker daemon into swarm mode.")
				status := client.SwarmLeave()
				fmt.Println(strings.Join(status.Stdout, "\n"))

				status = client.SwarmInit()
				if status.Exit == 0 {
					fmt.Println(status.Stdout[0])
				}
			}
		}

		env.Prestart()

		fmt.Println("Deploying stack ...")
		status := client.StackDeploy("blackbox")
		if status.Exit != 0 {
			fatal(status.Error)
			return
		}

		fmt.Println(strings.Join(status.Stdout, "\n"))
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
