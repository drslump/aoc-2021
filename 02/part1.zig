const std = @import("std");

const utils = @import("utils.zig");

const Position = struct {
  x: i64,
  y: i64,
  aim: i64,
};

fn part1(pos: *Position, movement: utils.Movement) void {
  switch (movement.direction) {
    .Up => {
      pos.y -= movement.value;
    },
    .Down => {
      pos.y += movement.value;
    },
    .Forward => {
      pos.x += movement.value;
    },
  }
}

fn part2(pos: *Position, movement: utils.Movement) void {
  switch (movement.direction) {
    .Up => {
      pos.aim -= movement.value;
    },
    .Down => {
      pos.aim += movement.value;
    },
    .Forward => {
      pos.x += movement.value;
      pos.y += pos.aim * movement.value;
    },
  }
}

pub fn main() !void {
  const movements = try utils.readMovements("input.txt");
  defer movements.deinit();

  var pos1 = Position { .x = 0, .y = 0, .aim = 0 };
  var pos2 = Position { .x = 0, .y = 0, .aim = 0 };
  for (movements.items) |movement| {
    part1(&pos1, movement);
    part2(&pos2, movement);
  }  

  std.debug.print("Part1: {d}\n", .{ pos1.x * pos1.y });
  std.debug.print("Part2: {d}\n", .{ pos2.x * pos2.y });
}
