package blackbox

import "github.com/go-cmd/cmd"

func Logs() cmd.Status {
	args := []string{"/var/lib/blackbox/blackbox-logs.sh"}
	return StreamCommand("bash", args, nil, false)
}
