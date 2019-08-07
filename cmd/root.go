package cmd

import (
	"fmt"
	"os"

	"github.com/crypdex/blackbox/cmd/blackbox"

	"github.com/spf13/cobra"
)

var debug bool
var quiet bool
var configFile string
var app *blackbox.App

// These variables are replaced by goreleaser
var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "blackboxd",
	Short: "A pluggable platform for multi-chain deployments",
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().StringVarP(&configFile, "app", "c", "", "app file (default is $HOME/.blackbox/blackbox.yml)")
	rootCmd.PersistentFlags().BoolVarP(&debug, "debug", "d", false, "debug is off by default")
	rootCmd.PersistentFlags().BoolVarP(&quiet, "quiet", "q", false, "quiet is off by default")
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
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

// initEnv reads in app file and ENV variables if set.
func initConfig() {
	var err error
	app, err = blackbox.NewApp(debug, configFile)
	// TODO: This is inelegant
	blackbox.Quiet = quiet
	if err != nil {
		fatal(err)
	}
}
