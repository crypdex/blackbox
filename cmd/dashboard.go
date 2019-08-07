package cmd

import (
	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
	"path"
)

func init() {
	rootCmd.AddCommand(dashboardCmd)
}

// This command is really just a wrapper around bash scripts
// The reason it is here, it to unify access to the scripts
var dashboardCmd = &cobra.Command{
	Use:   "dashboard",
	Short: "Show the BlackboxOS dashboard",
	Run: func(cmd *cobra.Command, args []string) {

		scriptsDir, err := blackbox.ScriptsDir()
		if err != nil {
			fatal(err)
		}

		command := "watch"
		commandargs := []string{
			"-c",
			"-t",
			path.Join(scriptsDir, "dashboard/start.sh"),
		}
		err = blackbox.RunSync(command, commandargs, nil, false)
		if err != nil {
			fatal(err)
		}
	},
}
