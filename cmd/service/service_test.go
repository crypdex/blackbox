package service

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestFromDir(t *testing.T) {
	s, err := FromDir("./test_service")
	assert.NoError(t, err)

	fmt.Println(s)
}
