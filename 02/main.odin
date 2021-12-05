package day02

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

printf :: fmt.printf


Position :: struct {
  x, y, aim: int,
}

/// Represents the direction the submarine is taking
Direction :: enum {
  Up,
  Down,
  Forward,
}

/// Represents a movement of the submarine.
Movement :: struct {
  direction: Direction,
  value: int,
}

/// Parses a direction string into the enum
parse_direction :: proc (val: string) -> Direction {
  switch val {
    case "up": return .Up
    case "down": return .Down
    case "forward": return .Forward
    case:
      fmt.panicf("Unknown direction: %s", val)
  }
}

read_lines :: proc(path: string) -> []Movement {
  content, ok := os.read_entire_file(path)
  if !ok {
    panic("could not read file")
  }
  defer delete(content)

  lines := strings.split(string(content), "\n")
  defer delete(lines)

  movements := make([]Movement, len(lines))
  for line, idx in lines {
    parts := strings.split(line, " ")
    defer delete(parts)

    assert(len(parts) == 2)

    direction := parse_direction(parts[0])
    value, ok := strconv.parse_int(parts[1], 10)
    if !ok {
      fmt.panicf("could not parse int: %s", parts[1])
    }

    movement := Movement { direction=direction, value=value };
    movements[idx] = movement
  }

  return movements
}

part1 :: proc(pos: ^Position, movement: Movement) {
  switch (movement.direction) {
    case .Up:
      pos.y -= movement.value
    case .Down:
      pos.y += movement.value
    case .Forward:
      pos.x += movement.value
  }
}

part2 :: proc(pos: ^Position, movement: Movement) {
  switch (movement.direction) {
    case .Up:
      pos.aim -= movement.value
    case .Down:
      pos.aim += movement.value
    case .Forward:
      pos.x += movement.value
      pos.y += pos.aim * movement.value
  }
}

main :: proc() {
  movements := read_lines("input.txt")
  defer delete(movements)

  pos1 := Position { x = 0, y = 0, aim = 0 }
  pos2 := Position { x = 0, y = 0, aim = 0 }

  for movement in movements {
    part1(&pos1, movement)
    part2(&pos2, movement);
  }  

  printf("Part 1: %d\n", pos1.x * pos1.y)
  assert(pos1.x * pos1.y == 1654760)

  printf("Part 2: %d\n", pos2.x * pos2.y)
  assert(pos2.x * pos2.y == 1956047400)
}
