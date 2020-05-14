package main

import (
	"fmt"
	"strings"
)

func main() {
	input := `../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#`

	fmt.Println(partOne(input))
}

func partOne(input string) int {
	begin := `.#.
..#
###`

	rules := parseRules(input)

	fmt.Println(rules)
	fmt.Println(begin)

	return 0
}

func parseRules(input string) map[string][]string {
	rules, lines := map[string][]string{}, strings.Split(input, "\n")

	for _, line := range lines {
		kv := strings.Split(line, " => ")

		k, v := strings.Join(strings.Split(kv[0], "/"), ""), strings.Split(kv[1], "/")
		rules[k] = v

		var width int
		if len(k)%2 == 0 {
			width = 2
		} else {
			width = 3
		}

		matrix, items := [][]string{{"", "", ""}, {"", "", ""}, {"", "", ""}}, strings.Split(k, "")

		for i := 0; i < width; i++ {
			for j := 0; j < width; j++ {
				matrix[i][j] = items[width*i+j]
			}
		}

		for i := 0; i < 7; i++ {
			if i == 3 {
				matrix = flip(matrix, width)
			} else {
				matrix = rotate(matrix, width)
			}

			k := strings.Join(matrix[0], "") + strings.Join(matrix[1], "") + strings.Join(matrix[2], "")

			if _, isPresent := rules[k]; isPresent {
				break
			}

			rules[k] = v
		}
	}

	return rules
}

func rotate(matrix [][]string, width int) [][]string {
	m := [][]string{{"", "", ""}, {"", "", ""}, {"", "", ""}}

	for i := 0; i < width; i++ {
		for j := 0; j < width; j++ {
			m[i][j] = matrix[j][width-i-1]
		}
	}

	return m
}

func flip(matrix [][]string, width int) [][]string {
	m := [][]string{{"", "", ""}, {"", "", ""}, {"", "", ""}}

	for i := 0; i < width; i++ {
		m[i][0], m[i][width-1] = matrix[i][width-1], matrix[i][0]

		if width == 3 {
			m[i][1] = matrix[i][1]
		}
	}

	return m
}
