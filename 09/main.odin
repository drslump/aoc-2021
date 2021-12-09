package day09

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:math"

sample_txt :: string(#load("sample.txt"))
input_txt :: string(#load("input.txt"))

HeightMap :: struct {
  width: int,
  height: int,
  cells: []int,
}

parse_map :: proc (input: string) -> HeightMap {
  lines := strings.split(input, "\n")
  assert(len(lines) > 1)

  width := len(lines[0])
  height := len(lines)
  cells := make([]int, width * height)
  heightmap := HeightMap { width = width, height = height, cells = cells }

  ofs := 0
  for line in lines {
    digits := strings.split(line, "")
    values := slice.mapper(digits, strconv.atoi)
    for value in values {
      cells[ofs] = value
      ofs += 1
    }
  }

  return heightmap
}

free_map :: proc (heightmap: HeightMap) {
  delete(heightmap.cells)
}

get_cell :: proc (heightmap: HeightMap, x: int, y: int) -> int {
  return heightmap.cells[y * heightmap.width + x]
}

is_low_point :: proc(heightmap: HeightMap, x: int, y: int) -> bool {
  target := get_cell(heightmap, x, y)
  if x > 0 && target >= get_cell(heightmap, x - 1, y) {
    return false
  }
  if x + 1 < heightmap.width && target >= get_cell(heightmap, x + 1, y) {
    return false
  }
  if y > 0 && target >= get_cell(heightmap, x, y - 1) {
    return false
  }
  if y + 1 < heightmap.height && target >= get_cell(heightmap, x, y + 1) {
    return false
  }
  return true
}

part1 :: proc(heightmap: HeightMap) -> int {
  risk_levels := 0

  for y in 0..<heightmap.height {
    for x in 0..<heightmap.width {
      if is_low_point(heightmap, x, y) {
        low_point := get_cell(heightmap, x, y)
        risk_levels += low_point + 1
      }
    }
  }

  return risk_levels
}


main :: proc() {
  heightmap := parse_map(input_txt)
	defer free_map(heightmap)

  result1 := part1(heightmap)
  fmt.println("Part 1: ", result1)
  assert(result1 == 506)
}
