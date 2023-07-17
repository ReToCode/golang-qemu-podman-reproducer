package main

import (
	"fmt"

	"k8s.io/client-go/kubernetes"
)

func main() {
	a := kubernetes.Clientset{}
	fmt.Println("Build me", a)
}
