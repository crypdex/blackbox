package cmd

import (
	"fmt"
	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v2"
)

// versionCmd represents the version command
var infoCmd = &cobra.Command{
	Use:   "info",
	Short: "Displays the current configuration",
	Run: func(cmd *cobra.Command, args []string) {

		blackbox.Trace("info", "BLACKBOX app:")

		// fmt.Println("")
		// displayBlackboxInfo()
		// fmt.Println("")
		//
		// for k, v := range env.Env() {
		// 	fmt.Println(k, "=", v)
		// }
		// fmt.Println("")

		client := blackbox.NewDockerClient(app)
		err := client.ComposeConfig()
		if err != nil {
			fatal(err)
		}

		for name, service := range app.Services() {

			out, err := service.ConfigFileString()
			if err != nil {
				fatal(err)
			}

			blackbox.Trace("info", fmt.Sprintf("Config file for '%s'", name))
			blackbox.Trace("info", fmt.Sprintf("%s", service.ConfigPath()))

			fmt.Println(out)
		}

		// if status.Error != nil {
		// 	fatal(status.Error)
		// }
		//
		// fmt.Println(strings.Join(status.Stdout, "\n"))
		// fmt.Println(aurora.Red(strings.Join(status.Stderr, "\n")))
	},
}

func displayBlackboxInfo() {
	fmt.Println("version:", version)
	fmt.Println("commit:", commit)
	fmt.Println("date:", date)

	settings, _ := yaml.Marshal(viper.AllSettings())
	fmt.Println("config_file:", viper.ConfigFileUsed())
	fmt.Println("app:\n", string(settings))
}

func init() {
	rootCmd.AddCommand(infoCmd)
}
