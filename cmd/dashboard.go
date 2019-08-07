package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
	"path"
)

func init() {
	rootCmd.AddCommand(dashboardCmd)
}

var dashboardCmd = &cobra.Command{
	Use:   "dashboard",
	Short: "Show the BlackboxOS dashboard",

	Run: func(cmd *cobra.Command, args []string) {
		scriptsDir, err := blackbox.ScriptsDir()
		if err != nil {
			fatal(err)
		}

		cmdargs := []string{
			"-c",
			"-t",
			path.Join(scriptsDir, "dashboard/start.sh"),
		}
		err = blackbox.RunSync("watch", cmdargs, nil, false)
		if err != nil {
			fatal(err)
		}
	},
}
