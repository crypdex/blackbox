package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	yaml "gopkg.in/yaml.v2"
)

type InitConfig struct {
	Recipe   string                 `yaml:"recipe,omitempty"`
	Services map[string]interface{} `yaml:"services,omitempty"`
}

// initCmd represents the init command
var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initializes a device to run the BlackboxOS",
	Run: func(cmd *cobra.Command, args []string) {
		config := new(InitConfig)

		recipe := cmd.Flag("recipe").Value.String()
		if recipe != "" {
			recipeFile := env.RecipesDir() + "/" + recipe + ".yml"
			if _, err := os.Stat(recipeFile); os.IsNotExist(err) {
				fatal(fmt.Errorf("%s does not exist (yet)", recipe))
			} else {
				config.Recipe = recipe
			}
		}

		configfile := env.ConfigDir() + "/blackbox.yaml"
		if _, err := os.Stat(configfile); !os.IsNotExist(err) {
			// directory exists
			fmt.Println("A config already exists at", configfile)
			return
		}

		fmt.Println("Creating config at", configfile)

		y, err := yaml.Marshal(config)
		if err != nil {
			fmt.Println(err)
		}
		fmt.Println(string(y))
	},
}

func init() {
	rootCmd.AddCommand(initCmd)
	initCmd.Flags().StringP("recipe", "r", "", "Define a pre-existing recipe")
}
