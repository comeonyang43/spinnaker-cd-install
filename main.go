package main

import (
	"fmt"
	"os"

	"github.com/spf13/viper"
)

func main() {
	
	if os.Getenv("VER_NAME") == "" || os.Getenv("TAG_FILE") == "" {
		fmt.Println("please set env: VER_NAME or TAG_FILE")
		os.Exit(1)
	}
	fileName := os.Getenv("VER_NAME")
	viper.SetConfigType("yaml")
	viper.SetConfigFile(fileName)
	err := viper.ReadInConfig()
	if err != nil {
		fmt.Println(err.Error())
	}

	tags := make(map[string]interface{})
	for k, v := range viper.GetStringMap("services") {
		ver, ok := v.(map[string]interface{})
		if ver["version"] == nil {
			continue
		}
		if ok {
			tags[k] = ver["version"]
		}
	}
	f, err := os.OpenFile(os.Getenv("TAG_FILE"), os.O_CREATE|os.O_RDWR|os.O_TRUNC, os.ModePerm)
	if err != nil {
		fmt.Println(err.Error())
	}
	defer f.Close()
	for k, v := range tags {
		_, err := fmt.Fprintf(f, "%v:%v\n", k, v)
		if err != nil {
			fmt.Println(err.Error())
		}
	}

}
