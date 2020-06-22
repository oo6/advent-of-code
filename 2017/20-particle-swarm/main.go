package main

import (
	"aoc/inputfile"
	"fmt"
	"math"
	"strconv"
	"strings"
)

func main() {
	input := inputfile.Read()

	fmt.Println(partOne(input))
	fmt.Println(partTwo(input))
}

func partOne(input string) int {
	particles := generate(input)

	for i := 0; i < len(particles)/20; i++ {
		particles = run(particles)
	}

	p := particles[0]["p"]
	index, sum := 0, math.Abs(p[0])+math.Abs(p[1])+math.Abs(p[2])

	for i := 0; i < len(particles); i++ {
		p := particles[i]["p"]
		x, y, z := math.Abs(p[0]), math.Abs(p[1]), math.Abs(p[2])

		if sum > x+y+z {
			index, sum = i, x+y+z
		}
	}

	return index
}

func partTwo(input string) int {
	particles := generate(input)
	length := len(particles)

	for i := 0; i < length/20; i++ {
		particles = run(particles)
		temp := []map[string][]float64{}

		for j, outer := range particles {
			for k, inner := range particles {
				if j != k && outer["p"][0] == inner["p"][0] && outer["p"][1] == inner["p"][1] && outer["p"][2] == inner["p"][2] {
					break
				}

				if k == len(particles)-1 {
					temp = append(temp, outer)
				}
			}
		}

		particles = temp
	}

	return len(particles)
}

func generate(input string) []map[string][]float64 {
	lines := strings.Split(input, "\n")
	temp := make([]map[string][]float64, len(lines))

	for i := 0; i < len(lines); i++ {
		items := strings.Split(lines[i], ", ")
		particle := map[string][]float64{}

		for _, item := range items {
			xyz := strings.Split(item[3:len(item)-1], ",")

			x, _ := strconv.Atoi(xyz[0])
			y, _ := strconv.Atoi(xyz[1])
			z, _ := strconv.Atoi(xyz[2])

			particle[item[0:1]] = []float64{float64(x), float64(y), float64(z)}
		}

		temp[i] = particle
	}

	return temp
}

func run(particles []map[string][]float64) []map[string][]float64 {
	temp := make([]map[string][]float64, len(particles))

	for j, particle := range particles {
		p, v, a := particle["p"], particle["v"], particle["a"]

		v = []float64{v[0] + a[0], v[1] + a[1], v[2] + a[2]}
		particle["v"] = v
		particle["p"] = []float64{p[0] + v[0], p[1] + v[1], p[2] + v[2]}

		temp[j] = particle
	}

	return temp
}
