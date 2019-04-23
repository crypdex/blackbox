package cmd

import (
	"fmt"
	"testing"

	"github.com/logrusorgru/aurora"
	"github.com/stretchr/testify/assert"
)

func TestConfig(t *testing.T) {
	paths, _ := AppRoot()
	// At least 2 paths back.
	// Userspace and Appspace
	assert.Equal(t, len(paths), 2)
	// We cant know the userspace, but the
	// Last element should be the appspace
	assert.Equal(t, paths[len(paths)-1], "/var/lib/blackbox")
}

func trace(msg interface{}) {
	fmt.Println(aurora.Cyan(msg))
}
