package server

import (
	"errors"
	"fmt"

	"github.com/logrusorgru/aurora"
)

func handle(err *error) {
	if r := recover(); r != nil {
		*err = errors.New(r.(error).Error())
	}
}

func check(err error) {
	if err != nil {
		fmt.Println(aurora.Red(err.Error()))
		panic(err)
	}
}
