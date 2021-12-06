package day03

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"

input_txt :: string(#load("input.txt"))

parse_input :: proc(input: string) -> []string {
  lines := strings.split(input, "\n")
  return lines
}

part1 :: proc(input: []string) -> int {
  assert(len(input) > 0)
  num_bits := len(input[0])
  ones_count := make([]int, num_bits)

  for line in input {
    for bit, idx in line {
      ones_count[idx] += bit == '1' ? 1 : 0
    }
  }

  gamma, epsilon: int 
  for bit, i in ones_count {
    if bit >= len(input) - bit {
      gamma |= (1 << uint(num_bits - 1 - i))
    } else {
      epsilon |= (1 << uint(num_bits - 1 - i))
    }
  }

  return gamma * epsilon
}

part2 :: proc(input: []string) -> int {

  find_number :: proc(nums: []string, flip: bool) -> int {
    i: int
    temp := nums
    for len(temp) > 1 {
      zeroes: int
      for n in temp do zeroes += n[i] == '0' ? 1 : 0
  
      if len(temp) - zeroes >= zeroes {
        temp = flip ? temp[:zeroes] : temp[zeroes:]
      } else {
        temp = flip ? temp[zeroes:] : temp[:zeroes]
      }
  
      i += 1
    }
  
    n, _ := strconv.parse_int(temp[0], 2)
    return n
  }
  
  slice.sort(input)

  oxygen := find_number(input[:], false)
  co2 := find_number(input[:], true)

  return oxygen * co2
}


main :: proc() {
  values := parse_input(input_txt)
  defer delete(values)

  part1 := part1(values)
  fmt.printf("Part 1: %d\n", part1)
  assert(part1 == 3912944)

  part2 := part2(values)
  fmt.printf("Part 2: %d\n", part2)
  assert(part2 == 4996233)
}
