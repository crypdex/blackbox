package blackbox

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"strings"
	"text/template"

	"github.com/pkg/errors"
)

func (app *App) Configure() error {

	for _, service := range app.Services() {
		Trace("info", fmt.Sprintf("Configuring '%s'", service.Name))

		// Template full path
		tmplpath := path.Join(service.Dir, "config.tmpl")

		// Does a config.tmpl exist? This is conventional
		if _, err := os.Stat(tmplpath); os.IsNotExist(err) {
			fmt.Println("no config.tmpl found for", service.Name)
			continue
		}

		// Make the template
		tmpl, err := template.
			New(path.Base(tmplpath)).
			Option("missingkey=error").
			ParseFiles(tmplpath)

		if err != nil {
			return err
		}

		fmt.Println(service.Config)

		var tpl bytes.Buffer
		err = tmpl.Execute(&tpl, envToMap(nil))
		if err != nil {
			return errors.Wrapf(err, "error writing config for %s", service.Name)
		}

		Trace("info", fmt.Sprintf("Writing %s conf to %s", service.Name, service.ConfigPath()))

		fmt.Println(tpl.String())

		err = ioutil.WriteFile(service.ConfigPath(), tpl.Bytes(), 0600)
		if err != nil {
			Trace("error", err.Error())
		}
	}

	return nil

}

func envToMap(params map[string]string) map[string]string {
	for _, v := range os.Environ() {
		parts := strings.Split(v, "=")
		params[parts[0]] = parts[1]
	}

	return params
}
