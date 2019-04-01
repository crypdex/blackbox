package cmd

import (
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/go-cmd/cmd"

	"github.com/logrusorgru/aurora"

	"github.com/spf13/viper"
)

// docker-compose config
func dockerComposeConfig() string {
	return dockerComposeExec("config")
}

// docker-compose up
func dockerComposeUp() string {
	return dockerComposeExec("pull")
}

// docker-compose logs
func dockerComposeLogs() string {
	return dockerComposeExec("logs")
}

func dockerComposeExec(command string, flags ...string) string {
	list := []string{"stack", "deploy"}
	list = append(list, dockerComposeServices()...)
	list = append(list, "blackbox")
	list = append(list, flags...)

	env := []string{
		fmt.Sprintf("DATA_DIR=%s", viper.GetString("data_dir")),
	}

	fmt.Println(
		aurora.Cyan(
			fmt.Sprintf("%s %s %s",
				strings.Join(env, " "),
				"docker",
				strings.Join(list, " ")),
		),
	)

	return ""

	// Disable output buffering, enable streaming
	cmdOptions := cmd.Options{
		Buffered:  false,
		Streaming: true,
	}

	// Create Cmd with options
	envCmd := cmd.NewCmdOptions(cmdOptions, "docker", list...)
	envCmd.Env = env
	// Print STDOUT and STDERR lines streaming from Cmd
	go func() {
		for {
			select {
			case line := <-envCmd.Stdout:
				fmt.Println(line)
			case line := <-envCmd.Stderr:
				fmt.Fprintln(os.Stderr, line)
			}
		}
	}()

	// Run and wait for Cmd to return, discard Status
	<-envCmd.Start()

	// Cmd has finished but wait for goroutine to print all lines
	for len(envCmd.Stdout) > 0 || len(envCmd.Stderr) > 0 {
		time.Sleep(10 * time.Millisecond)
	}

	return "out"
}

func dockerComposeServices() []string {
	var list []string

	servicesDir := viper.GetString("services_dir")
	services := viper.GetStringMap("services")

	// Add up all the services files
	for service, opts := range services {
		fmt.Println(service, "=>", opts)
		list = append(list, "-c", fmt.Sprintf("%s/%s/docker-compose.yml", servicesDir, service))
	}

	return list
}
