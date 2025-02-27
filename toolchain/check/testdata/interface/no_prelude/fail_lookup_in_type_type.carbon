// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interface/no_prelude/fail_lookup_in_type_type.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interface/no_prelude/fail_lookup_in_type_type.carbon

// --- fail_lookup_in_type.carbon

library "[[@TEST_NAME]]";

// CHECK:STDERR: fail_lookup_in_type.carbon:[[@LINE+4]]:8: error: type `type` does not support qualified expressions [QualifiedExprUnsupported]
// CHECK:STDERR: let T: type.not_found = {};
// CHECK:STDERR:        ^~~~~~~~~~~~~~
// CHECK:STDERR:
let T: type.not_found = {};

// --- fail_lookup_type_where.carbon

library "[[@TEST_NAME]]";

// CHECK:STDERR: fail_lookup_type_where.carbon:[[@LINE+3]]:8: error: member name `missing` not found [MemberNameNotFound]
// CHECK:STDERR: let U: (type where .Self impls type).missing = {};
// CHECK:STDERR:        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let U: (type where .Self impls type).missing = {};

// CHECK:STDOUT: --- fail_lookup_in_type.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .T = @__global_init.%T
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc8: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %T: <error> = bind_name T, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_lookup_type_where.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .U = @__global_init.%U
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc7: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %U: <error> = bind_name U, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
