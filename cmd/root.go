package cmd

import (
	"bufio"
	"fmt"
	"os"

	"github.com/crypdex/blackbox/system"
	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string
var env *system.Env
var debug bool

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

	rootCmd.PersistentFlags().BoolVarP(&debug, "debug", "d", false, "debug is off by default")

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

		// SERVICES_DIR
		setServicesDir(pwd)
		setRecipesDir(pwd)
		// DATA_DIR
		setDataDir(home)
	}

	// ENV OVERRIDES ALL OTHER SETTINGS!
	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		// info(fmt.Sprintf("config file => %s", viper.ConfigFileUsed()))
	} else {
		fmt.Println("no config file found")
		// fatal(errors.Wrap(err, "could not load a config"))
	}

	if viper.GetString("recipe") != "" {
		f, err := os.Open(viper.GetString("recipes_dir") + "/" + viper.GetString("recipe") + ".yml")
		if err != nil {
			fatal(err)
		}

		err = viper.MergeConfig(bufio.NewReader(f))
		if err != nil {
			fatal(err)
		}
	}

	checkDataDir()
	// Set the global env
	env = system.NewEnv(viper.GetViper(), debug)
}

func setDataDir(home string) {
	viper.SetDefault("data_dir", home+"/.crypdex/data")
}

func checkDataDir() {
	dir := viper.GetString("data_dir")
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		fmt.Println("WARN: data_dir", dir, "does not exist")
		system.ExecCommand("mkdir", []string{"-p", dir}, nil, true)
	}
}

func setDir(pwd, name string) {
	key := name + "_dir"
	// Is the services_dir explicityly set? If so, dont set
	if viper.GetString(key) != "" {
		return
	}

	// default services dir LINUX
	dir := "/var/lib/blackbox/" + name

	// Does a services directory exist in the config?
	configDir := viper.GetString("config_dir") + "/" + name
	if _, err := os.Stat(configDir); !os.IsNotExist(err) {
		dir = configDir
	}

	// Does a services directory exist in the `pwd`?
	localDir := pwd + "/" + name
	if _, err := os.Stat(localDir); !os.IsNotExist(err) {
		// directory exists
		dir = localDir
	}

	viper.Set(key, dir)
}

func setServicesDir(pwd string) {
	setDir(pwd, "services")
}

func setRecipesDir(pwd string) {
	setDir(pwd, "recipes")
}
