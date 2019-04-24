package blackbox

import (
	"fmt"
	"os"
	"testing"
)

func TestNew(t *testing.T) {
	os.Chdir("../../")
	b := New(false)
	fmt.Println(b)
}
