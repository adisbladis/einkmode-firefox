package main // import "github.com/adisbladis/einkmode-firefox"

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"log"
	"os"
	"os/signal"
	"syscall"
)

type message struct {
	ColoursDisable bool `json:"coloursDisable"`
}

func sendMessage(msg *message) {
	var bytesBuffer bytes.Buffer
	if err := json.NewEncoder(&bytesBuffer).Encode(msg); err != nil {
		log.Fatal("Unable to encode message for sending: ", err)
	}

	if err := binary.Write(os.Stdout, binary.LittleEndian, uint32(bytesBuffer.Len())); err != nil {
		log.Fatal("Unable to send the length of the response: ", err)
	}

	if _, err := bytesBuffer.WriteTo(os.Stdout); err != nil {
		log.Fatal("Unable to send the response: ", err)
	}
}

func main() {

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGUSR1, syscall.SIGUSR2)

	for {
		sig := <-sigs
		switch sig {
		case syscall.SIGUSR1:
			sendMessage(&message{
				ColoursDisable: true,
			})
		case syscall.SIGUSR2:
			sendMessage(&message{
				ColoursDisable: false,
			})
		default:
			log.Fatal("Unhandled signal: %v", sig)
		}
	}

}
