// The docker package is a stand-in for using the Docker SDK
// The primary reason this is used is because the command line is stable and simple to use.
//
package docker

import (
	"fmt"
	"strings"

	"github.com/crypdex/blackbox/cmd/system"
	"github.com/go-cmd/cmd"
)

type Client struct {
	env *system.Env
}

// NewClient creates a new client with reference to an environment
func NewClient(env *system.Env) *Client {
	return &Client{env: env}
}

// Cleanup removes all exited containers to save memory
// `docker ps -aq --no-trunc -f status=exited`
func (client *Client) Cleanup() cmd.Status {
	args := []string{"-c", "docker ps -aq --no-trunc -f status=exited | xargs docker rm"}
	return system.ExecCommand("bash", args, nil, client.env.Debug)
}

// SwarmLeave forces the current Docker node to leave a swarm. This is only really good for troubleshooting.
// `docker swarm leave --force`
func (client *Client) SwarmLeave() cmd.Status {
	return system.ExecCommand("docker", []string{"swarm", "leave", "--force"}, client.env.Environment(), client.env.Debug)
}

// SwarmInit initialized a swarm
// `docker swarm init`
func (client *Client) SwarmInit() cmd.Status {
	return system.ExecCommand("docker", []string{"swarm", "init"}, client.env.Environment(), client.env.Debug)
}

// SwarmState reports on the current state of the Docker node.
// It is used to determine if its necessary to initialize or join a swarm.
func (client *Client) SwarmState() cmd.Status {
	return system.ExecCommand("docker", []string{"info", "--format", "{{.Swarm.LocalNodeState}}"}, nil, client.env.Debug)
}

// IsSwarmNode determines if the current Docker node is part of a swarm.
func (client *Client) IsSwarmNode() (bool, error) {
	status := client.SwarmState()
	if status.Error != nil {
		return false, status.Error
	}

	return "active" == strings.Join(status.Stdout, ""), nil
}

// IsSwarmManager determines if this current node is a manager of a swarm.
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

// StackDeploy executes `docker stack deploy <name>`
func (client *Client) StackDeploy(name string) cmd.Status {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.StackServices()...)
	args = append(args, name)

	return system.ExecCommand("docker", args, client.env.Environment(), client.env.Debug)
}

// StackRemove removes the named stack
// `docker stack rm <name>`
func (client *Client) StackRemove(name string) cmd.Status {
	return system.ExecCommand("docker", []string{"stack", "rm", name}, client.env.Environment(), client.env.Debug)
}

// StackServices returns a formatted string of all files to "compose" when creating a stack
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

// ---------------------------
// Docker Compose functions
// There are being phased out.
// ---------------------------

// ComposeConfig calls `docker-compose config` with all the right parameters
// I dont think there is a docker stack equivalent
func (client *Client) ComposeConfig() cmd.Status {
	args := append(client.ComposeServices(), "config")
	return system.ExecCommand("docker-compose", args, client.env.Environment(), client.env.Debug)
}

func (client *Client) ComposeServices() []string {
	return client.formatServices("-f")
}
