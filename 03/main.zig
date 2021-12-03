const std = @import("std");

const utils = @import("utils.zig");

const NUMBER_BITS = 12;

pub fn main() !void {
  const numbers = try utils.readBinary("input.txt");
  defer numbers.deinit();

  var positions = [_]isize{ 0 } ** NUMBER_BITS;
  for (numbers.items) |number| {
    for (positions) | position, index | {
      const mask = @intCast(u64, 1) << @intCast(u6, index);
      if (number & mask > 0) {
        positions[index] += 1;
      } else {
        positions[index] -= 1;
      }
    }
  }

  var gamma: isize = 0;
  var epsilon: isize = 0;
  for (positions) | position, index | {
    if (position > 0) {
      gamma |= @intCast(isize, 1) << @intCast(u6, index);
    } else if (position < 0) {
      epsilon |= @intCast(isize, 1) << @intCast(u6, index);
    }
  }

  std.debug.print("Part1: {d}\n", .{ gamma * epsilon });
  std.debug.assert(gamma * epsilon == 3912944);

  
}
