package service

import (
	"bytes"
	"errors"
	"io"
	"os"
	"path"
	"text/template"
)

// Config encapsulates a service's config file
type Config struct {
	Filename string                 `yaml:"filename"` // Name of the compiled output file
	Template string                 `yaml:"template"` // Full path to the template
	Defaults map[string]interface{} `yaml:"defaults"`
}

func (config Config) WriteFile(dir string, data map[string]interface{}) error {
	info, err := os.Stat(dir)
	if os.IsNotExist(err) {
		return err
	}

	if !info.IsDir() {
		return errors.New("not a directory")
	}

	f, err := os.OpenFile(path.Join(dir, config.Filename), os.O_RDWR|os.O_CREATE, 0600)
	if err != nil {
		return err
	}

	return config.Compile(f, data)
}

func (config Config) WriteString(params map[string]interface{}) (string, error) {
	var output bytes.Buffer
	err := config.Compile(&output, params)
	return output.String(), err
}

// Compile the object's template
func (config Config) Compile(wr io.Writer, data map[string]interface{}) error {
	if _, err := os.Stat(config.Template); os.IsNotExist(err) {
		return err
	}

	// Make the template
	tmpl, err := template.
		New(path.Base(config.Template)).
		Option("missingkey=error").
		ParseFiles(config.Template)

	if err != nil {
		return err
	}

	// It is possible that default data is empty
	if config.Defaults == nil {
		config.Defaults = map[string]interface{}{}
	}

	// Create a copy of the defaults (so as not to modify the object)
	for k, v := range data {
		config.Defaults[k] = v
	}

	err = tmpl.Execute(wr, config.Defaults)
	if err != nil {
		return err
	}

	return nil
}
