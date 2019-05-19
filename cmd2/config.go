package cmd2

import (
	"github.com/spf13/cobra"
)

// configCmd represents the config command
var configCmd = &cobra.Command{
	Use:   "config",
	Short: "Show the Docker Compose config",
	Run: func(cmd *cobra.Command, args []string) {
		loadDotEnv()
		loadConfig(configFile)
	},
}

func init() {
	rootCmd.AddCommand(configCmd)
}
