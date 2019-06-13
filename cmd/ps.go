package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"

	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(psCmd)
}

// stopCmd represents the stop command
var psCmd = &cobra.Command{
	Use:   "ps",
	Short: "Show Docker processes",

	Run: func(cmd *cobra.Command, args []string) {
		client := blackbox.NewDockerClient(app)
		client.ComposePs(nil)
	},
}
