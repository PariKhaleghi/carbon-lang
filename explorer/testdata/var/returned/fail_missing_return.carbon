// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

fn AddInt(a: i32, b: i32) -> i32 {
  returned var ret: i32 = a + b;
  // CHECK:STDERR: COMPILATION ERROR: fail_missing_return.carbon:[[@LINE+1]]: `return <expression>` is not allowed with a returned var defined in scope: fail_missing_return.carbon:[[@LINE-1]]
  return ret;
}

fn Main() -> i32 {
  return AddInt(1, 2);
}
