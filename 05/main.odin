package day05

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

printf :: fmt.printf

Point :: struct {
  x, y: int,
}

Segment :: struct {
  begin: Point,
  end: Point,
}

parse_coords :: proc(s: string) -> Point {
  parts := strings.split(s, ",")
  x, ok_x := strconv.parse_int(parts[0], 10)
  if !ok_x {
    fmt.panicf("could not parse int: %s", parts[1])
  }
  y, ok_y := strconv.parse_int(parts[1], 10)
  if !ok_y {
    fmt.panicf("could not parse int: %s", parts[1])
  }
  return Point { x = x, y = y }
}

read_lines :: proc(path: string) -> []Segment {
  content, ok := os.read_entire_file(path)
  if !ok {
    panic("could not read file")
  }
  defer delete(content)

  lines := strings.split(string(content), "\n")
  defer delete(lines)

  values := make([]Segment, len(lines))
  for line, idx in lines {
    pair := strings.split(line, " -> ")
    value := Segment {
      begin = parse_coords(pair[0]),
      end = parse_coords(pair[1]),
    }
    values[idx] = value
  }

  return values
}

Table :: struct {
  size: int,
  data: []int,
}


create_table :: proc(segments: []Segment, diagonals: bool = false) -> ^Table {
  max_pos := 0
  for segment in segments {
    using segment
    max_pos = max(max_pos, begin.x, begin.y, end.x, end.y)
  }

  table := new(Table)
  table.size = max_pos + 1
  table.data = make([]int, table.size * table.size)

  for segment in segments {
    using segment

    dir_x, dir_y, diff : int

    if begin.x != end.x {
      dir_x = begin.x < end.x ? 1 : -1
      diff = (end.x - begin.x) * dir_x
    }

    if begin.y != end.y {
      dir_y = begin.y < end.y ? 1 : -1
      diff = (end.y - begin.y) * dir_y
    }

    if !diagonals && dir_x != 0 && dir_y != 0 {
      continue
    }

    ofs := begin.y * table.size + begin.x
    for step := 0; step <= diff; step += 1 {
      table.data[ofs] += 1
      ofs += dir_y * table.size + dir_x
    }
  }

  return table
}

free_table :: proc(table: ^Table) {
  delete(table.data)
  free(table)
}

count_cells_with_at_least :: proc(table: ^Table, value: int) -> int {
  count := 0
  for cell in table.data {
    if cell >= value {
      count += 1
    }
  }
  return count
}

draw_table :: proc(table: ^Table) {
  for cell, idx in table.data {
    if idx > 0 && idx % table.size == 0 {
      printf("\n")
    }
    if cell > 0 {
      printf("%d", cell)
    } else {
      printf(".")
    }
  }
  printf("\n")
}

main :: proc() {
  values := read_lines("input.txt")
  defer delete(values) 

  table1 := create_table(values)
  defer free_table(table1)

  // draw_table(table1)

  part1 := count_cells_with_at_least(table1, 2)
  printf("Part1: %d\n", part1)
  assert(part1 == 5306)

  table2 := create_table(values, true)
  defer free_table(table2)

  // draw_table(table2)

  part2 := count_cells_with_at_least(table2, 2)
  printf("Part2: %d\n", part2)
}

