const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

pub fn readLines(path: []const u8) !ArrayList([]const u8) {
  const contents = try std.fs.cwd().readFileAlloc(allocator, path, 2 << 16);
  // XXX we are leaking the file contents here so that we can access the
  //     the lines slices, it's completely wrong though!
  // defer allocator.free(contents);

  var list = ArrayList([]const u8).init(allocator);
  var lines = std.mem.split(contents, "\n");
  while (lines.next()) |line| {
    try list.append(line);
  }

  return list;  
}

pub fn parseRandoms(line: []const u8) !ArrayList(isize) {
  var list = ArrayList(isize).init(allocator);

  var numbers = std.mem.split(line, ",");
  while (numbers.next()) |number| {
    const int = std.fmt.parseInt(isize, number, 10) catch {
      std.debug.warn("Could not parse random: {s}\n", .{ number });
      return error.Oops;
    };

    try list.append(int);
  }

  return list;
}

pub const Board = [][5]isize;

pub fn parseBoard(lines: [][]const u8) !Board {
  var board = try allocator.alloc([5]isize, 5);

  for (lines) | line, line_no | {
    std.debug.assert(line_no < 5);
    var numbers = std.mem.split(line, " ");
    var column_no: usize = 0;
    while (numbers.next()) |number| {
      // single digits are left padded with a space
      if (number.len == 0) continue;

      std.debug.assert(column_no < 5);
      const int = std.fmt.parseInt(isize, number, 10) catch {
        std.debug.warn("Could not parse number: {s}\n", .{ number });
        return error.Oops;
      };

      board[line_no][column_no] = int;
      column_no += 1;
    }
  }

  return board;
}

pub fn parseBoards(lines: [][]const u8) !ArrayList(Board) {
  var boards = ArrayList(Board).init(allocator);

  var linePos: usize = 0;
  while (linePos < lines.len) {
    const range = lines[linePos..linePos+5];
    linePos += 5 + 1;

    var board = try parseBoard(range);
    try boards.append(board);
  }

  return boards;
}
