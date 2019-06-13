package cmd

import (
	"fmt"
	"strings"

	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(binCmd)
	binCmd.AddCommand(removeCmd)
	binCmd.AddCommand(installCmd)
	binCmd.AddCommand(listCmd)
	installCmd.Flags().BoolP("force", "f", false, "Force the installation, overwrite any existing binaries")
}

// removeCmd removes binaries for a given service
var binCmd = &cobra.Command{
	Use:   "bin [command]",
	Short: "Commands for binary wrappers",
}

// installCmd installs binaries for a given service
var installCmd = &cobra.Command{
	Use:   "install [bin]",
	Short: "Install a binary wrapper",
	Args:  cobra.MinimumNArgs(1),

	Run: func(cmd *cobra.Command, args []string) {
		force := cmd.Flag("force")
		if err := app.Install(args[0], force.Value.String() != "false"); err != nil {
			fatal(err)
		}
	},
}

// listCmd shows all available binaries
var listCmd = &cobra.Command{
	Use:   "list",
	Short: "List known binary wrappers",

	Run: func(cmd *cobra.Command, args []string) {
		binmap, err := app.ListBinaryWrappers()
		if err != nil {
			fatal(err)
		}

		for _, bins := range binmap {
			blackbox.Trace("info", fmt.Sprintf("%s", strings.Join(bins, ", ")))
		}
	},
}

// removeCmd removes binaries for a given service
var removeCmd = &cobra.Command{
	Use:   "remove [binary]",
	Short: "Remove a binary wrapper",
	Args:  cobra.MinimumNArgs(1),

	Run: func(cmd *cobra.Command, args []string) {
		if err := app.Remove(args[0]); err != nil {
			fatal(err)
		}
	},
}
