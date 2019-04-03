package docker

import (
	"fmt"

	"github.com/crypdex/blackbox/system"
)

type Client struct {
	env *system.Env
}

func NewClient(env *system.Env) *Client {
	return &Client{env: env}
}

func (client *Client) SwarmInit() {
	system.ExecCommand("docker", []string{"swarm", "init"}, client.env.Environment(), client.env.Debug)
}

func (client *Client) StackDeploy(name string) {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.StackServices()...)
	args = append(args, name)

	system.ExecCommand("docker", args, client.env.Environment(), client.env.Debug)
}

func (client *Client) StackRemove(name string) {
	args := []string{"stack"}
	args = append(args, "rm")
	// args = append(args, client.StackServices()...)
	args = append(args, name)

	system.ExecCommand("docker", args, client.env.Environment(), client.env.Debug)

}

// ComposeConfig calls `docker-compose config` with all the right parameters
// I dont think there is a docker stack equivalent
func (client *Client) ComposeConfig() {
	args := append(client.ComposeServices(), "config")
	system.ExecCommand("docker-compose", args, client.env.Environment(), client.env.Debug)
}

func (client *Client) ComposeServices() []string {
	return client.formatServices("-f")
}

func (client *Client) StackServices() []string {
	return client.formatServices("-c")
}

func (client *Client) formatServices(flagName string) []string {
	var args []string

	servicesDir := client.env.ServicesDir()
	services := client.env.ServiceNames()

	// Add up all the services files
	for _, service := range services {
		args = append(args, flagName, fmt.Sprintf("%s/%s/docker-compose.yml", servicesDir, service))
	}

	return args
}
