const std = @import("std");
const debug = std.debug;
const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

const utils = @import("utils.zig");

const NUMBER_BITS = 12;


/// Computes the 1s (positive) and 0s (negative) for each bit position
fn computePositions(numbers: []u64) ![]isize {
  var positions = try allocator.alloc(isize, NUMBER_BITS);
  // XXX is there a better way to initialize a slice?
  for (positions) | _, index | {
    positions[index] = 0;
  }

  for (numbers) |number| {
    for (positions) | _, index | {
      const shift = (NUMBER_BITS - 1) - index;
      const mask = @intCast(u64, 1) << @intCast(u6, shift);
      if (number & mask == mask) {
        positions[index] += 1;
      } else {
        positions[index] -= 1;
      }
    }
  }

  return positions;
} 

const CmpFn = fn (position: isize, bitvalue: bool) bool;

/// Compare value against most common bit
fn cmpOxygen(position: isize, bitvalue: bool) bool {
  if (position == 0) return bitvalue;
  return if (position > 0) bitvalue else !bitvalue;
}
/// Compare value against least common bit
fn cmpCO2(position: isize, bitvalue: bool) bool {
  if (position == 0) return !bitvalue;
  return if (position < 0) bitvalue else !bitvalue;
}

// This is pretty ugly but I'm tired now to refactor it :)
fn matchValueForPositions(numbers: []u64, cmp: CmpFn) !u64 {
  var sourceList = ArrayList(u64).init(std.testing.allocator);
  defer sourceList.deinit();
  var targetList = ArrayList(u64).init(std.testing.allocator);
  defer targetList.deinit();

  try sourceList.appendSlice(numbers);

  var positions = try computePositions(sourceList.items);
  defer allocator.free(positions);

  for (positions) | position, index | {
    const shift = (NUMBER_BITS - 1) - index;
    const mask = @intCast(u64, 1) << @intCast(u6, shift);

    for (sourceList.items) |number| {
      if (cmp(position, number & mask == mask)) {
        try targetList.append(number);
      }
    }

    if (targetList.items.len == 1) {
      return targetList.items[0];
    }

    sourceList.clearRetainingCapacity();
    try sourceList.appendSlice(targetList.items);
    targetList.clearRetainingCapacity();

    allocator.free(positions);
    positions = try computePositions(sourceList.items);
  }

  return error.Oops;
}


pub fn main() !void {
  const numbers = try utils.readBinary("input.txt");
  defer numbers.deinit();

  const positions = try computePositions(numbers.items);
  defer allocator.free(positions);

  // Part 1 is just deriving the results from the most/least common bits
  var gamma: u64 = 0;
  var epsilon: u64 = 0;
  for (positions) | position, index | {
    const shift = (NUMBER_BITS - 1) - index;
    const mask = @intCast(u64, 1) << @intCast(u6, shift);
    if (position > 0) {
      gamma |= mask;
    }
    if (position < 0) {
      epsilon |= mask;
    }
  }
  
  debug.print("Part1: {d}\n", .{ gamma * epsilon });
  debug.assert(gamma * epsilon == 3912944);  

  // Part 2 is more involved :)
  const oxygen = try matchValueForPositions(numbers.items, cmpOxygen);
  const co2 = try matchValueForPositions(numbers.items, cmpCO2);

  debug.print("Oxygen/CO2: {d}/{d}\n", .{ oxygen, co2 });
  debug.print("Part2: {d}\n", .{ oxygen * co2 });
  debug.assert(oxygen * co2 == 4996233);
}
