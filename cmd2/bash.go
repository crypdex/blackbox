package cmd2

import (
	"bufio"
	"fmt"
	"os/exec"
	"strings"
)

func run(cmdString string) error {
	cmdArgs := strings.Fields(cmdString)
	cmd := exec.Command(cmdArgs[0], cmdArgs[1:]...)

	stdout, err := cmd.StdoutPipe()
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return err
	}
	if err != nil {
		return err
	}

	if err := cmd.Start(); err != nil {
		return err
	}

	stdoutScanner := bufio.NewScanner(stdout)
	go func() {
		for stdoutScanner.Scan() {
			fmt.Printf("stdout | %s\n", stdoutScanner.Bytes())
		}
	}()

	stderrScanner := bufio.NewScanner(stderr)
	go func() {
		for stderrScanner.Scan() {
			fmt.Printf("stderr | %s\n", stderrScanner.Bytes())
		}
	}()

	return cmd.Wait()
}
