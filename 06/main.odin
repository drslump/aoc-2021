package day06

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container"

printf :: fmt.printf

Fish :: distinct int

read_input :: proc(path: string) -> [dynamic]Fish {
  content, ok := os.read_entire_file(path)
  if !ok {
    panic("could not read file")
  }
  defer delete(content)

  numbers := strings.split(string(content), ",")
  defer delete(numbers)

  values := make([dynamic]Fish, len(numbers))
  for number, idx in numbers {
    value, ok := strconv.parse_int(number, 10)
    if !ok {
      fmt.panicf("could not parse int: %s", number)
    }
    values[idx] = Fish(value)
  }

  return values
}

simulate_day :: proc(fishes: ^[dynamic]Fish) {
  created := make([dynamic]Fish, 0)
  defer delete(created)

  for fish, idx in fishes {
    if fish > 0 {
      fishes[idx] -= 1
    } else {
      fishes[idx] = 6
      // append with an extra day of life since they start counting on the next day
      // append(fishes, Fish(8 + 1))
      append(&created, Fish(8))
    }
  }

  for fish in created {
    append(fishes, fish)
  }
}

serialize :: proc(fishes: [dynamic]Fish) -> string {
  builder := strings.make_builder()
  for fish, idx in fishes {
    fmt.sbprint(&builder, fish)
    if (idx < len(fishes) - 1) {
      fmt.sbprint(&builder, ",")
    }
  }

  return strings.to_string(builder)
}


main :: proc() {
  values := read_input("sample.txt")
  defer delete(values) 

  // printf("Initial state: %s\n", serialize(values))
  // for day := 1; day <= 18; day += 1 {
  //   simulate_day(&values)
  //   printf("After Day %3d: %s\n", day, serialize(values))
  // }

  for day := 1; day <= 80; day += 1 {
    simulate_day(&values)
  }
  printf("Part1: %d\n", len(values))

  // XXX not possible to compute part 2 (256 days) with this approach
  // due to the exponential nature of the problem. Check efactored.odin

}

