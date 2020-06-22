package main

import (
	"aoc/inputfile"
	"fmt"
	"strconv"
	"strings"
)

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	offsets := strings.Split(input, "\n")
	curr, steps := 0, 0

	for {
		steps++
		offset, _ := strconv.Atoi(offsets[curr])
		next := curr + offset

		if next >= len(offsets) {
			return steps
		}

		offsets[curr] = strconv.Itoa(offset + 1)
		curr = next
	}
}

func partTwo(input string) int {
	offsets := strings.Split(input, "\n")
	curr, steps := 0, 0

	for {
		steps++
		offset, _ := strconv.Atoi(offsets[curr])
		next := curr + offset

		if next >= len(offsets) {
			return steps
		}

		i := 1
		if offset >= 3 {
			i = -1
		}
		offsets[curr] = strconv.Itoa(offset + i)
		curr = next
	}
}
