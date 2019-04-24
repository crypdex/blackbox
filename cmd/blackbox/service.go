package blackbox

import "fmt"

type Service struct {
	Name        string
	FilePaths   []string
	Environment map[string]interface{}
}

func (service *Service) DockerComposePaths() []string {
	var paths []string
	for _, path := range service.FilePaths {
		paths = append(paths, fmt.Sprintf("%s/docker-compose.yml", path))
	}
	return paths
}
