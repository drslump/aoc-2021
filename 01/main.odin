package day01

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

printf :: fmt.printf

readLines :: proc(path: string) -> []int {
  content, ok := os.read_entire_file(path)
  if !ok {
    panic("could not read file")
  }
  defer delete(content)

  lines := strings.split(string(content), "\n")
  defer delete(lines)

  values := make([]int, len(lines))
  for line, idx in lines {
    value, ok := strconv.parse_int(line, 10)
    if !ok {
      fmt.panicf("could not parse int: %s", line)
    }
    values[idx] = value
  }

  return values
}

compute :: proc(slice: []int, gap: uint) -> int {
  num_incr := 0
  for value, idx in slice[gap:] {
    if value > slice[idx] { num_incr += 1 }
  } 
  return num_incr
}

main :: proc() {
  values := readLines("input.txt")
  defer delete(values)

  part1 := compute(values, 1)
  printf("Part1: %d\n", part1)

  part2 := compute(values, 3)
  printf("Part2: %d\n", part2)
}
