package blackbox

import (
	"os"
	"testing"
)

func TestNew(t *testing.T) {
	os.Chdir("../../")
	b := NewApp(false)
	b.DataDir()

	b.Services()
}
