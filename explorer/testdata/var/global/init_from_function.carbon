// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

// Test a global variable depending on a function.

fn f() -> i32 {
  return 0;
}

var y: i32 = f();

fn Main() -> i32 {
  return y;
}

// CHECK:STDOUT: result: 0
