package inputfile

import (
	"io/ioutil"
)

// Read ...
func Read() string {
	input, _ := ioutil.ReadFile("input.txt")
	return string(input)
}
