// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/fail_compound_type_mismatch.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/fail_compound_type_mismatch.carbon

class A {
  var a: i32;
}

class B {
  var b: i32;
}

fn AccessBInA(a: A) -> i32 {
  // CHECK:STDERR: fail_compound_type_mismatch.carbon:[[@LINE+6]]:10: error: cannot implicitly convert from `A` to `B` [ImplicitAsConversionFailure]
  // CHECK:STDERR:   return a.(B.b);
  // CHECK:STDERR:          ^~~~~~~
  // CHECK:STDERR: fail_compound_type_mismatch.carbon:[[@LINE+3]]:10: note: type `A` does not implement interface `Core.ImplicitAs(B)` [MissingImplInMemberAccessNote]
  // CHECK:STDERR:   return a.(B.b);
  // CHECK:STDERR:          ^~~~~~~
  return a.(B.b);
}

// CHECK:STDOUT: --- fail_compound_type_mismatch.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A: type = class_type @A [template]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %A.elem: type = unbound_element_type %A, %i32 [template]
// CHECK:STDOUT:   %struct_type.a: type = struct_type {.a: %i32} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %struct_type.a [template]
// CHECK:STDOUT:   %B: type = class_type @B [template]
// CHECK:STDOUT:   %B.elem: type = unbound_element_type %B, %i32 [template]
// CHECK:STDOUT:   %struct_type.b: type = struct_type {.b: %i32} [template]
// CHECK:STDOUT:   %complete_type.4: <witness> = complete_type_witness %struct_type.b [template]
// CHECK:STDOUT:   %AccessBInA.type: type = fn_type @AccessBInA [template]
// CHECK:STDOUT:   %AccessBInA: %AccessBInA.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     .ImplicitAs = %import_ref.5
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .A = %A.decl
// CHECK:STDOUT:     .B = %B.decl
// CHECK:STDOUT:     .AccessBInA = %AccessBInA.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %A.decl: type = class_decl @A [template = constants.%A] {} {}
// CHECK:STDOUT:   %B.decl: type = class_decl @B [template = constants.%B] {} {}
// CHECK:STDOUT:   %AccessBInA.decl: %AccessBInA.type = fn_decl @AccessBInA [template = constants.%AccessBInA] {
// CHECK:STDOUT:     %a.patt: %A = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %A = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: %i32 = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %i32 = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int_32: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:     %i32: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:     %a.param: %A = value_param runtime_param0
// CHECK:STDOUT:     %A.ref: type = name_ref A, file.%A.decl [template = constants.%A]
// CHECK:STDOUT:     %a: %A = bind_name a, %a.param
// CHECK:STDOUT:     %return.param: ref %i32 = out_param runtime_param1
// CHECK:STDOUT:     %return: ref %i32 = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @A {
// CHECK:STDOUT:   %.loc12: %A.elem = field_decl a, element0 [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %struct_type.a [template = constants.%complete_type.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%A
// CHECK:STDOUT:   .a = %.loc12
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @B {
// CHECK:STDOUT:   %.loc16: %B.elem = field_decl b, element0 [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %struct_type.b [template = constants.%complete_type.4]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%B
// CHECK:STDOUT:   .b = %.loc16
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @AccessBInA(%a.param_patt: %A) -> %i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %A = name_ref a, %a
// CHECK:STDOUT:   %B.ref: type = name_ref B, file.%B.decl [template = constants.%B]
// CHECK:STDOUT:   %b.ref: %B.elem = name_ref b, @B.%.loc16 [template = @B.%.loc16]
// CHECK:STDOUT:   %.loc26_11.1: %B = converted %a.ref, <error> [template = <error>]
// CHECK:STDOUT:   %.loc26_11.2: %i32 = class_element_access <error>, element0 [template = <error>]
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
