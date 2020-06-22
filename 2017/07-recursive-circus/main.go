package main

import (
	"aoc/inputfile"
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// Tree ...
type Tree struct {
	name       string
	selfWeight int
	weight     int
	branches   []Tree
}

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) string {
	name := getRootName(strings.Split(input, "\n"))
	return name
}

func partTwo(input string) int {
	lines := strings.Split(input, "\n")
	name, kv := getRootName(lines), transformToKV(lines)

	return calculateWeight(transformToTree(name, kv, lines))
}

func getRootName(lines []string) string {
	length := len(lines)

	for i := 0; i < length; i++ {
		if !strings.Contains(lines[i], "->") {
			continue
		}

		name := strings.Split(lines[i], " ")[0]

		for j, line := range lines {
			if i == j {
				continue
			}

			if strings.Contains(line, "->") {
				names := strings.Split(strings.Split(line, " -> ")[1], ", ")
				sort.Strings(names)

				index := sort.SearchStrings(names, name)

				if index != len(names) && names[index] == name {
					break
				}
			}

			if j == length-1 {
				return name
			}
		}
	}

	return ""
}

func transformToKV(lines []string) map[string]int {
	kv := map[string]int{}

	for i, line := range lines {
		name := strings.Split(line, " ")[0]
		kv[name] = i
	}

	return kv
}

func calculateWeight(t Tree) int {
	minIndex, maxIndex, branches := 0, 0, t.branches
	weights := make([]int, len(branches))

	for i, branch := range branches {
		if len(branch.branches) > 0 {
			weight := calculateWeight(branch)

			if weight != 0 {
				return weight
			}
		}

		if branches[minIndex].weight > branch.weight {
			minIndex = i
		}
		if branches[maxIndex].weight < branch.weight {
			maxIndex = i
		}

		weights[i] = branch.weight
	}

	if weights[maxIndex] == weights[minIndex] {
		return 0
	}

	diff := weights[maxIndex] - weights[minIndex]
	sort.Ints(weights)

	if branches[minIndex].weight == weights[1] {
		return branches[maxIndex].selfWeight - diff
	}

	return branches[minIndex].selfWeight + diff
}

func transformToTree(name string, kv map[string]int, lines []string) Tree {
	line := lines[kv[name]]
	selfWeight := getSelfWeight(line)
	weight, branches := selfWeight, []Tree{}

	if strings.Contains(line, "->") {
		names := strings.Split(strings.Split(line, " -> ")[1], ", ")
		branches = make([]Tree, len(names))

		for i, name := range names {
			branches[i] = transformToTree(name, kv, lines)
			weight += branches[i].weight
		}
	}

	return Tree{strings.Split(line, " ")[0], selfWeight, weight, branches}
}

func getSelfWeight(line string) int {
	re, _ := regexp.Compile(`\((.*)\)`)
	weight, _ := strconv.Atoi(string(re.FindSubmatch([]byte(line))[1]))

	return weight
}
