// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

interface Iface {
  let T:! type;
}

fn F(T:! Iface where .T == i32) {}

class Good {}
class Bad {}
impl Good as Iface where .T = i32 {}
impl Bad as Iface where .T = Bad {}

fn Main() -> i32 {
  F(Good);
  // CHECK:STDERR: COMPILATION ERROR: fail_different_type.carbon:[[@LINE+1]]: constraint requires that (T).(Iface.T) (with value class Bad) == i32, which is not known to be true
  F(Bad);
  return 0;
}
