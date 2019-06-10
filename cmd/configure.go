package cmd

import (
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(configureCmd)
}

var configureCmd = &cobra.Command{
	Use:   "configure",
	Short: "Write configuration files",

	Run: func(cmd *cobra.Command, args []string) {
		err := config.Configure()
		if err != nil {
			fatal(err)
		}

	},
}
