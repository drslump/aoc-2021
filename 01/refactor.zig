// After browsing a solutions thread on Reddit I found that there was no
// need to actually compare the windows, just the first number of A with
// the last one from B, since the other two numbers are the same for both
// windows.

const std = @import("std");
const debug = std.debug;

const utils = @import("utils.zig");

fn compute(slice: []i64, gap: usize) usize {
  var num_incr: usize = 0;
  for (slice[gap..slice.len]) |value, idx| {
    if (value > slice[idx]) num_incr += 1;
  } 
  return num_incr;
}

pub fn main() !void {
  const values = utils.readInput("input.txt") catch {
    debug.warn("Could not read input", .{});
    std.os.exit(1);
  };
  defer values.deinit();

  debug.print("Part1: {d}\n", .{ compute(values.items, 1) });
  debug.print("Part2: {d}\n", .{ compute(values.items, 3) });
}
