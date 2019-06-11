package cmd

import (
	"github.com/spf13/cobra"
)

// resetCmd represents the reset command
var resetCmd = &cobra.Command{
	Use:   "reset",
	Short: "Reset sensitive data",
	Run: func(cmd *cobra.Command, args []string) {
		app.Reset()
	},
}

func init() {
	rootCmd.AddCommand(resetCmd)
}
