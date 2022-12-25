package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sync"
)

type Blueprint struct {
  id int
  ore_robot_ore_cost int
  clay_robot_ore_cost int
  obsidian_robot_ore_cost int
  obsidian_robot_clay_cost int
  geode_robot_ore_cost int
  geode_robot_obsidian_cost int
}

func IntAbs(x int) int {
	if x < 0 {
		return -1 * x
	}
	return x
}

func ManhattanDistance(a Point, b Point) int {
	return IntAbs(a.x-b.x) + IntAbs(a.y-b.y)
}

func UpdateMinMax(p Point, min_pt *Point, max_pt *Point) {
	if p.x > max_pt.x {
		max_pt.x = p.x
	}
	if p.y > max_pt.y {
		max_pt.y = p.y
	}

	if p.x < min_pt.x {
		min_pt.x = p.x
	}
	if p.y < min_pt.y {
		min_pt.y = p.y
	}
}

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var sensor_points = make([]Point, 0)
	var beacon_points = make([]Point, 0)
	var m_dists = make([]int, 0)

	all_points := make(map[Point]int)

	min_pt := Point{0, 0}
	max_pt := Point{0, 0}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		sensor := Point{0, 0}
		beacon := Point{0, 0}
		fmt.Sscanf(line, "Blueprint %d: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 17 clay. Each geode robot costs 4 ore and 16 obsidian.",
			&sensor.x, &sensor.y, &beacon.x, &beacon.y)

		m_dist := ManhattanDistance(sensor, beacon)

		UpdateMinMax(sensor, &min_pt, &max_pt)
		UpdateMinMax(beacon, &min_pt, &max_pt)

		sensor_points = append(sensor_points, sensor)
		beacon_points = append(beacon_points, beacon)
		m_dists = append(m_dists, m_dist)

		all_points[sensor] = 1
		all_points[beacon] = 1
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	dx := max_pt.x - min_pt.x
	dy := max_pt.y - min_pt.y
	min_pt.x -= dx
	min_pt.y -= dy
	max_pt.x += dx
	max_pt.y += dy

	y := 2000000
	var counter = 0
	for x := min_pt.x; x <= max_pt.x; x++ {
		p := Point{x, y}
		if _, ok := all_points[p]; ok {
			continue
		}
		for i, s := range sensor_points {
			dist := ManhattanDistance(s, p)
			if dist <= m_dists[i] {
				// This is an impossible position
				counter += 1
				break
			}
		}
	}

	fmt.Println(counter)

	constraint := 4000000
	chunk := 100000

	var wg sync.WaitGroup
	wg.Add(constraint / chunk)

	for i := 0; i < constraint/chunk; i++ {
		go func(start int) {
			initial := start * chunk
			for i := initial; i < (initial + chunk); i++ {
				for x := i; x <= constraint; {
					p := Point{x, i}
					if _, ok := all_points[p]; ok {
						x += 1
						continue
					}
					var impossible = false
					var max_delta = 1
					for i, s := range sensor_points {
						dist := ManhattanDistance(s, p)
						if dist <= m_dists[i] {
							// This is an impossible position
							impossible = true
							delta := s.x + m_dists[i] - IntAbs(s.y-p.y) - p.x
							if delta > max_delta {
								max_delta = delta
								break
							}
						}
					}

					if !impossible {
						fmt.Println("Solution", p.x*4000000+p.y, p)
						wg.Done()
						return
					}

					x += max_delta
				}

				for y := i; y <= constraint; {
					p := Point{i, y}
					if _, ok := all_points[p]; ok {
						y += 1
						continue
					}
					var impossible = false
					var max_delta = 1
					for i, s := range sensor_points {
						dist := ManhattanDistance(s, p)
						if dist <= m_dists[i] {
							// This is an impossible position
							impossible = true
							delta := s.y + m_dists[i] - IntAbs(s.x-p.x) - p.y
							if delta > max_delta {
								max_delta = delta
								break
							}
						}
					}

					if !impossible {
						fmt.Println("Solution", p.x*4000000+p.y, p)
						wg.Done()
						return
					}

					y += max_delta
				}
			}

			wg.Done()
		}(i)
	}

	wg.Wait()
}
