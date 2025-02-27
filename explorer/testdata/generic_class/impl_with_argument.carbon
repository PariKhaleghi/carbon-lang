// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

interface Vector {
  fn Zero() -> Self;
  fn Add[self: Self](b: Self) -> Self;
  fn Scale[self: Self](v: i32) -> Self;
}

class Point(T:! type) {
  var x: T;
  var y: T;
}

// Can implement `Vector` for just `Point(i32)`, not all `Point(T)`.
impl Point(i32) as Vector {
  fn Zero() -> Point(i32) {
    return {.x = 0, .y = 0};
  }

  fn Add[self: Point(i32)](b: Point(i32)) -> Point(i32) {
    return {.x = self.x + b.x, .y = self.y + b.y};
  }

  fn Scale[self: Point(i32)](v: i32) -> Point(i32) {
    return {.x = self.x * v, .y = self.y * v};
  }
}

fn AddAndScaleGeneric[T:! Vector](a: T, s: i32) -> T {
  return a.Add(T.Zero()).Scale(s);
}

fn Main() -> i32 {
  var a: Point(i32) = {.x = 2, .y = 1};
  var p: Point(i32) = AddAndScaleGeneric(a, 5);
  return p.x - 10;
}

// CHECK:STDOUT: result: 0
