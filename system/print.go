package system

import (
	"fmt"
	"strings"

	"github.com/logrusorgru/aurora"
)

func PrintInfo(message ...string) {
	fmt.Println(aurora.BgBlack(" blackbox "), strings.Join(message, " "))
}

func PrintError(err error) {
	fmt.Println(aurora.BgBlack(" blackbox "), aurora.Red(err.Error()))
}
