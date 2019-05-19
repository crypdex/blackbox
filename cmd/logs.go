package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(logsCmd)
}

// cleanupCmd represents the cleanup command
var logsCmd = &cobra.Command{
	Use:   "logs",
	Short: "Show the logs of all running containers",

	Run: func(cmd *cobra.Command, args []string) {
		client := blackbox.NewDockerClient(config)

		client.ComposeLogs()

		// log("error", status.Stderr...)
	},
}
