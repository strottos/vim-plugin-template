// Copyright © 2018 strotter <strottersoft@gmail.com>
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
	"bufio"
	"fmt"
	"net"
	"os"
	"strconv"
	"time"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string
var port int
var host string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "echo_server",
	Short: "An echo server for the vim plugin template",
	Long: `An echo server that will take a socket connection on the port
specified, sleep for 5 seconds for every TODO.`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	Run: func(cmd *cobra.Command, args []string) {
		if port == 0 {
			fmt.Println("No port specified")
			os.Exit(-1)
		}

		var address = host + ":" + strconv.Itoa(port)
		fmt.Fprintln(os.Stderr, "Running on " + address)

		listener, err := net.Listen("tcp", address)
		if err != nil {
			fmt.Println(err)
			os.Exit(-1)
		}
		defer listener.Close()

		for {
			conn, err := listener.Accept()

			if err != nil {
				fmt.Println(err)
				continue
			}

			go HandleConnection(conn)
		}
	},
}

func HandleConnection(conn net.Conn) {
	defer conn.Close()

	go WriteBackToConnection(conn)

	for {
		netData, err := bufio.NewReader(conn).ReadString('\n')

		if err != nil {
			continue
		}

		//time.Sleep(5 * time.Second)

		conn.Write([]byte(netData))

		fmt.Print("-> ", string(netData))
	}
}

func WriteBackToConnection(conn net.Conn) {
	for {
		conn.Write([]byte("[\"normal\", \"I" + time.Now().String() + "\"]"))

		time.Sleep(5 * time.Second)
	}
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.echo_server.yaml)")

	rootCmd.Flags().StringVar(&host, "host", "", "specify host to run on")
	rootCmd.Flags().IntVarP(&port, "port", "p", 0, "specify port to run on")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := homedir.Dir()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// Search config in home directory with name ".echo_server" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigName(".echo_server")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}
}
