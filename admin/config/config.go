package config

import (
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"sort"
	"strings"

	"github.com/spf13/viper"
	"github.com/thoas/go-funk"
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
	cfg := Config{Viper: viper.New(), file: file}

	if _, err := os.Stat(file); os.IsNotExist(err) {
		fmt.Println(file, "does not exist")
		return &cfg, nil
	}

	tmp := viper.New()
	tmp.SetConfigType("properties")
	tmp.SetConfigFile(file)

	err := tmp.ReadInConfig()

	cfg.Set("chains", strings.Split(tmp.GetString("chains"), " "))

	fmt.Println("successfully loaded config =>", cfg.AllSettings())
	return &cfg, err
}

func (c *Config) SetChains(chains ...string) error {
	output := make([]string, 0)

	for _, chain := range chains {
		if !isSupportedChain(chain) {
			return fmt.Errorf("unsupported chain %s", chain)
		}

		if !funk.ContainsString(output, chain) {
			fmt.Println("adding chain", chain)
			output = append(output, chain)
		}
	}

	c.Set("chains", output)

	return c.Save()

}

func (c *Config) Save() error {
	output, err := c.Marshal()
	if err != nil {
		return err
	}

	_, err = os.OpenFile(c.file, os.O_CREATE|os.O_RDWR, 0644)
	if err != nil {
		return err
	}

	err = ioutil.WriteFile(c.file, []byte(output), 0644)
	if err != nil {
		return err
	}

	return nil
}

func (c *Config) Marshal() (string, error) {
	lines := make([]string, 0, len(c.AllSettings()))
	for k, v := range c.AllSettings() {
		if reflect.TypeOf(v).String() == "[]string" {
			v = strings.Join(c.GetStringSlice(k), " ")
		}
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
