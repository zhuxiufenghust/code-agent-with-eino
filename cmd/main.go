package main

import (
	"fmt"
	"os"
)

func main() {
	os.Exit(run())
}
func run() int {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		return 1
	}
	return 0
}
