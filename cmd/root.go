package cmd

import (
	"fmt"
	"io/ioutil"
	"os"

	"github.com/logrusorgru/aurora"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "blackbox",
	Short: "A pluggable platform for multi-chain deployments ",
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute(versioninfo ...string) {
	version, commit, date = versioninfo[0], versioninfo[1], versioninfo[2]
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.crypdex/blackbox.yaml)")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {

	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)

	} else {
		// Find home directory.
		home, err := homedir.Dir()
		fatal(err)

		// Pwd
		pwd, err := os.Getwd()
		fatal(err)

		// pwd is the first path we look in ...
		viper.AddConfigPath(pwd)

		configPath := home + "/.crypdex"
		viper.AddConfigPath(configPath)
		viper.Set("config_dir", configPath)

		viper.SetConfigName("blackbox")

		setServicesDir(pwd)
		viper.SetDefault("data_dir", home+"/.crypdex/data")
	}

	// ENV OVERRIDES ALL OTHER SETTINGS!
	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		// info(fmt.Sprintf("config file => %s", viper.ConfigFileUsed()))
	} else {
		fatal(err)
	}
}

func setServicesDir(pwd string) {
	// default services dir
	servicesDir := viper.GetString("config_dir") + "/services"

	// Does a services directory exist in the `pwd`?
	localDir := pwd + "/services"
	if _, err := os.Stat(localDir); !os.IsNotExist(err) {
		// directory exists
		servicesDir = localDir
	}

	viper.Set("services_dir", servicesDir)
}

func availableServices() (out []string, err error) {
	defer handle(&err)

	info, err := ioutil.ReadDir(viper.GetString("services_dir"))
	check(err)

	var services = make([]string, 0)
	for _, i := range info {
		if i.IsDir() {
			services = append(services, i.Name())
		}

	}
	return services, nil
}

func info(message string) {
	fmt.Println(aurora.BgBlack("[blackbox]"), message)
}
