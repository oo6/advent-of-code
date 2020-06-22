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
	severity, lines := 0, strings.Split(input, "\n")

	for i := 0; i < len(lines); i++ {
		result := strings.Split(lines[i], ": ")
		d, _ := strconv.Atoi(result[0])
		r, _ := strconv.Atoi(result[1])

		if d%((r-1)*2) == 0 {
			severity = severity + d*r
		}
	}

	return severity
}

func partTwo(input string) int {
	lines := strings.Split(input, "\n")
	length := len(lines)

	for i := 0; ; i++ {
		for j := 0; j < length; j++ {
			result := strings.Split(lines[j], ": ")
			d, _ := strconv.Atoi(result[0])
			r, _ := strconv.Atoi(result[1])

			if (d+i)%((r-1)*2) == 0 {
				break
			}

			if j == length-1 {
				return i
			}
		}
	}
}
