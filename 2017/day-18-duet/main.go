package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	input := `set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 622
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19`

	fmt.Println(partOne(input))
}

func partOne(input string) int {
	result, registers := 0, map[string]int{}
	lines := strings.Split(input, "\n")

	for i := 0; i < len(lines); i++ {
		r := strings.Split(lines[i], " ")
		op, k, v := r[0], r[1], 0

		if len(r) > 2 {
			isPresent := false
			if v, isPresent = registers[r[2]]; !isPresent {
				v, _ = strconv.Atoi(r[2])
			}
		}

		value := 0
		if v, isPresent := registers[k]; isPresent {
			value = v
		}

		switch op {
		case "snd":
			result = value
		case "set":
			registers[k] = v
		case "add":
			registers[k] = value + v
		case "mul":
			registers[k] = value * v
		case "mod":
			registers[k] = value % v
		case "rcv":
			if value > 0 {
				return result
			}
		case "jgz":
			if value > 0 {
				i = i + v - 1
			}
		}
	}

	return result
}
