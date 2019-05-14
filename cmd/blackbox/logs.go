package blackbox

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
)

func Logs() {
	// args := []string{"/var/lib/blackbox/blackbox-logs.sh"}
	cmdName := "/var/lib/blackbox/blackbox-logs.sh"
	cmdArgs := []string{}

	cmd := exec.Command(cmdName, cmdArgs...)
	cmdReader, err := cmd.StdoutPipe()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating StdoutPipe for Cmd", err)
		os.Exit(1)
	}

	scanner := bufio.NewScanner(cmdReader)
	go func() {
		for scanner.Scan() {
			fmt.Printf("docker build out | %s\n", scanner.Text())
		}
	}()

	cmdReader2, err := cmd.StderrPipe()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating StdoutPipe for Cmd", err)
		os.Exit(1)
	}

	scanner2 := bufio.NewScanner(cmdReader2)
	go func() {
		for scanner2.Scan() {
			fmt.Printf("docker build out | %s\n", scanner2.Text())
		}
	}()

	err = cmd.Start()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error starting Cmd", err)
		os.Exit(1)
	}

	err = cmd.Wait()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error waiting for Cmd", err)
		os.Exit(1)
	}

	return
}
