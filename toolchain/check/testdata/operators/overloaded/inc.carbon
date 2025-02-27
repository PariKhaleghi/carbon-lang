// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/operators/overloaded/inc.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/operators/overloaded/inc.carbon

// This file was generated from unary_stmt.carbon.tmpl. Run make_tests.sh to regenerate.

package User;

class C {};

impl C as Core.Inc {
  fn Op[addr self: C*]();
}

fn TestOp() {
  var c: C = {};
  ++c;
}

// CHECK:STDOUT: --- inc.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %Inc.type: type = facet_type <@Inc> [template]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [template]
// CHECK:STDOUT:   %Op.type.1: type = fn_type @Op.1 [template]
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Op.decl) [template]
// CHECK:STDOUT:   %ptr.2: type = ptr_type %C [template]
// CHECK:STDOUT:   %Op.type.2: type = fn_type @Op.2 [template]
// CHECK:STDOUT:   %Op.2: %Op.type.2 = struct_value () [template]
// CHECK:STDOUT:   %TestOp.type: type = fn_type @TestOp [template]
// CHECK:STDOUT:   %TestOp: %TestOp.type = struct_value () [template]
// CHECK:STDOUT:   %C.val: %C = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Inc = %import_ref.1
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.1: type = import_ref Core//prelude/operators/arithmetic, Inc, loaded [template = constants.%Inc.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .TestOp = %TestOp.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {} {}
// CHECK:STDOUT:   impl_decl @impl.1 [template] {} {
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %Core.ref: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %Inc.ref: type = name_ref Inc, imports.%import_ref.1 [template = constants.%Inc.type]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Op.decl) [template = constants.%impl_witness]
// CHECK:STDOUT:   %TestOp.decl: %TestOp.type = fn_decl @TestOp [template = constants.%TestOp] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl.1: %C.ref as %Inc.ref {
// CHECK:STDOUT:   %Op.decl: %Op.type.2 = fn_decl @Op.2 [template = constants.%Op.2] {
// CHECK:STDOUT:     %self.patt: %ptr.2 = binding_pattern self
// CHECK:STDOUT:     %self.param_patt: %ptr.2 = value_param_pattern %self.patt, runtime_param0
// CHECK:STDOUT:     %.loc18_9: auto = addr_pattern %self.param_patt
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %self.param: %ptr.2 = value_param runtime_param0
// CHECK:STDOUT:     %.loc18_21: type = splice_block %ptr [template = constants.%ptr.2] {
// CHECK:STDOUT:       %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:       %ptr: type = ptr_type %C [template = constants.%ptr.2]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %self: %ptr.2 = bind_name self, %self.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Op = %Op.decl
// CHECK:STDOUT:   witness = file.%impl_witness
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Op.2[addr %self.param_patt: %ptr.2]();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestOp() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %c.var: ref %C = var c
// CHECK:STDOUT:   %c: ref %C = bind_name c, %c.var
// CHECK:STDOUT:   %.loc22_15.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc22_15.2: init %C = class_init (), %c.var [template = constants.%C.val]
// CHECK:STDOUT:   %.loc22_16: init %C = converted %.loc22_15.1, %.loc22_15.2 [template = constants.%C.val]
// CHECK:STDOUT:   assign %c.var, %.loc22_16
// CHECK:STDOUT:   %c.ref: ref %C = name_ref c, %c
// CHECK:STDOUT:   %impl.elem0: %Op.type.1 = impl_witness_access constants.%impl_witness, element0 [template = constants.%Op.2]
// CHECK:STDOUT:   %Op.bound: <bound method> = bound_method %c.ref, %impl.elem0
// CHECK:STDOUT:   %addr: %ptr.2 = addr_of %c.ref
// CHECK:STDOUT:   %Op.call: init %empty_tuple.type = call %Op.bound(%addr)
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
