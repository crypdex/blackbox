package service

import (
	"bytes"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
	"text/template"
)

func TestConfig_Compile(t *testing.T) {
	var expected = "rpcuser=crypdex\nrpcpass=blackbox"

	config := Config{Template: "./test_service/config.tmpl"}
	var compiled bytes.Buffer

	err := config.Compile(&compiled, map[string]interface{}{
		"BITCOIN_RPCUSER": "crypdex",
		"BITCOIN_RPCPASS": "blackbox",
	})

	// Successful compilation
	if assert.NoError(t, err) {
		assert.Equal(t, expected, compiled.String())
	}

	// Missing variables
	err = config.Compile(&compiled, map[string]interface{}{
		"BITCOIN_RPCUSER": "crypdex",
	})
	assert.IsType(t, template.ExecError{}, err)

	// Missing template
}

func TestConfig_MissingTemplate(t *testing.T) {
	config := Config{Template: "./test_service/no-exist.tmpl"}

	var compiled bytes.Buffer
	err := config.Compile(&compiled, map[string]interface{}{})

	assert.IsType(t, &os.PathError{}, err)
}

func TestConfig_WriteFile(t *testing.T) {
	config := Config{
		Filename: "bitcoin.conf",
		Template: "./test_service/config.tmpl",
	}

	err := config.WriteFile("./test_service", map[string]interface{}{
		"BITCOIN_RPCUSER": "crypdex2",
		"BITCOIN_RPCPASS": "blackbox2",
	})
	assert.NoError(t, err)
}
