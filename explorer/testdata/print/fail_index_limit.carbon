// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest impl;

fn Main() -> i32 {
  // CHECK:STDERR: RUNTIME ERROR: fail_index_limit.carbon:[[@LINE+1]]: Index invalid with argument count of 0 at offset 8 in `Print: {2147483648}`
  Print("Print: {2147483648}");
  return 0;
}
