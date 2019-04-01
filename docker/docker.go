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

// GetEnv needs to be move dout
// There environment variables are made available by default to the docker stack command
func (client *Client) GetEnv() map[string]string {
	// This is a map so that we can override
	env := map[string]string{
		"DATA_DIR": viper.GetString("data_dir"),
	}

	// Add up all the services files
	services := viper.GetStringMap("services")
	for service := range services {

		serviceEnv := GetServiceEnv(service, env)
		for k, v := range serviceEnv {
			env[k] = v
		}
	}

	return env
}

func envPrefix(prefix string) string {
	return strings.ToUpper(prefix) + "_"
}

func GetServiceEnv(service string, globals map[string]string) map[string]string {
	// This is a map so that we can override
	env := make(map[string]string)
	// Default DATA_DIR namespaced for each service
	env[envPrefix(service)+"DATA_DIR"] = globals["DATA_DIR"] + "/" + service

	for key, value := range viper.GetStringMap("services." + service) {
		env[envPrefix(service)+strings.ToUpper(key)] = value.(string)
	}
	return env
}

func (client *Client) SwarmInit() {
	ExecCommand("docker", []string{"swarm", "init"}, client.GetEnv())
}

func (client *Client) StackDeploy(name string) {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.StackServices()...)
	args = append(args, name)

	ExecCommand("docker", args, client.GetEnv())
}

func (client *Client) StackRemove(name string) {
	args := []string{"stack"}
	args = append(args, "rm")
	// args = append(args, client.StackServices()...)
	args = append(args, name)

	ExecCommand("docker", args, client.GetEnv())
}

// ComposeConfig calls `docker-compose config` with all the right parameters
// I dont think there is a docker stack equivalent
func (client *Client) ComposeConfig() {
	args := append(client.ComposeServices(), "config")
	ExecCommand("docker-compose", args, client.GetEnv())
}

// ExecCommand needs to be moved outside of this package
func ExecCommand(command string, args []string, env map[string]string) {
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
				info(line)
			case line := <-envCmd.Stderr:
				fmt.Fprintln(os.Stderr, aurora.BgBlack(" blackbox "), aurora.Red(line))
			}
		}
	}()

	// DEBUG
	debugCmd := fmt.Sprintf("%s %s %s", strings.Join(formatEnv(env), " "), command, strings.Join(args, " "))
	info(aurora.Cyan(debugCmd).String())

	// Run and wait for Cmd to return, discard Status
	<-envCmd.Start()

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
	for service := range services {
		args = append(args, flagName, fmt.Sprintf("%s/%s/docker-compose.yml", servicesDir, service))
	}

	return args
}

func info(message string) {
	fmt.Println(aurora.BgBlack(" blackbox "), message)
}
