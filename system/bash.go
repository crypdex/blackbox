package system

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/go-cmd/cmd"
	"github.com/logrusorgru/aurora"
)

// ExecCommand needs to be moved outside of this package
func ExecCommand(command string, args []string, env map[string]string, debug bool) {
	envCmd := cmd.NewCmdOptions(
		cmd.Options{Streaming: true},
		command,
		args...,
	)
	// Set the given environment variables
	envCmd.Env = formatEnv(env)

	// Print STDOUT and STDERR lines streaming from Cmd
	go func() {
		for {
			select {
			case line := <-envCmd.Stdout:
				PrintInfo(line)
			case line := <-envCmd.Stderr:
				fmt.Fprintln(os.Stderr, aurora.BgBlack(" blackbox "), aurora.Red(line))
			}
		}
	}()

	// DEBUG
	if debug {
		debugCmd := fmt.Sprintf("%s %s %s", strings.Join(formatEnv(env), " "), command, strings.Join(args, " "))
		PrintInfo(aurora.Cyan(debugCmd).String())
	}

	// Run and wait for Cmd to return, discard Status
	status := <-envCmd.Start()
	PrintInfo("exit code", strconv.Itoa(status.Exit))
	// Cmd has finished but wait for goroutine to print all lines
	for len(envCmd.Stdout) > 0 || len(envCmd.Stderr) > 0 {
		time.Sleep(10 * time.Millisecond)
	}
}

func formatEnv(env map[string]string) []string {
	var output []string
	for k, v := range env {
		output = append(output, fmt.Sprintf(`%s=%s`, k, v))
	}
	return output
}
