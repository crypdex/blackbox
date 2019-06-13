package cmd

import (
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(execCommand)
}

// cleanupCmd represents the cleanup command
var execCommand = &cobra.Command{
	Use:   "exec",
	Short: "Run a wrapped binary",
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		if err := app.Exec(args[0], args[1:]); err != nil {
			fatal(err)
		}

		// log("error", status.Stderr...)
	},
}
