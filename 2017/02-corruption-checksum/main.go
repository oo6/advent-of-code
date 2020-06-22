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
	rows := strings.Split(input, "\n")
	sum := 0

	for _, row := range rows {
		min, max := 0, 0

		for i, str := range strings.Split(row, "\t") {
			digit, _ := strconv.Atoi(str)

			if i == 0 {
				min, max = digit, digit
			} else {
				if min > digit {
					min = digit
				}
				if max < digit {
					max = digit
				}
			}
		}

		sum = sum + (max - min)
	}

	return sum
}

func partTwo(input string) int {
	rows := strings.Split(input, "\n")
	sum := 0

	for _, row := range rows {
		sum = sum + getDivisibleValue(row)
	}

	return sum
}

func getDivisibleValue(row string) int {
	str := strings.Split(row, "\t")
	length := len(str)
	value := 0

	for i := 0; i < length; i++ {
		first, _ := strconv.Atoi(str[i])

		j := i + 1
		for ; j < length; j++ {
			second, _ := strconv.Atoi(str[j])

			if first%second == 0 {
				value = first / second
				break
			}
			if second%first == 0 {
				value = second / first
				break
			}
		}

		if j < length {
			break
		}
	}

	return value
}
