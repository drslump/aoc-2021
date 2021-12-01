const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

pub fn readInput(path: []const u8) !ArrayList(i64) {
  var list = ArrayList(i64).init(allocator);

  const file = try std.fs.cwd().openFile(path, .{});
  defer file.close();

  var buf_reader = std.io.bufferedReader(file.reader());
  var in_stream = buf_reader.reader();
  var buf: [1024]u8 = undefined;
  var line_no: usize = 1;
  while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
    const current = std.fmt.parseInt(i64, line, 10) catch {
      std.debug.warn("Could not parse line {d}: {s}\n", .{ line_no, line });
      continue;
    };
    try list.append(current);
    line_no += 1;
  }

  return list;
}
