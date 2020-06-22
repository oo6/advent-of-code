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
	count := 0
	rows := strings.Split(input, "\n")

	for _, row := range rows {
		words := strings.Split(row, " ")
		sort.Strings(words)

		for j, word := range words {
			if j == len(words)-1 {
				count = count + 1
				break
			}

			i := sort.SearchStrings(words, word)
			if words[i+1] == word {
				break
			}
		}
	}

	return count
}

func partTwo(input string) int {
	count := 0
	rows := strings.Split(input, "\n")

	for _, row := range rows {
		words := sortStrings(strings.Split(row, " "))

		for j, word := range words {
			if j == len(words)-1 {
				count = count + 1
				break
			}

			i := sort.SearchStrings(words, word)
			if words[i+1] == word {
				break
			}
		}
	}

	return count
}

func sortStrings(words []string) []string {
	sortedWords := make([]string, len(words))

	for i, word := range words {
		strs := strings.Split(word, "")
		sort.Strings(strs)
		sortedWords[i] = strings.Join(strs, "")
	}

	sort.Strings(sortedWords)
	return sortedWords
}
