package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(cleanupCmd)
}

// cleanupCmd represents the cleanup command
var cleanupCmd = &cobra.Command{
	Use:   "cleanup",
	Short: "Removes dead containers",

	Run: func(cmd *cobra.Command, args []string) {
		client := blackbox.NewDockerClient(config)
		status := client.Cleanup()

		log("info", status.Stdout...)
		// log("error", status.Stderr...)
	},
}
