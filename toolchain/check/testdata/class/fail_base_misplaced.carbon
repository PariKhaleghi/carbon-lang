// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/fail_base_misplaced.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/fail_base_misplaced.carbon

base class B {}

// CHECK:STDERR: fail_base_misplaced.carbon:[[@LINE+4]]:1: error: `base` declaration outside class [ClassSpecificDeclOutsideClass]
// CHECK:STDERR: extend base: B;
// CHECK:STDERR: ^~~~~~~~~~~~~~~
// CHECK:STDERR:
extend base: B;

fn F() {
  // CHECK:STDERR: fail_base_misplaced.carbon:[[@LINE+7]]:3: error: expected expression [ExpectedExpr]
  // CHECK:STDERR:   extend base: B;
  // CHECK:STDERR:   ^~~~~~
  // CHECK:STDERR:
  // CHECK:STDERR: fail_base_misplaced.carbon:[[@LINE+3]]:3: error: semantics TODO: `handle invalid parse trees in `check`` [SemanticsTodo]
  // CHECK:STDERR:   extend base: B;
  // CHECK:STDERR:   ^~~~~~
  extend base: B;
}

// CHECK:STDOUT: --- fail_base_misplaced.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %B: type = class_type @B [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {}
// CHECK:STDOUT:
// CHECK:STDOUT: class @B {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%B
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
