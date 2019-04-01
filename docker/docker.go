package docker

import (
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/go-cmd/cmd"
	"github.com/logrusorgru/aurora"
	"github.com/spf13/viper"
)

type Client struct {
	config *viper.Viper
}

func NewClient(config *viper.Viper) *Client {
	return &Client{config: config}
}

// There environment variables are made available by default to the docker stack command
func (client *Client) getEnv() []string {
	return []string{
		fmt.Sprintf("DATA_DIR=%s", viper.GetString("data_dir")),
	}
}

func (client *Client) SwarmInit() {
	execCommand("docker", []string{"swarm", "init"}, client.getEnv())
}

func (client *Client) StackDeploy(name string) {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.StackServices()...)
	args = append(args, name)

	execCommand("docker", args, client.getEnv())
}

func (client *Client) StackRemove(name string) {
	args := []string{"stack"}
	args = append(args, "rm")
	// args = append(args, client.StackServices()...)
	args = append(args, name)

	execCommand("docker", args, client.getEnv())
}

// ComposeConfig calls `docker-compose config` with all the right parameters
// I dont think there is a docker stack equivalent
func (client *Client) ComposeConfig() {
	args := append(client.ComposeServices(), "config")
	execCommand("docker-compose", args, client.getEnv())
}

func execCommand(command string, args []string, env []string) {
	envCmd := cmd.NewCmdOptions(
		cmd.Options{Streaming: true},
		command,
		args...,
	)
	// Set the given environment variables
	envCmd.Env = env

	// Print STDOUT and STDERR lines streaming from Cmd
	go func() {
		for {
			select {
			case line := <-envCmd.Stdout:
				info(line)
			case line := <-envCmd.Stderr:
				fmt.Fprintln(os.Stderr, aurora.BgBlack("[blackbox]"), aurora.Red(line))
			}
		}
	}()

	// DEBUG
	debugCmd := fmt.Sprintf("Running => %s %s %s", strings.Join(env, " "), command, strings.Join(args, " "))
	info(debugCmd)

	// Run and wait for Cmd to return, discard Status
	<-envCmd.Start()

	// Cmd has finished but wait for goroutine to print all lines
	for len(envCmd.Stdout) > 0 || len(envCmd.Stderr) > 0 {
		time.Sleep(10 * time.Millisecond)
	}
}

func (client *Client) ComposeServices() []string {
	return client.formatServices("-f")
}

func (client *Client) StackServices() []string {
	return client.formatServices("-c")
}

func (client *Client) formatServices(flagName string) []string {
	var args []string

	servicesDir := viper.GetString("services_dir")
	services := viper.GetStringMap("services")

	// Add up all the services files
	for service, opts := range services {
		info(fmt.Sprintf("%s %#v", service, opts))
		args = append(args, flagName, fmt.Sprintf("%s/%s/docker-compose.yml", servicesDir, service))
	}

	return args
}

func info(message string) {
	fmt.Println(aurora.BgBlack("[blackbox]"), message)
}
