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
	list := make([]int, 256)
	for i := range list {
		list[i] = i
	}

	round(list, strings.Split(input, ","), 0, 0)

	return list[0] * list[1]
}

func partTwo(input string) string {
	list, lengths := make([]int, 256), make([]string, len(input))
	for i := range list {
		list[i] = i
	}
	for i, c := range input {
		lengths[i] = strconv.Itoa(int(c))
	}
	lengths = append(lengths, "17", "31", "73", "47", "23")

	start, skip := 0, 0
	for i := 0; i < 64; i++ {
		start, skip = round(list, lengths, start, skip)
	}

	hash := make([]string, 16)
	for i := 0; i < 16; i++ {
		sub := list[i*16 : (i+1)*16]
		result := sub[0]

		for j := 1; j < len(sub); j++ {
			result = result ^ sub[j]
		}

		hash[i] = strconv.FormatInt(int64(result), 16)
		if len(hash[i]) == 1 {
			hash[i] = "0" + hash[i]
		}
	}

	return strings.Join(hash, "")
}

func round(list []int, lengths []string, start int, skip int) (int, int) {
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

	return start, skip
}

func reverse(ints []int) []int {
	if len(ints) == 0 {
		return ints
	}
	return append(reverse(ints[1:]), ints[0])
}
