package cmd

import (
	"fmt"
	"strings"

	"github.com/crypdex/blackbox/cmd/docker"
	"github.com/spf13/cobra"
)

// stopCmd represents the stop command
var stopCmd = &cobra.Command{
	Use:   "stop",
	Short: "Stop your Blackbox and all related services",

	Run: func(cmd *cobra.Command, args []string) {
		client := docker.NewClient(env)
		status := client.StackRemove("blackbox")
		if status.Error != nil {
			fatal(status.Error)
		}
		fmt.Println(strings.Join(status.Stdout, "\n"))
	},
}

func init() {
	rootCmd.AddCommand(stopCmd)
}
