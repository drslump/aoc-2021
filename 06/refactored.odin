package day06

/*
  This solution is based on others found online.
  By using buckets to group the different fish by their remaining days
  the problem becomes much easier to solve since the same algorithm
  applies to every fish in that group.
*/


import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:math"

sample_txt :: string(#load("sample.txt"))
input_txt :: string(#load("input.txt"))

count_after_days :: proc(ages: []int, days: int) -> int {
	buckets: [9]int 
	for age in ages {
		buckets[age] += 1
	}

	for day in 1 ..= days {
		expired := buckets[0]
		#unroll for i in 1 ..< 9 {
			buckets[i - 1] = buckets[i]
		}
		// the expired ones recycle as 6 and create a new one with 8
		buckets[6] += expired
		buckets[8] = expired
	}

	return math.sum(buckets[:])
}

main :: proc() {
	csv := strings.split(input_txt, ",")
	ages := slice.mapper(csv, strconv.atoi)
	defer delete(ages)

	part1 := count_after_days(ages, 80)
	fmt.printf("Part 1: %d\n", part1)
	assert(part1 == 346063)

	part2 := count_after_days(ages, 256)
	fmt.printf("Part 2: %d\n", part2)
	assert(part2 == 1572358335990)
}
