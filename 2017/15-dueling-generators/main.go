package main

import (
	"fmt"
	"strconv"
)

func main() {
	a, b := 516, 190

	fmt.Println(partOne(a, b))
	fmt.Println(partTwo(a, b))
}

func partOne(a int, b int) int {
	count := 0

	for i := 0; i < 40000000; i++ {
		a = a * 16807 % 2147483647
		b = b * 48271 % 2147483647

		binaryA := padLeft(strconv.FormatInt(int64(a), 2), 32, "0")
		binaryB := padLeft(strconv.FormatInt(int64(b), 2), 32, "0")

		if binaryA[16:] == binaryB[16:] {
			count++
		}
	}

	return count
}

func partTwo(a int, b int) int {
	count := 0

	for i := 0; i < 5000000; i++ {
		a = a * 16807 % 2147483647
		b = b * 48271 % 2147483647

		for {
			if a%4 == 0 && b%8 == 0 {
				break
			}

			if a%4 != 0 {
				a = a * 16807 % 2147483647
			}
			if b%8 != 0 {
				b = b * 48271 % 2147483647
			}
		}

		binaryA := padLeft(strconv.FormatInt(int64(a), 2), 32, "0")
		binaryB := padLeft(strconv.FormatInt(int64(b), 2), 32, "0")

		if binaryA[16:] == binaryB[16:] {
			count++
		}
	}

	return count
}

func padLeft(str string, l int, c string) string {
	for {
		if len(str) >= l {
			return str
		}

		str = c + str
	}
}
