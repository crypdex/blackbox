package blackbox

import (
	"fmt"
	"os"
	"path"
)

func (app *App) Exec(bin string, args []string) error {
	var fullpath string
	for _, service := range app.ServiceMap {
		p := path.Join(service.Dir, "bin", bin)
		if _, err := os.Stat(p); !os.IsNotExist(err) {
			fullpath = p
		}

	}

	if fullpath == "" {
		return fmt.Errorf("%s cannot be found", bin)
	}

	return RunSync(fullpath, args, nil, app.Debug)
}
