package main

import (
	"fmt"
	"strconv"
	"strings"

	"./knothash"
)

func main() {
	input := `uugsqrei`

	fmt.Println(partOne(input))
}

func partOne(input string) int {
	count := 0

	for i := 0; i < 128; i++ {
		hash := knothash.Hash(input + "-" + strconv.Itoa(i))

		for j := 0; j < 4; j++ {
			v, _ := strconv.ParseInt(hash[j*8:(j+1)*8], 16, 64)
			count += strings.Count(strconv.FormatInt(v, 2), "1")
		}
	}

	return count
}
