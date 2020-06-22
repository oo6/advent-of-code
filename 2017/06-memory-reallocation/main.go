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
	cycles, state := 0, map[string]bool{}
	banks := strings.Split(input, "\t")

	for {
		cycles++
		max, index := getMaxAndIndex(banks)
		banks = reallocate(banks, max, index)

		key := strings.Join(banks, " ")
		if _, isPresent := state[key]; isPresent {
			return cycles
		}

		state[key] = true
	}
}

func partTwo(input string) int {
	cycles, state := 0, map[string]int{}
	banks := strings.Split(input, "\t")

	for {
		cycles++
		max, index := getMaxAndIndex(banks)
		banks = reallocate(banks, max, index)

		key := strings.Join(banks, " ")
		if value, isPresent := state[key]; isPresent {
			return cycles - value
		}

		state[key] = cycles
	}
}

func getMaxAndIndex(banks []string) (int, int) {
	max, index := 0, 0

	for i := range banks {
		blocks, _ := strconv.Atoi(banks[i])

		if blocks > max {
			max, index = blocks, i
		}
	}

	return max, index
}

func reallocate(banks []string, max int, index int) []string {
	banks[index] = "0"
	for i := 0; i < max; i++ {
		offset := (index + i + 1) % len(banks)
		blocks, _ := strconv.Atoi(banks[offset])
		banks[offset] = strconv.Itoa(blocks + 1)
	}

	return banks
}
