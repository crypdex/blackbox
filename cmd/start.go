package cmd

import (
	"fmt"
	"strings"

	"github.com/crypdex/blackbox/docker"
	"github.com/spf13/cobra"
)

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

		fmt.Printf("Deploying stack '%s' ...", name)
		status := client.StackDeploy(name)
		if status.Exit != 0 {
			fmt.Println(strings.Join(status.Stdout, "\n"))
			fmt.Println(strings.Join(status.Stderr, "\n"))
			fatal(status.Error)
			return
		}

		fmt.Println(strings.Join(status.Stdout, "\n"))
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
