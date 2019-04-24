package cmd

import (
	"errors"
	"fmt"
	"os"

	. "github.com/logrusorgru/aurora"
)

func handle(err *error) {
	if r := recover(); r != nil {
		*err = errors.New(r.(error).Error())
	}
}

func check(err error) {
	if err != nil {
		fmt.Println(Red(err.Error()))
		panic(err)
	}
}

func fatal(err error) {
	if err != nil {
		fmt.Println(Red(err.Error()))
		os.Exit(1)
	}
}

func log(level string, msg ...string) {
	for _, m := range msg {
		switch level {
		case "error":
			fmt.Println(Red(m))
		default:
			fmt.Println(Gray(16-1, fmt.Sprintf(" %s ", m)).BgGray(8 - 1))
		}
	}
}
