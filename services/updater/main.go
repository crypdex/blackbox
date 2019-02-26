package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/labstack/echo"
)

func main() {
	port := "8888"
	if value, ok := os.LookupEnv("PORT"); ok {
		port = value
	}

	e := echo.New()
	e.HideBanner = true
	e.Debug = true

	current, _ := currentRevision()
	remote, _ := remoteRevision()
	if current != remote {
		fmt.Println("core update available")
	} else {
		fmt.Println("up to date")
	}

	fmt.Println(checkImages())

	e.GET("/", func(context echo.Context) error {

		// REMOTE = "$(git ls-remote origin HEAD  | awk '{ print $1}')"
		return nil
	})
	e.Logger.Fatal(e.Start(":" + port))
}

func checkImages() (string, error) {
	out, err := exec.Command("./containers.sh").Output()
	return strings.TrimSpace(string(out)), err
}

func currentRevision() (string, error) {
	out, err := exec.Command("git", []string{"rev-parse", "--verify", "HEAD"}...).Output()
	return strings.TrimSpace(string(out)), err
}

func remoteRevision() (string, error) {
	cmd := "git ls-remote origin HEAD  | awk '{ print $1}'"
	out, err := exec.Command("bash", "-c", cmd).Output()
	return strings.TrimSpace(string(out)), err
}
