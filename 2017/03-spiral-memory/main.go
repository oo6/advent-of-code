package main

import (
	"fmt"
	"math"
	"strconv"
)

func main() {
	fmt.Println(partOne(347991))
	fmt.Println(partTwo(347991))
}

func partOne(input int) int {
	for i := 0; ; i++ {
		length := i*2 - 1

		for j := 0; j < 4; j++ {
			value := length*length + i + i*j*2
			diff := int(math.Abs(float64(value - input)))

			if diff <= i {
				return i + diff
			}
		}
	}
}

func partTwo(input int) int {
	grid := map[string]int{"0,0": 1}
	directions := [4][2]int{{0, 1}, {-1, 0}, {0, -1}, {1, 0}}

	for i := 1; ; i++ {
		x, y := i, -i+1
		d := 0

		for j := 0; j < i*8; j++ {
			key := strconv.Itoa(x) + "," + strconv.Itoa(y)
			value := calculateValue(x, y, grid)

			if value > input {
				return value
			}

			grid[key] = value

			if j != i*8-1 {
				x, y = x+directions[d][0], y+directions[d][1]
			}

			if x == y || x == -y {
				d++
			}
		}
	}
}

func calculateValue(x int, y int, grid map[string]int) int {
	sum := 0

	for i := -1; i < 2; i++ {
		for j := -1; j < 2; j++ {
			if i == 0 && j == 0 {
				continue
			}

			key := strconv.Itoa(x+i) + "," + strconv.Itoa(y+j)

			if value, isPresent := grid[key]; isPresent {
				sum = sum + value
			}
		}
	}

	return sum
}
