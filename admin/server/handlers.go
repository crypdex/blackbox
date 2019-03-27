package server

import (
	"errors"
	"fmt"
	"os/exec"
	"strings"

	"github.com/labstack/echo"
	"github.com/logrusorgru/aurora"
)

func StatusHandler(c echo.Context) (err error) {
	defer handle(&err)
	out, err := Status(".")
	check(err)

	return c.JSON(200, out)
}

func Status(systemDir string) (out map[string]interface{}, err error) {
	defer handle(&err)

	current, err := getCurrentTag(systemDir)
	check(err)

	latest, err := getLatestTag(systemDir)
	check(err)

	return map[string]interface{}{
		"current":          current,
		"latest":           latest,
		"update_available": current != latest,
	}, nil
}

// checkoutTag fetches all tags and checks out a specific one
func checkoutTag(dir string, tag string) (string, error) {
	cmd := fmt.Sprintf("git fetch && git fetch --tags && git checkout %s", tag)

	return execCommand(cmd, dir)
}

// getLatestTag returns the CURRENT git tag from the local repo
func getCurrentTag(dir string) (string, error) {
	cmd := "git describe --tags"

	return execCommand(cmd, dir)
}

// getLatestTag returns the LATEST git tag from the remote repo
func getLatestTag(dir string) (string, error) {
	cmd := "git ls-remote -q --tags --sort=-v:refname | awk -F/ '{ print $3 }' | head -n 1"

	return execCommand(cmd, dir)
}

// execCommand makes sure that the command is executed in a properly configured shell
func execCommand(cmd string, dir string) (string, error) {
	command := exec.Command("bash", "-c", cmd)
	command.Dir = dir
	out, err := command.Output()
	rev := strings.TrimSpace(string(out))
	return rev, err
}

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
