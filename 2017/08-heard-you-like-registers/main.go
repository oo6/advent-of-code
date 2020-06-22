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
	registers := map[string]int{}
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		codes := strings.Split(line, " if ")

		if executeJudgement(codes[1], registers) {
			k, v := execute(codes[0], registers)
			registers[k] = v
		}
	}

	max := -1 << 63
	for _, v := range registers {
		if max < v {
			max = v
		}
	}

	return max
}

func partTwo(input string) int {
	registers := map[string]int{}
	lines := strings.Split(input, "\n")
	max := -1 << 63

	for _, line := range lines {
		codes := strings.Split(line, " if ")

		if executeJudgement(codes[1], registers) {
			k, v := execute(codes[0], registers)
			registers[k] = v

			if max < v {
				max = v
			}
		}
	}

	return max
}

func executeJudgement(code string, registers map[string]int) bool {
	words := strings.Split(code, " ")
	key, a := words[0], 0
	b, _ := strconv.Atoi(words[2])

	if value, isPresent := registers[key]; isPresent {
		a = value
	}

	switch words[1] {
	case ">":
		return a > b
	case ">=":
		return a >= b
	case "==":
		return a == b
	case "!=":
		return a != b
	case "<=":
		return a <= b
	case "<":
		return a < b
	}

	return false
}

func execute(code string, registers map[string]int) (string, int) {
	words := strings.Split(code, " ")
	key, a := words[0], 0
	b, _ := strconv.Atoi(words[2])

	if value, isPresent := registers[key]; isPresent {
		a = value
	}

	switch words[1] {
	case "inc":
		return key, a + b
	case "dec":
		return key, a - b
	}

	return "", 0
}
