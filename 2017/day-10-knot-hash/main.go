package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	input := "206,63,255,131,65,80,238,157,254,24,133,2,16,0,1,3"

	fmt.Println(partOne(input))
}

func partOne(input string) int {
	list := make([]int, 256)
	for i := range list {
		list[i] = i
	}

	start, skip := 0, 0
	lengths := strings.Split(input, ",")

	for i := range lengths {
		length, _ := strconv.Atoi(lengths[i])
		end := (start + length) % len(list)
		sub := make([]int, 0)

		if start < end {
			sub = append(sub, list[start:end]...)
		} else {
			sub = append(sub, list[start:]...)
			sub = append(sub, list[0:end]...)
		}
		sub = reverse(sub)

		for j := 0; j < length; j++ {
			list[(start+j)%len(list)] = sub[j]
		}

		start = (start + length + skip) % len(list)
		skip++
	}

	return list[0] * list[1]
}

func reverse(ints []int) []int {
	if len(ints) == 0 {
		return ints
	}
	return append(reverse(ints[1:]), ints[0])
}
