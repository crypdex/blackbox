package cmd

import (
	"fmt"

	"github.com/crypdex/blackbox/docker"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	yaml "gopkg.in/yaml.v2"
)

// versionCmd represents the version command
var infoCmd = &cobra.Command{
	Use:   "info",
	Short: "Displays the current configuration",
	Run: func(cmd *cobra.Command, args []string) {
		displayBlackboxInfo()
		client := docker.NewClient(viper.GetViper())
		client.ComposeConfig()
	},
}

func displayBlackboxInfo() {
	fmt.Println("version:", version)
	fmt.Println("commit:", commit)
	fmt.Println("date:", date)

	settings, _ := yaml.Marshal(viper.AllSettings())
	fmt.Println("config_file:", viper.ConfigFileUsed())
	fmt.Println(string(settings))
}

func init() {
	rootCmd.AddCommand(infoCmd)
}
