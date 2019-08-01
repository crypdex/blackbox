package cmd

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/crypdex/blackbox/cmd/blackbox"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(startCmd)
}

func cleanup(client *blackbox.DockerClient) {
	fmt.Println("\nCleaning up ...")
	client.ComposeDown(nil)
}

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start [name]",
	Short: "Start your Blackbox app",
	Args:  cobra.MaximumNArgs(1),

	Run: func(cmd *cobra.Command, args []string) {

		blackbox.Trace("info", "BLACKBOX starting ...")
		// Name the project/stack
		// name := "blackbox"
		// if len(args) > 0 {
		// 	name = args[0]
		// }

		// When we start up, let's assure that we are in swarm mode
		client := blackbox.NewDockerClient(app)

		c := make(chan os.Signal)
		signal.Notify(c, os.Interrupt, syscall.SIGTERM)
		go func() {
			<-c
			cleanup(client)
			os.Exit(0)
		}()

		err := app.Prestart()
		if err != nil {
			fatal(err)
		}

		if err := app.Configure(); err != nil {
			fatal(err)
		}

		client.ComposeUp([]string{"-d", "--remove-orphans"})

		// if status.Exit != 0 {
		// 	log("info", status.Stdout...)
		// 	log("error", status.Stderr...)
		// 	fatal(status.Error)
		// 	return
		// }
		//
		// log("info", status.Stdout...)
	},
}
