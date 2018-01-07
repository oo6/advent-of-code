package main

import (
	"fmt"
	"strconv"
	"strings"

	"./knothash"
)

func main() {
	fmt.Println(partOne("uugsqrei"))
	fmt.Println(partTwo("uugsqrei"))
}

func partOne(input string) int {
	count := 0

	for i := 0; i < 128; i++ {
		hash := knothash.Hash(input + "-" + strconv.Itoa(i))

		for j := 0; j < 4; j++ {
			v, _ := strconv.ParseInt(hash[j*8:(j+1)*8], 16, 64)
			count += strings.Count(strconv.FormatInt(v, 2), "1")
		}
	}

	return count
}

func partTwo(input string) int {
	hashes := make([]string, 128)

	for i := 0; i < 128; i++ {
		binary, hash := "", knothash.Hash(input+"-"+strconv.Itoa(i))

		for j := 0; j < 4; j++ {
			v, _ := strconv.ParseInt(hash[j*8:(j+1)*8], 16, 64)
			s := strconv.FormatInt(v, 2)

			for {
				if len(s) == 32 {
					break
				}
				s = "0" + s
			}
			binary += s
		}

		hashes[i] = binary
	}

	count, stat := 0, map[string]bool{}

	for r, hash := range hashes {
		for c, char := range hash {
			i, j := strconv.Itoa(r), strconv.Itoa(c)
			key := i + "-" + j

			if _, isPresent := stat[key]; isPresent {
				continue
			}

			if string(char) == "1" {
				stat[key] = true
				walkRegion(r, c, hashes, stat)

				count++
			}
		}
	}

	return count
}

func walkRegion(r int, c int, hashes []string, stat map[string]bool) {
	if top := r - 1; top >= 0 && string(hashes[top][c]) == "1" {
		i, j := strconv.Itoa(top), strconv.Itoa(c)
		key := i + "-" + j

		if _, isPresent := stat[key]; !isPresent {
			stat[key] = true
			walkRegion(top, c, hashes, stat)
		}
	}

	if right := c + 1; right < 128 && string(hashes[r][right]) == "1" {
		i, j := strconv.Itoa(r), strconv.Itoa(right)
		key := i + "-" + j

		if _, isPresent := stat[key]; !isPresent {
			stat[key] = true
			walkRegion(r, right, hashes, stat)
		}
	}

	if bottom := r + 1; bottom < 128 && string(hashes[bottom][c]) == "1" {
		i, j := strconv.Itoa(bottom), strconv.Itoa(c)
		key := i + "-" + j

		if _, isPresent := stat[key]; !isPresent {
			stat[key] = true
			walkRegion(bottom, c, hashes, stat)
		}
	}

	if left := c - 1; left >= 0 && string(hashes[r][left]) == "1" {
		i, j := strconv.Itoa(r), strconv.Itoa(left)
		key := i + "-" + j

		if _, isPresent := stat[key]; !isPresent {
			stat[key] = true
			walkRegion(r, left, hashes, stat)
		}
	}
}
