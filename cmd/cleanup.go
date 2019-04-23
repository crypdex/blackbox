package cmd

import (
	"github.com/crypdex/blackbox/cmd/docker"
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
		client := docker.NewClient(env)
		client.Cleanup()
	},
}
