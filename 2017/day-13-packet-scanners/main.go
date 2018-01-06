package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	input := `0: 3
1: 2
2: 9
4: 4
6: 4
8: 6
10: 6
12: 8
14: 5
16: 6
18: 8
20: 8
22: 8
24: 6
26: 12
28: 12
30: 8
32: 10
34: 12
36: 12
38: 10
40: 12
42: 12
44: 12
46: 12
48: 14
50: 14
52: 8
54: 12
56: 14
58: 14
60: 14
64: 14
66: 14
68: 14
70: 14
72: 14
74: 12
76: 18
78: 14
80: 14
86: 18
88: 18
94: 20
98: 18`

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	severity, lines := 0, strings.Split(input, "\n")

	for i := 0; i < len(lines); i++ {
		result := strings.Split(lines[i], ": ")
		d, _ := strconv.Atoi(result[0])
		r, _ := strconv.Atoi(result[1])

		if d%((r-1)*2) == 0 {
			severity = severity + d*r
		}
	}

	return severity
}

func partTwo(input string) int {
	lines := strings.Split(input, "\n")
	length := len(lines)

	for i := 0; ; i++ {
		for j := 0; j < length; j++ {
			result := strings.Split(lines[j], ": ")
			d, _ := strconv.Atoi(result[0])
			r, _ := strconv.Atoi(result[1])

			if (d+i)%((r-1)*2) == 0 {
				break
			}

			if j == length-1 {
				return i
			}
		}
	}
}
