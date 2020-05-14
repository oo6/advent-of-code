package main

import (
	"fmt"
)

func main() {
	fmt.Println(partOne(324))
	fmt.Println(partTwo(324))
}

func partOne(step int) int {
	stack, curr := []int{0}, 0

	for i := 1; i < 2018; i++ {
		curr = (curr+step)%len(stack) + 1
		stack = append(stack[:curr], append([]int{i}, stack[curr:]...)...)
	}

	return stack[curr+1]
}

func partTwo(step int) int {
	var value int
	length, curr := 1, 0

	for i := 1; i < 50000001; i++ {
		curr = (curr+step)%length + 1
		length = length + 1
		if curr == 1 {
			value = i
		}
	}

	return value
}
