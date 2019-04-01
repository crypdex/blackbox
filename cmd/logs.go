package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// logsCmd represents the log command
var logsCmd = &cobra.Command{
	Use:   "logs",
	Short: "A brief description of your command",

	Run: func(cmd *cobra.Command, args []string) {
		config := dockerComposeLogs()
		fmt.Println(config)
	},
}

func init() {
	rootCmd.AddCommand(logsCmd)
}
