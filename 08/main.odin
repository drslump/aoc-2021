package day08

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:math"

sample_txt :: string(#load("sample.txt"))
input_txt :: string(#load("input.txt"))

part1 :: proc(lines: []string) -> int {
  sum := 0
  for line in lines {
    parts := strings.split(line, "|")
    defer delete(parts)
    outputs := strings.split(parts[1], " ")
    defer delete(outputs)
    for output in outputs {
      if output == "" {
        continue
      }
      l := len(output)
      // 1:2, 4:4, 7:3, 8:7
      if l == 2 || l == 4 || l == 3 || l == 7 {
        sum += 1
      }
    }
  }

  return sum
}


main :: proc() {
	lines := strings.split(input_txt, "\n")
	defer delete(lines)

  result1 := part1(lines)
  fmt.println("Part 1: ", result1)
  assert(result1 == 355)
}
