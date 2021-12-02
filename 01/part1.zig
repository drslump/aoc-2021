const std = @import("std");
const debug = std.debug;

const utils = @import("utils.zig");

pub fn main() !void {
  const values = utils.readInput("input.txt") catch {
    debug.warn("Could not read input", .{});
    std.os.exit(1);
  };
  defer values.deinit();

  var num_increases: i64 = 0;
  var previous: i64 = -1; 
  for (values.items) |current| {
    if (previous != -1 and current > previous) {
      num_increases += 1;
    }
    previous = current;
  }

  debug.print("Result: {d}\n", .{ num_increases });
}