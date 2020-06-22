package main

import (
	"aoc/inputfile"
	"fmt"
	"strconv"
)

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	length := len(input)
	sum := 0

	for curr := 0; curr < length; curr++ {
		next := curr + 1
		if next == length {
			next = 0
		}

		if input[curr] == input[next] {
			val, _ := strconv.Atoi(string(input[curr]))
			sum = sum + val
		}
	}

	return sum
}

func partTwo(input string) int {
	half := len(input) / 2
	sum := 0

	for i := 0; i < half; i++ {
		if input[i] == input[half+i] {
			val, _ := strconv.Atoi(string(input[i]))
			sum = sum + val*2
		}
	}

	return sum
}
