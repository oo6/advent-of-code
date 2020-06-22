package main

import (
	"aoc/inputfile"
	"fmt"
)

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	score, totalScore := 0, 0
	inGarbage := false

	for i := 0; i < len(input); i++ {
		char := string(input[i])

		if char == "!" {
			i++
			continue
		}

		if !inGarbage && char == "<" {
			inGarbage = true
			continue
		}

		if inGarbage && char == ">" {
			inGarbage = false
			continue
		}

		if !inGarbage {
			switch char {
			case "{":
				score++
			case "}":
				totalScore += score
				score--
			}
		}
	}

	return totalScore
}

func partTwo(input string) int {
	count, inGarbage := 0, false

	for i := 0; i < len(input); i++ {
		char := string(input[i])

		if char == "!" {
			i++
			continue
		}

		if !inGarbage && char == "<" {
			inGarbage = true
			continue
		}

		if inGarbage && char == ">" {
			inGarbage = false
			continue
		}

		if inGarbage {
			count++
		}
	}

	return count
}
