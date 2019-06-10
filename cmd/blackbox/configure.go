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
			// Funcs(template.FuncMap{
			// 	"lookup": lookup,
			// }).
			Option("missingkey=error").
			ParseFiles(tmplpath)

		if err != nil {
			return err
		}

		params := make(map[string]string)
		for k, v := range service.Config.Defaults {
			params[strings.ToUpper(service.Name+"_"+k)] = v
		}

		var tpl bytes.Buffer
		err = tmpl.Execute(&tpl, envToMap(params))
		if err != nil {
			return errors.Wrapf(err, "error writing config for %s", service.Name)
		}

		Trace("info", fmt.Sprintf("Writing %s conf to %s", service.Name, service.ConfigPath()))

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
