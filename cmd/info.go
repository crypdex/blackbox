package cmd

import (
	"fmt"

	yaml "gopkg.in/yaml.v2"

	"github.com/crypdex/blackbox/docker"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// versionCmd represents the version command
var infoCmd = &cobra.Command{
	Use:   "info",
	Short: "Displays the current configuration",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("")
		displayBlackboxInfo()
		fmt.Println("")
		for k, v := range env.Environment() {
			fmt.Println(k, "=", v)
		}
		fmt.Println("")
		client := docker.NewClient(env)
		client.ComposeConfig()
	},
}

func displayBlackboxInfo() {
	fmt.Println("version:", version)
	fmt.Println("commit:", commit)
	fmt.Println("date:", date)

	settings, _ := yaml.Marshal(viper.AllSettings())
	fmt.Println("config_file:", viper.ConfigFileUsed())
	fmt.Println("config:\n", string(settings))
}

func init() {
	rootCmd.AddCommand(infoCmd)
}
