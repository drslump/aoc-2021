const std = @import("std");
const debug = std.debug;

pub fn main() !void {
  const file = try std.fs.cwd().openFile("input.txt", .{});
  defer file.close();

  var buf_reader = std.io.bufferedReader(file.reader());
  var in_stream = buf_reader.reader();
  var buf: [1024]u8 = undefined;

  var num_increases: i64 = 0;
  var previous: i64 = -1; 
  while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
    const current = std.fmt.parseInt(i64, line, 10) catch {
      debug.warn("Could not parse line: {s}\n", .{ line });
      std.os.exit(1);
    };

    if (previous != -1 and current > previous) {
      num_increases += 1;
    }
    previous = current;
  }

  debug.print("Result: {d}\n", .{ num_increases });
}