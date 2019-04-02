package system

import (
	"fmt"
	"strings"

	"github.com/logrusorgru/aurora"
)

func PrintInfo(message ...string) {
	fmt.Println(aurora.BgBlack("   "), strings.Join(message, " "))
}

func PrintError(err error) {
	PrintErrorString(err.Error())
}

func PrintErrorString(err string) {
	fmt.Println(aurora.BgBlack("   "), aurora.Red(err))
}
