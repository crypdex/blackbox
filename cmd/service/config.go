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
	Destination string `yaml:"destination"` // Name of the compiled output file
	Template    string `yaml:"template"`    // Full path to the template
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

	funcMap := template.FuncMap{
		"require": func(m map[string]interface{}, key string) (interface{}, error) {
			val, ok := m[key]
			if !ok {
				return nil, errors.New("missing key " + key)
			}
			return val, nil
		},
	}

	// Make the template
	tmpl, err := template.
		New(path.Base(config.Template)).Funcs(funcMap).
		Option("missingkey=zero").
		ParseFiles(config.Template)

	if err != nil {
		return err
	}

	err = tmpl.Execute(wr, data)
	if err != nil {
		return err
	}

	return nil
}
