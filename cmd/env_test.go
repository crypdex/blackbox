package cmd

import (
	"fmt"
	"testing"

	"github.com/crypdex/blackbox/cmd/system"

	"github.com/logrusorgru/aurora"
	"github.com/stretchr/testify/assert"
)

func TestConfig(t *testing.T) {
	// config, _ := system.NewConfig(false)
	paths := system.ConfigPaths()
	// At least 2 paths back.
	// Userspace and Appspace
	assert.Equal(t, len(paths), 3)
	// We cant know the userspace, but the
	// Last element should be the appspace
	assert.Equal(t, paths[len(paths)-1], "/var/lib/blackbox")
}

func TestNewConfig(t *testing.T) {
	config := system.NewConfig(false)
	fmt.Println(config)
	config.Services()
}

func trace(msg interface{}) {
	fmt.Println(aurora.Cyan(msg))
}
