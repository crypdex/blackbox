package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"

	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(stopCmd)
}

// stopCmd represents the stop command
var stopCmd = &cobra.Command{
	Use:   "stop",
	Short: "Stop your Blackbox and all related services",
	Args:  cobra.MaximumNArgs(1),

	Run: func(cmd *cobra.Command, args []string) {
		// name := "blackbox"
		// if len(args) > 0 {
		// 	name = args[0]
		// }

		client := blackbox.NewDockerClient(config)
		client.ComposeDown()
		// status := client.StackRemove(name)
		// if status.Error != nil {
		// 	fatal(status.Error)
		// }
		//
		// log("info", status.Stdout...)
		// log("error", status.Stderr...)
	},
}
