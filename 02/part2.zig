const std = @import("std");
const fs = std.fs;
const allocator = std.testing.allocator;

const Direction = enum {
  Up,
  Down,
  Forward,

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

const Movement = struct {
  direction: Direction,
  value: i64,
};

pub fn main() !void {
  const contents = fs.cwd().readFileAlloc(allocator, "input.txt", 2 << 16) catch {
    std.debug.warn("Could not read input.txt", .{});
    std.os.exit(1);
  };
  defer allocator.free(contents);

  var x: i64 = 0;
  var y: i64 = 0;
  var aim: i64 = 0;

  var lines = std.mem.split(contents, "\n");
  while (lines.next()) |line| {
    var parts = std.mem.tokenize(line, " ");
    const direction = Direction.from_string(parts.next().?);
    if (direction == null) {
      std.debug.warn("Could not parse direction for line: {s}\n", .{ line });
      continue;
    }

    const value = std.fmt.parseInt(i64, parts.next().?, 10) catch {
      std.debug.warn("Could not parse value for line: {s}\n", .{ line });
      continue;
    };


    const movement = Movement { .direction = direction.?, .value = value };
    switch (movement.direction) {
      .Up => {
        aim -= movement.value;
      },
      .Down => {
        aim += movement.value;
      },
      .Forward => {
        x += movement.value;
        y += aim * movement.value;
      },
    }
  }  

  std.debug.print("Part2: {d}\n", .{ x * y });
}