// Copyright © 2019 NAME HERE <EMAIL ADDRESS>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"fmt"
	"os"
	"text/template"

	"github.com/spf13/cobra"
)

//var pkgName string


// initCmd represents the init command
var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize a Service",
	Long: `Initialize (goservice init) creates new service For example:

Creates a service
	* REST API
	* gRPC API`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("init called")

		wd, err := os.Getwd()
		if err != nil {
			fmt.Errorf("%v", err)
		}

		if len(args) < 1 {
			fmt.Errorf("error: needs args for service name")
			//os.Exit(0)
		}
		wd = fmt.Sprintf("%s/%s", wd, args[0])
		fmt.Println(args[0])
		service := &Service{
			PkgName: args[0],
			AbsPath: wd,
		}
		if err := service.Create(); err != nil {
			fmt.Errorf("error: failed to create service %s", err)
		}

	},
}

func init() {
	RootCmd.AddCommand(initCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// initCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// initCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}



type Service struct {
	PkgName string
	AbsPath string
}

func (s *Service) Create() error {
	//create service dir
	os.Mkdir(s.PkgName, 755)

	//create main.go
	mainFile, err := os.Create(fmt.Sprintf("%s/main.go", s.AbsPath))
	if err != nil {
		return err
	}
	defer mainFile.Close()

	mainTemplate :=  template.Must(template.New("main").Parse(string(MainTemplate())))
	err = mainTemplate.Execute(mainFile, s)
	if err != nil {
		return err
	}
	//TODO: default port/flag for port?
	//TODO: flag for db
	//TODO: pass type of api to create
	//main.go generate code to serve http

	return nil
}

func MainTemplate() []byte {
	return []byte(`
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {

// Starting App =================
log.


}
`)
}
