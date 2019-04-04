package cmd

import (
	"github.com/crypdex/blackbox/docker"
	"github.com/spf13/cobra"
)

// stopCmd represents the stop command
var stopCmd = &cobra.Command{
	Use:   "stop",
	Short: "Stop your Blackbox and all related services",

	Run: func(cmd *cobra.Command, args []string) {
		client := docker.NewClient(env)
		client.StackRemove("blackbox")
	},
}

func init() {
	rootCmd.AddCommand(stopCmd)
}
