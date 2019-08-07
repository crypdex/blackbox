package cmd

import (
	"encoding/json"
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

		services := app.Services()

		j, _ := json.MarshalIndent(services, "", "  ")

		fmt.Println(string(j))

		// fmt.Println("")
		// displayBlackboxInfo()
		// fmt.Println("")
		//
		// for k, v := range env.Env() {
		// 	fmt.Println(k, "=", v)
		// }
		// fmt.Println("")

		// client := blackbox.NewDockerClient(app)
		// err := client.ComposeConfig()
		// if err != nil {
		// 	fatal(err)
		// }

		// for _, service := range app.Services() {
		// 	configs, err := service.CompiledConfigs()
		// 	if err != nil {
		// 		fatal(err)
		// 	}
		//
		// 	for k, config := range configs {
		// 		blackbox.Trace("info", k)
		// 		fmt.Println(config)
		// 	}
		//
		// }

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
