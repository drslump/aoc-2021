const std = @import("std");
const fs = std.fs;
const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

pub fn range(len: usize) []const u0 {
  return @as([*]u0, undefined)[0..len];
}

/// Parses a text file where each line define a movement.
pub fn readBinary(path: []const u8) !ArrayList(u64) {
  const contents = try fs.cwd().readFileAlloc(allocator, path, 2 << 16);
  defer allocator.free(contents);

  var list = ArrayList(u64).init(allocator);

  var line_no: usize = 1;
  var lines = std.mem.split(contents, "\n");
  while (lines.next()) |line| : (line_no += 1) {
    const value = std.fmt.parseInt(usize, line, 2) catch {
      std.debug.warn("Could not parse line {d}: {s}\n", .{ line_no, line });
      return error.Oops;
    };

    try list.append(value);
  }

  return list;
}
