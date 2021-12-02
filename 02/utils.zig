const std = @import("std");
const fs = std.fs;
const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

/// Represents the direction the submarine is taking
const Direction = enum {
  Up,
  Down,
  Forward,

  /// Parses a direction string into the enum
  fn from_string(val: []const u8) ?Direction {
    if (std.mem.eql(u8, val, "up")) {
      return .Up;
    } else if (std.mem.eql(u8, val, "down")) {
      return .Down;
    } else if (std.mem.eql(u8, val, "forward")) {
      return .Forward;
    } else {
      return null;
    }
  }
};

/// Represents a movement of the submarine.
pub const Movement = struct {
  direction: Direction,
  value: i64,
};

/// Parses a text file where each line define a movement.
pub fn readMovements(path: []const u8) !ArrayList(Movement) {
  const contents = try fs.cwd().readFileAlloc(allocator, path, 2 << 16);
  defer allocator.free(contents);

  var list = ArrayList(Movement).init(allocator);

  var line_no: usize = 1;
  var lines = std.mem.split(contents, "\n");
  while (lines.next()) |line| : (line_no += 1) {
    var parts = std.mem.tokenize(line, " ");
    const direction = Direction.from_string(parts.next().?);
    if (direction == null) {
      std.debug.warn("Could not parse direction at line {d}\n", .{ line_no });
      return error.Oops;
    }

    const value = std.fmt.parseInt(i64, parts.next().?, 10) catch {
      std.debug.warn("Could not parse value at line {d}\n", .{ line_no });
      return error.Oops;
    };

    const movement = Movement { .direction = direction.?, .value = value };
    try list.append(movement);
  }

  return list;
}
