package main

import (
	"aoc/inputfile"
	"fmt"
	"sort"
	"strings"
)

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	kv := transformToKV(strings.Split(input, "\n"))

	return len(figureOutGroup(kv, "0", []string{}))
}

func partTwo(input string) int {
	lines := strings.Split(input, "\n")
	count, kv, group := 0, transformToKV(lines), []string{}

	for i := 0; i < len(lines); i++ {
		id := strings.Split(lines[i], " <-> ")[0]

		if _, isPresent := kv[id]; isPresent {
			group = figureOutGroup(kv, id, group)
			kv = rejectIds(kv, group)
			count++
		}
	}

	return count
}

func transformToKV(lines []string) map[string]string {
	kv := map[string]string{}

	for _, line := range lines {
		result := strings.Split(line, " <-> ")
		kv[result[0]] = result[1]
	}

	return kv
}

func figureOutGroup(kv map[string]string, id string, group []string) []string {
	i := sort.SearchStrings(group, id)

	if i == len(group) || group[i] != id {
		group = append(group, id)
		sort.Strings(group)

		for _, id := range strings.Split(kv[id], ", ") {
			group = figureOutGroup(kv, id, group)
		}
	}

	return group
}

func rejectIds(kv map[string]string, group []string) map[string]string {
	result := map[string]string{}

	for id := range kv {
		i := sort.SearchStrings(group, id)

		if i == len(group) || group[i] != id {
			result[id] = kv[id]
		}
	}

	return result
}
