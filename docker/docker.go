package docker

import (
	"fmt"
	"strings"

	"github.com/go-cmd/cmd"

	"github.com/crypdex/blackbox/system"
)

type Client struct {
	env *system.Env
}

func NewClient(env *system.Env) *Client {
	return &Client{env: env}
}

func (client *Client) Cleanup() cmd.Status {
	// docker ps -aq --no-trunc -f status=exited
	args := []string{"-c", "docker ps -aq --no-trunc -f status=exited | xargs docker rm"}
	return system.ExecCommand("bash", args, nil, client.env.Debug)
}

func (client *Client) SwarmLeave() cmd.Status {
	return system.ExecCommand("docker", []string{"swarm", "leave", "--force"}, client.env.Environment(), client.env.Debug)
}

func (client *Client) SwarmInit() cmd.Status {
	return system.ExecCommand("docker", []string{"swarm", "init"}, client.env.Environment(), client.env.Debug)
}

func (client *Client) SwarmState() cmd.Status {
	return system.ExecCommand("docker", []string{"info", "--format", "{{.Swarm.LocalNodeState}}"}, nil, client.env.Debug)
}

func (client *Client) IsSwarmNode() (bool, error) {
	status := client.SwarmState()
	if status.Error != nil {
		return false, status.Error
	}

	return "active" == strings.Join(status.Stdout, ""), nil
}

func (client *Client) IsSwarmManager() (bool, error) {
	if _, err := client.IsSwarmNode(); err != nil {
		return false, err
	}

	status := system.ExecCommand("docker", []string{"node", "inspect", "self", "-f", "{{.ManagerStatus.Leader}}"}, nil, client.env.Debug)
	if status.Error != nil {
		return false, status.Error
	}
	return "true" == strings.Join(status.Stdout, ""), nil
}

func (client *Client) StackDeploy(name string) cmd.Status {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.StackServices()...)
	args = append(args, name)

	return system.ExecCommand("docker", args, client.env.Environment(), client.env.Debug)
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
func (client *Client) ComposeConfig() cmd.Status {
	args := append(client.ComposeServices(), "config")
	return system.ExecCommand("docker-compose", args, client.env.Environment(), client.env.Debug)
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
