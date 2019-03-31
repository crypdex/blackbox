package cmd

import (
	"fmt"

	yaml "gopkg.in/yaml.v2"

	"github.com/spf13/viper"

	shell "github.com/go-cmd/cmd"
	"github.com/spf13/cobra"
)

// versionCmd represents the version command
var infoCmd = &cobra.Command{
	Use:   "info",
	Short: "Displays the current configuration",
	Run: func(cmd *cobra.Command, args []string) {
		displayBlackboxInfo()

		// Start a long-running process, capture stdout and stderr
		c := shell.NewCmd("docker-compose", "config")

		s := <-c.Start()
		for _, out := range s.Stdout {
			fmt.Println(out)
		}

		for _, out := range s.Stderr {
			fmt.Println(out)
		}
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
