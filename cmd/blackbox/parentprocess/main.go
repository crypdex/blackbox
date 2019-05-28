package main

import (
	"fmt"
	"os"
)
import "os/exec"

func main() {
	cmd := exec.Command("./subprocess.sh")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	err := cmd.Run()
	if err != nil {
		fmt.Printf(err.Error())
		os.Exit(1)
	}

}
