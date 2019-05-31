package cmd

import (
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(removeCmd)
}

// removeCmd removes binaries for a given service
var removeCmd = &cobra.Command{
	Use:   "remove [service]",
	Short: "Remove a service's binaries",
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		if err := config.Remove(args[0]); err != nil {
			fatal(err)
		}
	},
}
