package cmd

import (
	"fmt"
	"github.com/tonyb983/cookie/version"
	"github.com/spf13/cobra"
)

// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "versionCmd 'Use' in cmd/version.go",
	Short: "versionCmd 'Short' in cmd/version.go",
	Long:  "versionCmd 'Long' in cmd/version.go",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Build Date:", version.BuildDate)
		fmt.Println("Git Commit:", version.GitCommit)
		fmt.Println("Version:", version.Version)
		fmt.Println("Go Version:", version.GoVersion)
		fmt.Println("OS / Arch:", version.OsArch)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
