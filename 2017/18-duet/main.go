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
}

func partOne(input string) int {
	result, registers := 0, map[string]int{}
	lines := strings.Split(input, "\n")

	for i := 0; i < len(lines); i++ {
		r := strings.Split(lines[i], " ")
		op, k, v := r[0], r[1], 0

		if len(r) > 2 {
			isPresent := false
			if v, isPresent = registers[r[2]]; !isPresent {
				v, _ = strconv.Atoi(r[2])
			}
		}

		value := 0
		if v, isPresent := registers[k]; isPresent {
			value = v
		}

		switch op {
		case "snd":
			result = value
		case "set":
			registers[k] = v
		case "add":
			registers[k] = value + v
		case "mul":
			registers[k] = value * v
		case "mod":
			registers[k] = value % v
		case "rcv":
			if value > 0 {
				return result
			}
		case "jgz":
			if value > 0 {
				i = i + v - 1
			}
		}
	}

	return result
}
