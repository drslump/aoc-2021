const std = @import("std");
const debug = std.debug;
const allocator = std.testing.allocator;

const utils = @import("utils.zig");

// We are going to mark the cells by setting them to a high value,
// it's dirty but gets the job done.
const MARK_BASE = 1 << 16;

fn maybeMarkInBoard(board: utils.Board, number: isize) void {
  for (board) | row, row_idx | {
    for (row) |col, col_idx| {
      if (col == number) {
        board[row_idx][col_idx] = MARK_BASE + number;
      }
    }
  }
}

fn checkBoardForLine(board: utils.Board) bool {
  for (board) | row, row_idx | {
    for (row) | col, col_idx | {
      if (col < MARK_BASE) {
        break;
      }
    } else {
      return true;
    }
  }
  return false;
}

fn checkBoardForColumn(board: utils.Board) bool {
  for (board[0]) | _, col_idx | {
    for (board) | row, row_idx | {
      if (row[col_idx] < MARK_BASE) {
        break;
      }
    } else {
      return true;
    }
  }
  return false;
}

fn calculateBoardScore(board: utils.Board) isize {
  var score: isize = 0;
  for (board) | row, row_idx | {
    for (row) | col, col_idx | {
      if (col < MARK_BASE) {
        score += col;
      }
    }
  }
  return score;
}

fn serialize(randoms: []isize, boards: []utils.Board) void {
  for (randoms) |random| {
    debug.print("{d},", .{ random });
  }
  debug.print("\n", .{});

  for (boards) |board| {
    debug.print("\n", .{});
    for (board) | row | {
      for (row) | col | {
        if (col < 10) {
          debug.print(" ", .{});
        }
        debug.print("{d} ", .{ col });
      }
      debug.print("\n", .{});
    }
  }
}

fn part1(path: []const u8) !isize {
  const lines = try utils.readLines(path);
  defer lines.deinit();

  const randoms = try utils.parseRandoms(lines.items[0]);
  defer randoms.deinit();

  const boards = try utils.parseBoards(lines.items[2..]);
  defer {
    for (boards.items) |board| {
      allocator.free(board);
    }
    boards.deinit();
  }

  // serialize(randoms.items, boards.items);

  for (randoms.items) |random| {
    for (boards.items) |board, idx| {
      maybeMarkInBoard(board, random);
      if (checkBoardForLine(board) or checkBoardForColumn(board)) {
        const score = calculateBoardScore(board);
        debug.print("Board {d} has won with score {d} after random {d}!\n", .{ idx, score, random });
        return score * random;
      }
    }
  }

  return error.Oops;
}

fn part2(path: []const u8) !isize {
  const lines = try utils.readLines(path);
  defer lines.deinit();

  const randoms = try utils.parseRandoms(lines.items[0]);
  defer randoms.deinit();

  const boards = try utils.parseBoards(lines.items[2..]);
  defer {
    for (boards.items) |board| {
      allocator.free(board);
    }
    boards.deinit();
  }

  var already_won = try allocator.alloc(bool, boards.items.len);
  defer allocator.free(already_won);
  std.mem.set(bool, already_won, false);

  var pending_wins: usize = boards.items.len;
  for (randoms.items) |random| {
    for (boards.items) |board, idx| {
      if (already_won[idx]) {
        continue;
      }

      maybeMarkInBoard(board, random);
      if (checkBoardForLine(board) or checkBoardForColumn(board)) {

        already_won[idx] = true;
        pending_wins -= 1;
        if (pending_wins == 0) {
          const score = calculateBoardScore(board);
          debug.print("Board {d} is the last to win with score {d} and random {d}!\n", .{ idx, score, random });
          return score * random;
        }
      }
    }
  }

  return error.Oops;
}

pub fn main() !void {
  const result1s = try part1("sample.txt");
  debug.print("Part1(Sample): {d}\n", .{ result1s });
  debug.assert(result1s == 4512);

  const result1 = try part1("input.txt");
  debug.print("Part1: {d}\n", .{ result1 });
  debug.assert(result1 == 8580);

  const result2s = try part2("sample.txt");
  debug.print("Part2(Sample): {d}\n", .{ result2s });
  debug.assert(result2s == 1924);

  const result2 = try part2("input.txt");
  debug.print("Part2: {d}\n", .{ result2 });
  debug.assert(result2s < 21006);
}
