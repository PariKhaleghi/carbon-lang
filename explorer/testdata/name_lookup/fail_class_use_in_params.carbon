// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

// CHECK:STDERR: COMPILATION ERROR: fail_class_use_in_params.carbon:[[@LINE+1]]: 'A' is not usable until after it has been completely declared
class A(X:! A(i32)) {
}

fn Main() -> i32 {
  return x;
}
