// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/fail_self_param.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/fail_self_param.carbon

// CHECK:STDERR: fail_self_param.carbon:[[@LINE+3]]:9: error: `self` parameter only allowed on functions [SelfParameterNotAllowed]
// CHECK:STDERR: class C[self:! type](x:! self) {}
// CHECK:STDERR:         ^~~~~~~~~~~
class C[self:! type](x:! self) {}
var v: C(0);

// CHECK:STDOUT: --- fail_self_param.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %x.patt: <error> = symbolic_binding_pattern x, 0 [symbolic]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [template]
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
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .v = %v
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %C.decl: %C.type = class_decl @C [template = constants.%C.generic] {
// CHECK:STDOUT:     %x.patt.loc14_22.1: <error> = symbolic_binding_pattern x, 0 [symbolic = %x.patt.loc14_22.2 (constants.%x.patt)]
// CHECK:STDOUT:     %x.param_patt: <error> = value_param_pattern %x.patt.loc14_22.1, runtime_param<invalid> [symbolic = %x.patt.loc14_22.2 (constants.%x.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %x.param: <error> = value_param runtime_param<invalid>
// CHECK:STDOUT:     %self.ref: <error> = name_ref self, <error> [template = <error>]
// CHECK:STDOUT:     %x: <error> = bind_symbolic_name x, 0, %x.param [template = <error>]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %v.var: ref <error> = var v
// CHECK:STDOUT:   %v: ref <error> = bind_name v, %v.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(%x: <error>) {
// CHECK:STDOUT:   %x.patt.loc14_22.2: <error> = symbolic_binding_pattern x, 0 [symbolic = %x.patt.loc14_22.2 (constants.%x.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = <error>
// CHECK:STDOUT:     complete_type_witness = %complete_type
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(<error>) {
// CHECK:STDOUT:   %x.patt.loc14_22.2 => <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
