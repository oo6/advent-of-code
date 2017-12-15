package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println(partOne(347991))
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
