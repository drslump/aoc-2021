package day07

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:math"

sample_txt :: string(#load("sample.txt"))
input_txt :: string(#load("input.txt"))

compute :: proc(crabs: []int, mapper: proc (int) -> int) -> int {
  lo := slice.min(crabs)
  hi := slice.max(crabs)

  lowest_cost: int = max(int)
  for position in lo..=hi {
    cost := 0
    for crab in crabs {
      cost += mapper(abs(crab - position))
    }
    if cost < lowest_cost {
      lowest_cost = cost
    }
  }

  return lowest_cost
}


main :: proc() {
	csv := strings.split(input_txt, ",")
	crabs := slice.mapper(csv, strconv.atoi)
	defer delete(crabs)

  mapper1 :: proc(x: int) -> int { return x }
	part1 := compute(crabs, mapper1)
	fmt.printf("Part 1: %d\n", part1)
	assert(part1 == 349812)

  mapper2 :: proc(x: int) -> int {
    return x * (x + 1) / 2
  }
	part2 := compute(crabs, mapper2)
	fmt.printf("Part 2: %d\n", part2)
	assert(part2 == 99763899)
}
