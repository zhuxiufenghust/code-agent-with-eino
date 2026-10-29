package main

import "github.com/spf13/cobra"

var rootCmd = cobra.Command{
	Use:           "CodeAgent",
	Short:         "CodeAgent - AI-Powered Code Review CLI",
	Long:          `CodeAgent - AI-Powered Code Review CLI`,
	SilenceUsage:  true,
	SilenceErrors: true,

	Run: func(cmd *cobra.Command, args []string) {
		// Default action for the root command

	},
}
