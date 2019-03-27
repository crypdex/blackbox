package config

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strings"

	"github.com/logrusorgru/aurora"
	"github.com/spf13/viper"
	funk "github.com/thoas/go-funk"
)

var defaultPort = "8888"

var supportedChains = map[string]bool{
	"pivx":  true,
	"zcoin": true,
}

// or through Decode
type Config struct {
	*viper.Viper
	file string
}

func Load(file string) (*Config, error) {
	config := Config{Viper: viper.New(), file: file}
	config.SetConfigType("properties")
	config.SetConfigFile(file)
	err := config.ReadInConfig()
	return &config, err
}

func (c *Config) Port() string {
	port := c.GetString("port")
	if port == "" {
		return defaultPort
	}
	return port
}

func (c *Config) Chains() []string {
	output := make([]string, 0)
	fmt.Println(len(c.GetStringSlice("chains")))

	if c.GetString("chains") == "" {
		fmt.Println(aurora.Brown("[WARNING] no chains are configured\n'chains' is a space separated list"))
		return output
	}

	for _, chain := range strings.Split(c.GetString("chains"), " ") {
		if !isSupportedChain(chain) {
			fmt.Println(aurora.Brown("[WARNING] unsupported chain:"), chain)
			continue
		} else {
			output = append(output, chain)
		}
	}
	return output
}

func (c *Config) AddChain(chain string) error {
	if !isSupportedChain(chain) {
		return fmt.Errorf("unsupported chain %s", chain)
	}

	configured := c.GetStringSlice("chains")

	if funk.ContainsString(configured, chain) {
		fmt.Println("already configured", chain)
	} else {
		configured = append(configured, chain)
	}

	fmt.Println("adding chain", chain)
	c.Set("chains", strings.Join(configured, " "))

	output := make(map[string]string)
	for _, key := range c.AllKeys() {
		output[key] = c.GetString(key)
	}

	return c.Save()

}

func (c *Config) Save() error {
	output, err := c.Marshal()
	if err != nil {
		return err
	}
	return ioutil.WriteFile(c.file, []byte(output), 0644)
}

func (c *Config) Marshal() (string, error) {
	lines := make([]string, 0, len(c.AllSettings()))
	for k, v := range c.AllSettings() {
		lines = append(lines, fmt.Sprintf(`%s=%s`, strings.ToUpper(k), v))
	}
	sort.Strings(lines)
	return strings.Join(lines, "\n"), nil
}

func isSupportedChain(chain string) bool {
	if _, ok := supportedChains[chain]; !ok {
		return false
	}
	return true
}
