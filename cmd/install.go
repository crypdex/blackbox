package cmd

import (
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(installCmd)
	installCmd.Flags().BoolP("force", "f", false, "Force the installation, overwrite any existing binaries")
}

// installCmd installs binaries for a given service
var installCmd = &cobra.Command{
	Use:   "install [service]",
	Short: "Install a service's binaries",
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		force := cmd.Flag("force")
		if err := config.Install(args[0], force.Value.String() != "false"); err != nil {
			fatal(err)
		}
	},
}
