// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/fail_extend_partially_defined_interface.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/fail_extend_partially_defined_interface.carbon

interface I {
  class C {
    // CHECK:STDERR: fail_extend_partially_defined_interface.carbon:[[@LINE+10]]:5: error: implementation of undefined interface I [ImplOfUndefinedInterface]
    // CHECK:STDERR:     extend impl as I;
    // CHECK:STDERR:     ^~~~~~~~~~~~~~~~~
    // CHECK:STDERR: fail_extend_partially_defined_interface.carbon:[[@LINE-5]]:1: note: interface is currently being defined [InterfaceUndefinedWithinDefinition]
    // CHECK:STDERR: interface I {
    // CHECK:STDERR: ^~~~~~~~~~~~~
    // CHECK:STDERR:
    // CHECK:STDERR: fail_extend_partially_defined_interface.carbon:[[@LINE+3]]:5: error: impl declared but not defined [MissingImplDefinition]
    // CHECK:STDERR:     extend impl as I;
    // CHECK:STDERR:     ^~~~~~~~~~~~~~~~~
    extend impl as I;
  }
}

// CHECK:STDOUT: --- fail_extend_partially_defined_interface.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %I.type: type = facet_type <@I> [template]
// CHECK:STDOUT:   %Self: %I.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %C.1: type = class_type @C [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%Self) [symbolic]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .I = %I.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %I.decl: type = interface_decl @I [template = constants.%I.type] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @I {
// CHECK:STDOUT:   %Self: %I.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self]
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C.1] {} {}
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .C = %C.decl
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic impl @impl(@I.%Self: %I.type) {
// CHECK:STDOUT:   %Self: %I.type = bind_symbolic_name Self, 0 [symbolic = %Self (constants.%Self)]
// CHECK:STDOUT:   %C: type = class_type @C, @C(%Self) [symbolic = %C (constants.%C.2)]
// CHECK:STDOUT:
// CHECK:STDOUT:   impl: %Self.ref as %I.ref;
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(@I.%Self: %I.type) {
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     impl_decl @impl [template] {} {
// CHECK:STDOUT:       %Self.ref: type = name_ref Self, constants.%C.2 [symbolic = %C (constants.%C.2)]
// CHECK:STDOUT:       %I.ref: type = name_ref I, file.%I.decl [template = constants.%I.type]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %.loc23: type = specific_constant @impl.%I.ref, @impl(constants.%Self) [template = constants.%I.type]
// CHECK:STDOUT:     %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%C.2
// CHECK:STDOUT:     extend %.loc23
// CHECK:STDOUT:     has_error
// CHECK:STDOUT:     complete_type_witness = %complete_type
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%Self) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @impl(constants.%Self) {
// CHECK:STDOUT:   %Self => constants.%Self
// CHECK:STDOUT:   %C => constants.%C.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(@impl.%Self) {}
// CHECK:STDOUT:
