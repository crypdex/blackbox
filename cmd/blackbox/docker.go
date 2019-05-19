package blackbox

import (
	"fmt"
	"strings"

	"github.com/go-cmd/cmd"
)

type DockerClient struct {
	config *App
}

func NewDockerClient(config *App) *DockerClient {
	return &DockerClient{
		config: config,
	}
}

// Cleanup removes all exited containers to save memory
// `docker ps -aq --no-trunc -f status=exited`
func (client *DockerClient) Cleanup() cmd.Status {
	args := []string{"-c", "docker ps -aq --no-trunc -f status=exited | xargs docker rm"}
	return ExecCommand("bash", args, nil, client.config.Debug)
}

// ---------------------------
// Docker Stack functions
// ---------------------------

// StackDeploy executes `docker stack deploy <name>`
func (client *DockerClient) StackDeploy(name string) cmd.Status {
	args := []string{"stack"}
	args = append(args, "deploy")
	args = append(args, client.stackFiles()...)
	args = append(args, name)

	return ExecCommand("docker", args, client.config.EnvVars(), client.config.Debug)
}

// StackRemove removes the named stack
// `docker stack rm <name>`
func (client *DockerClient) StackRemove(name string) cmd.Status {
	return ExecCommand("docker", []string{"stack", "rm", name}, client.config.EnvVars(), client.config.Debug)
}

// StackServices returns a formatted string of all files to "compose" when creating a stack
func (client *DockerClient) stackFiles() []string {
	return client.formatServices("-c")
}

// ---------------------------
// Swarm-related functions
// ---------------------------

func (client *DockerClient) EnsureSwarmMode() error {
	if !client.config.ForceSwarm() {
		trace("[swarm] flag not set.")
		return nil
	}

	trace("[swarm] found swarm setting.")
	isManager, err := client.IsSwarmManager()
	if err != nil {
		return err
	}

	if isManager {
		trace("[swarm] already a swarm manager, no need to force.")
		return nil
	}

	trace("[swarm] forcing the Docker daemon into swarm mode.")

	status := client.SwarmLeave()
	fmt.Println(strings.Join(status.Stdout, "\n"))

	status = client.SwarmInit()
	if status.Exit == 0 {
		fmt.Println(status.Stdout[0])
	}
	return nil
}

// SwarmInit initialized a swarm
// `docker swarm init`
func (client *DockerClient) SwarmInit() cmd.Status {
	return ExecCommand("docker", []string{"swarm", "init"}, client.config.EnvVars(), client.config.Debug)
}

// SwarmState reports on the current state of the Docker node.
// It is used to determine if its necessary to initialize or join a swarm.
func (client *DockerClient) SwarmState() cmd.Status {
	return ExecCommand("docker", []string{"info", "--format", "{{.Swarm.LocalNodeState}}"}, nil, client.config.Debug)
}

// SwarmLeave forces the current Docker node to leave a swarm. This is only really good for troubleshooting.
// `docker swarm leave --force`
func (client *DockerClient) SwarmLeave() cmd.Status {
	return ExecCommand("docker", []string{"swarm", "leave", "--force"}, client.config.EnvVars(), client.config.Debug)
}

// IsSwarmNode determines if the current Docker node is part of a swarm.
func (client *DockerClient) IsSwarmNode() (bool, error) {
	status := client.SwarmState()
	if status.Error != nil {
		return false, status.Error
	}

	return "active" == strings.Join(status.Stdout, ""), nil
}

// IsSwarmManager determines if this current node is a manager of a swarm.
func (client *DockerClient) IsSwarmManager() (bool, error) {
	if _, err := client.IsSwarmNode(); err != nil {
		return false, err
	}

	status := ExecCommand("docker", []string{"node", "inspect", "self", "-f", "{{.ManagerStatus.Leader}}"}, nil, client.config.Debug)
	if status.Error != nil {
		return false, status.Error
	}
	return "true" == strings.Join(status.Stdout, ""), nil
}

// ---------------------------
// Docker Compose functions
// There are being phased out.
// ---------------------------

func (client *DockerClient) ComposeUp() cmd.Status {
	// docker-compose -f file up
	// command := fmt.Sprintf("docker-compose -p blackbox %s up", strings.Join(client.composeFiles(), " "))
	command := "docker-compose -p blackbox -f /Users/dmichael/go/src/github.com/crypdex/blackbox/services/sparkswap/docker-compose.yml -f /Users/dmichael/go/src/github.com/crypdex/blackbox/recipes/sparkswap.yml up -d"
	Run(command, client.config.EnvVars(), client.config.Debug)
	return cmd.Status{} // ExecCommand("docker-compose", args, client.config.EnvVars(), client.config.Debug)
}

func (client *DockerClient) ComposeDown() cmd.Status {
	// docker-compose -f file up
	command := fmt.Sprintf("docker-compose -p blackbox %s down", strings.Join(client.composeFiles(), " "))
	Run(command, client.config.EnvVars(), client.config.Debug)
	return cmd.Status{} // ExecCommand("docker-compose", args, client.config.EnvVars(), client.config.Debug)
}

func (client *DockerClient) ComposeLogs() cmd.Status {
	// docker-compose -f file up
	command := fmt.Sprintf("docker-compose -p blackbox %s logs -f", strings.Join(client.composeFiles(), " "))
	Run(command, client.config.EnvVars(), client.config.Debug)
	return cmd.Status{} // ExecCommand("docker-compose", args, client.config.EnvVars(), client.config.Debug)
}

// ComposeConfig calls `docker-compose config` with all the right parameters
// I dont think there is a docker stack equivalent
func (client *DockerClient) ComposeConfig() cmd.Status {
	args := append(client.composeFiles(), "config")

	command := "docker-compose " + strings.Join(args, " ")
	fmt.Println(command)
	Run(command, client.config.EnvVars(), client.config.Debug)
	return cmd.Status{} // ExecCommand("docker-compose", args, client.config.EnvVars(), client.config.Debug)
}

func (client *DockerClient) composeFiles() []string {
	return client.formatServices("-f")
}

// ------------
// helpers
// ------------

func (client *DockerClient) formatServices(flagName string) []string {
	var args []string

	// Add up all the services files
	for _, service := range client.config.Services() {
		args = append(args, flagName)
		args = append(args, service.DockerComposePaths()...)
	}

	// Finally, the root config file overrides
	args = append(args, flagName, client.config.ConfigFile)

	return args
}
