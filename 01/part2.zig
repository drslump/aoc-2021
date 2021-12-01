const std = @import("std");
const debug = std.debug;

const utils = @import("utils.zig");

fn sum_array(array: []i64) i64 {
  var sum: i64 = 0;
  for (array) |value| {
    sum += value;
  }
  return sum;
}


pub fn main() !void {
  const values = utils.readInput("input.txt") catch {
    debug.warn("Could not read input", .{});
    std.os.exit(1);
  };
  defer values.deinit();

  var accum = [3]i64 { 0, 0, 0 };
  var previous: i64 = 0;
  var num_incr: usize = 0;
  for (values.items) |value, index| {
    accum[index % 3] = value;
    var current = sum_array(&accum);
    if (index < 3) {
      previous = current;
      continue;
    }

    if (current > previous) {
      num_incr += 1;
    }
    previous = current;
  }

  debug.print("Result: {d}\n", .{ num_incr });
}
