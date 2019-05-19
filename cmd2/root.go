package cmd2

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

// These variables are replaced by goreleaser
var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

var debug bool
var configFile string
var app *App

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "blackboxd",
	Short: "An ARM-first pluggable platform for multi-chain deployments",
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute(versioninfo ...string) {
	// See main.go for how this is called
	if len(versioninfo) == 3 {
		version, commit, date = versioninfo[0], versioninfo[1], versioninfo[2]
	}

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initApp)
	rootCmd.PersistentFlags().StringVarP(&configFile, "config", "c", "", "config file (default is $HOME/.blackbox/blackbox.yml)")
	rootCmd.PersistentFlags().BoolVarP(&debug, "debug", "d", false, "debug is off by default")
}

func initApp() {
	app = NewApp(debug, configFile)
}
