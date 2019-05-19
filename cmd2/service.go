package cmd2

import (
	"fmt"
	"strconv"
	"strings"
)

type Service struct {
	Name      string
	FilePaths []string
	Env       map[string]interface{}
}

func (service *Service) DockerComposePaths() []string {
	var paths []string
	for _, path := range service.FilePaths {
		paths = append(paths, fmt.Sprintf("%s/docker-compose.yml", path))
	}
	return paths
}

func (service *Service) EnvVars() map[string]string {
	// This is a map so that we can override
	output := make(map[string]string)
	// Add defined environment variables
	for k, v := range service.Env {
		var value string
		switch i := v.(type) {
		case string:
			value = i
		case int:
			value = strconv.Itoa(i)
		case bool:
			value = strconv.FormatBool(i)
		default:
			fmt.Printf("I don't know about type %T!\n", v)
		}
		output[strings.ToUpper(service.Name)+"_"+strings.ToUpper(k)] = value
	}
	return output
}
