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

	// fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partTwo(input string) int {
	result, registers := 0, map[string]int{"p": 0}
	messages := make([]int, 0)
	lines := strings.Split(input, "\n")
	index := 0
	regs := map[string]int{"p": 1}

	for i := 0; i < 26; i++ {
		r := strings.Split(lines[i], " ")
		op, k := r[0], r[1]
		var v int
		var isPresent bool

		if len(r) > 2 {
			if v, isPresent = registers[r[2]]; !isPresent {
				v, _ = strconv.Atoi(r[2])
			}
		}

		var value int
		if value, isPresent = registers[k]; !isPresent {
			value = 0
		}

		switch op {
		case "snd":
			messages = append(messages, value)
		case "set":
			registers[k] = v
		case "add":
			registers[k] = value + v
		case "mul":
			registers[k] = value * v
		case "mod":
			registers[k] = value % v
		case "rcv":
			// TODO: something
			var isEnd bool
			if v, index, regs, messages, isEnd = execB(lines, index, regs, messages); isEnd {

				return result
			}
			// fmt.Println(v)
			// fmt.Println(index)
			// fmt.Println(messages)
			// fmt.Println(isEnd)
			// fmt.Println("===================")
			result = result + 1
			registers[k] = v
		case "jgz":
			if value > 0 {
				i = i + v - 1
			}
		}

		if result == 7620 {
			fmt.Println(len(messages))
			break
		}
	}

	return result
}

func execB(lines []string, index int, registers map[string]int, messages []int) (int, int, map[string]int, []int, bool) {
	for i := index; i < len(lines); i++ {
		r := strings.Split(lines[i], " ")
		op, k := r[0], r[1]
		var v int
		var isPresent bool

		if len(r) > 2 {
			if v, isPresent = registers[r[2]]; !isPresent {
				v, _ = strconv.Atoi(r[2])
			}
		}

		var value int
		if value, isPresent = registers[k]; !isPresent {
			value = 0
		}

		switch op {
		case "snd":
			return value, i + 1, registers, messages, false
		case "set":
			registers[k] = v
		case "add":
			registers[k] = value + v
		case "mul":
			registers[k] = value * v
		case "mod":
			registers[k] = value % v
		case "rcv":
			// TODO: something
			if len(messages) == 0 {
				return 0, 0, registers, messages, true
			}
			v, messages = messages[0], messages[1:]
			registers[k] = v
		case "jgz":
			if value > 0 {
				i = i + v - 1
			}
		}

		fmt.Println(op)
		fmt.Println(registers)
	}

	return 1, 0, registers, messages, true
}

func partOne(input string) int {
	// result, registers := 0, map[string]int{}
	// lines := strings.Split(input, "\n")
	//
	// for i := 0; i < len(lines); i++ {
	// 	r := strings.Split(lines[i], " ")
	// 	op, k, v := r[0], r[1], 0
	//
	// 	if len(r) > 2 {
	// 		isPresent := false
	// 		if v, isPresent = registers[r[2]]; !isPresent {
	// 			v, _ = strconv.Atoi(r[2])
	// 		}
	// 	}
	//
	// 	value := 0
	// 	if v, isPresent := registers[k]; isPresent {
	// 		value = v
	// 	}
	//
	// 	switch op {
	// 	case "snd":
	// 		result = value
	// 	case "set":
	// 		registers[k] = v
	// 	case "add":
	// 		registers[k] = value + v
	// 	case "mul":
	// 		registers[k] = value * v
	// 	case "mod":
	// 		registers[k] = value % v
	// 	case "rcv":
	// 		if value > 0 {
	// 			return result
	// 		}
	// 	case "jgz":
	// 		if value > 0 {
	// 			i = i + v - 1
	// 		}
	// 	}
	// }
	//
	// return result
	return 0
}
