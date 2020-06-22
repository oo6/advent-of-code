package main

import (
	"aoc/inputfile"
	"fmt"
	"math"
	"strings"
)

func main() {
	input := inputfile.Read()

	directions := map[string][]float64{"n": {0, 1}, "ne": {1, 1}, "se": {1, -1}, "s": {0, -1}, "sw": {-1, -1}, "nw": {-1, 1}}

	fmt.Println(partOne(input, directions))
	fmt.Println(partTwo(input, directions))
}

func partOne(input string, directions map[string][]float64) float64 {
	coord := make([]float64, 2)

	for _, key := range strings.Split(input, ",") {
		coord = []float64{coord[0] + directions[key][0], coord[1] + directions[key][1]}
	}
	coord = []float64{math.Abs(coord[0]), math.Abs(coord[1])}

	if coord[0] >= coord[1] {
		return coord[0]
	}
	return coord[1]
}

func partTwo(input string, directions map[string][]float64) float64 {
	keys := strings.Split(input, ",")
	coord, result := make([]float64, 2), make([]float64, len(keys))

	for i, key := range keys {
		coord = []float64{coord[0] + directions[key][0], coord[1] + directions[key][1]}
		temp := []float64{math.Abs(coord[0]), math.Abs(coord[1])}

		if temp[0] >= temp[1] {
			result[i] = temp[0]
		} else {
			result[i] = temp[1]
		}
	}

	max := 0.0
	for _, value := range result {
		if max < value {
			max = value
		}
	}

	return max
}
