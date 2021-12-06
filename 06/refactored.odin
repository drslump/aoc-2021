// This solution is based on others found online.
// By using buckets to group the different fish by their remaining days
// the problem becomes much easier to solve since the same algorithm
// applies to every fish in that group.
//

package day06

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"

sample_txt :: string(#load("sample.txt"))
input_txt :: string(#load("input.txt"))

// the range of values is 0-8
FishAge :: distinct int

count_after_days :: proc(ages: []FishAge, days: int) -> int {
  buckets : [9]FishAge
  for age in ages {
    buckets[age] += 1
  }

  for day in 1..=days {
    expired := buckets[0]
    for i in 1..<9 {
      buckets[i - 1] = buckets[i]
    }
    // the expired ones recycle as 6 and create a new one with 8
    buckets[6] += expired
    buckets[8] = expired
  }

  sum := 0
  for b in buckets {
    sum += int(b)
  }

  return sum
}

str_to_FishAge := proc(s: string) -> FishAge {
  return FishAge(strconv.atoi(s))
}

main :: proc() {
  csv := strings.split(input_txt, ",")
  ages := slice.mapper(csv, str_to_FishAge)
  defer delete(ages)

  part1 := count_after_days(ages, 80)
  assert(part1 == 346063)
  fmt.printf("Part 1: %d\n", part1)

  part2 := count_after_days(ages, 256)
  assert(part2 == 1572358335990)
  fmt.printf("Part 2: %d\n", part2)  
}
