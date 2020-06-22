package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

const up string = "up"
const down string = "down"
const left string = "left"
const right string = "right"

func main() {
	input, _ := ioutil.ReadFile("input.txt")

	fmt.Println(partOne(string(input)))
	fmt.Println(partTwo(string(input)))
}

func partOne(input string) string {
	lines := strings.Split(input, "\n")
	grid := generate(lines)

	result := ""
	pos, dir := []int{0, len(lines[0]) - 1}, down

	for {
		var value string

		if value, pos, dir = next(pos, dir, grid); value != "" {
			if matched, _ := regexp.MatchString(`[A-Z]`, value); matched {
				result += value
			}

			continue
		}

		if dir = turn(pos, dir, grid); dir != "" {
			continue
		}

		break
	}

	return result
}

func partTwo(input string) int {
	lines := strings.Split(input, "\n")
	grid := generate(lines)

	count := 1
	pos, dir := []int{0, len(lines[0]) - 1}, down

	for {
		var value string

		if value, pos, dir = next(pos, dir, grid); value != "" {
			count++

			continue
		}

		if dir = turn(pos, dir, grid); dir != "" {
			continue
		}

		break
	}

	return count
}

func generate(lines []string) map[string]string {
	grid := map[string]string{}

	for i := 1; i < len(lines); i++ {
		for j, c := range strings.Split(lines[i], "") {
			if c != " " {
				key := strconv.Itoa(i) + "," + strconv.Itoa(j)
				grid[key] = c
			}
		}
	}

	return grid
}

func next(pos []int, dir string, grid map[string]string) (string, []int, string) {
	i, j := pos[0], pos[1]

	switch dir {
	case up:
		i--
	case down:
		i++
	case left:
		j--
	case right:
		j++
	}

	key := strconv.Itoa(i) + "," + strconv.Itoa(j)

	if value, isPresent := grid[key]; isPresent {
		return value, []int{i, j}, dir
	}

	return "", pos, dir
}

func turn(pos []int, dir string, grid map[string]string) string {
	list := []string{}

	if dir == up || dir == down {
		list = []string{left, right}
	}
	if dir == left || dir == right {
		list = []string{up, down}
	}

	for _, dir := range list {
		if value, _, _ := next(pos, dir, grid); value != "" {
			return dir
		}
	}

	return ""
}
