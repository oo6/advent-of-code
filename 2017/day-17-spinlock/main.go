package main

import (
	"fmt"
)

func main() {
	fmt.Println(partOne(324))
}

func partOne(step int) int {
	stack, curr := []int{0}, 0

	for i := 1; i < 2018; i++ {
		next := (curr+step)%len(stack) + 1
		stack = append(stack[:next], append([]int{i}, stack[next:]...)...)
		curr = next
	}

	return stack[curr+1]
}
