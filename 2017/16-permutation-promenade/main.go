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

func partOne(input string) string {
	return dance("abcdefghijklmnop", strings.Split(input, ","))
}

func partTwo(input string) string {
	str := "abcdefghijklmnop"

	for i := 0; i < 1000000000%60; i++ {
		str = dance(str, strings.Split(input, ","))
	}

	return str
}

func dance(str string, moves []string) string {
	for _, move := range moves {
		switch string(move[0]) {
		case "s":
			s, _ := strconv.Atoi(move[1:])

			str = spin(str, s)
		case "x":
			r := strings.Split(move[1:], "/")
			a, _ := strconv.Atoi(r[0])
			b, _ := strconv.Atoi(r[1])

			str = exchange(str, a, b)
		case "p":
			r := strings.Split(move[1:], "/")

			str = partner(str, r[0], r[1])
		}
	}

	return str
}

func spin(str string, s int) string {
	i := len(str) - s

	return str[i:] + str[:i]
}

func exchange(str string, a int, b int) string {
	temp := []rune(str)
	temp[a], temp[b] = temp[b], temp[a]

	return string(temp)
}

func partner(str string, a string, b string) string {
	return exchange(str, strings.Index(str, a), strings.Index(str, b))
}
