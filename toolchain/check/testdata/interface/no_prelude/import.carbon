// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interface/no_prelude/import.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interface/no_prelude/import.carbon

// --- a.carbon

library "[[@TEST_NAME]]";

interface Empty {
}

interface Basic {
  let T:! type;
  fn F();
}

// TODO: Implement merging of interface on import.
// interface ForwardDeclared;

interface ForwardDeclared {
  let T:! type;
  fn F();
}

var f_ref: {.f: ForwardDeclared};

// --- b.carbon

library "[[@TEST_NAME]]";

import library "a";

fn UseEmpty(e: Empty) {}
fn UseBasic(e: Basic) {}
fn UseForwardDeclared(f: ForwardDeclared) {}

alias UseBasicT = Basic.T;
alias UseBasicF = Basic.F;

alias UseForwardDeclaredT = ForwardDeclared.T;
alias UseForwardDeclaredF = ForwardDeclared.F;

var f: ForwardDeclared* = &f_ref.f;

// CHECK:STDOUT: --- a.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Empty.type: type = facet_type <@Empty> [template]
// CHECK:STDOUT:   %Self.1: %Empty.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %Basic.type: type = facet_type <@Basic> [template]
// CHECK:STDOUT:   %Self.2: %Basic.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %assoc_type.1: type = assoc_entity_type %Basic.type, type [template]
// CHECK:STDOUT:   %assoc0.1: %assoc_type.1 = assoc_entity element0, @Basic.%T [template]
// CHECK:STDOUT:   %F.type.1: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %F.1: %F.type.1 = struct_value () [template]
// CHECK:STDOUT:   %F.assoc_type.1: type = assoc_entity_type %Basic.type, %F.type.1 [template]
// CHECK:STDOUT:   %assoc1.1: %F.assoc_type.1 = assoc_entity element1, @Basic.%F.decl [template]
// CHECK:STDOUT:   %ForwardDeclared.type: type = facet_type <@ForwardDeclared> [template]
// CHECK:STDOUT:   %Self.3: %ForwardDeclared.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %assoc_type.2: type = assoc_entity_type %ForwardDeclared.type, type [template]
// CHECK:STDOUT:   %assoc0.2: %assoc_type.2 = assoc_entity element0, @ForwardDeclared.%T [template]
// CHECK:STDOUT:   %F.type.2: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.2: %F.type.2 = struct_value () [template]
// CHECK:STDOUT:   %F.assoc_type.2: type = assoc_entity_type %ForwardDeclared.type, %F.type.2 [template]
// CHECK:STDOUT:   %assoc1.2: %F.assoc_type.2 = assoc_entity element1, @ForwardDeclared.%F.decl [template]
// CHECK:STDOUT:   %struct_type.f.1: type = struct_type {.f: %ForwardDeclared.type} [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Empty = %Empty.decl
// CHECK:STDOUT:     .Basic = %Basic.decl
// CHECK:STDOUT:     .ForwardDeclared = %ForwardDeclared.decl
// CHECK:STDOUT:     .f_ref = %f_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Empty.decl: type = interface_decl @Empty [template = constants.%Empty.type] {} {}
// CHECK:STDOUT:   %Basic.decl: type = interface_decl @Basic [template = constants.%Basic.type] {} {}
// CHECK:STDOUT:   %ForwardDeclared.decl: type = interface_decl @ForwardDeclared [template = constants.%ForwardDeclared.type] {} {}
// CHECK:STDOUT:   %f_ref.var: ref %struct_type.f.1 = var f_ref
// CHECK:STDOUT:   %f_ref: ref %struct_type.f.1 = bind_name f_ref, %f_ref.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Empty {
// CHECK:STDOUT:   %Self: %Empty.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self.1]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Basic {
// CHECK:STDOUT:   %Self: %Basic.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self.2]
// CHECK:STDOUT:   %T: type = assoc_const_decl T [template]
// CHECK:STDOUT:   %assoc0: %assoc_type.1 = assoc_entity element0, %T [template = constants.%assoc0.1]
// CHECK:STDOUT:   %F.decl: %F.type.1 = fn_decl @F.1 [template = constants.%F.1] {} {}
// CHECK:STDOUT:   %assoc1: %F.assoc_type.1 = assoc_entity element1, %F.decl [template = constants.%assoc1.1]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .T = %assoc0
// CHECK:STDOUT:   .F = %assoc1
// CHECK:STDOUT:   witness = (%T, %F.decl)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @ForwardDeclared {
// CHECK:STDOUT:   %Self: %ForwardDeclared.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self.3]
// CHECK:STDOUT:   %T: type = assoc_const_decl T [template]
// CHECK:STDOUT:   %assoc0: %assoc_type.2 = assoc_entity element0, %T [template = constants.%assoc0.2]
// CHECK:STDOUT:   %F.decl: %F.type.2 = fn_decl @F.2 [template = constants.%F.2] {} {}
// CHECK:STDOUT:   %assoc1: %F.assoc_type.2 = assoc_entity element1, %F.decl [template = constants.%assoc1.2]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .T = %assoc0
// CHECK:STDOUT:   .F = %assoc1
// CHECK:STDOUT:   witness = (%T, %F.decl)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F.1(@Basic.%Self: %Basic.type) {
// CHECK:STDOUT:
// CHECK:STDOUT:   fn();
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F.2(@ForwardDeclared.%Self: %ForwardDeclared.type) {
// CHECK:STDOUT:
// CHECK:STDOUT:   fn();
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.1(constants.%Self.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.2(constants.%Self.3) {}
// CHECK:STDOUT:
// CHECK:STDOUT: --- b.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Empty.type: type = facet_type <@Empty> [template]
// CHECK:STDOUT:   %UseEmpty.type: type = fn_type @UseEmpty [template]
// CHECK:STDOUT:   %UseEmpty: %UseEmpty.type = struct_value () [template]
// CHECK:STDOUT:   %Basic.type: type = facet_type <@Basic> [template]
// CHECK:STDOUT:   %Self.2: %Basic.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %UseBasic.type: type = fn_type @UseBasic [template]
// CHECK:STDOUT:   %UseBasic: %UseBasic.type = struct_value () [template]
// CHECK:STDOUT:   %ForwardDeclared.type: type = facet_type <@ForwardDeclared> [template]
// CHECK:STDOUT:   %Self.3: %ForwardDeclared.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %UseForwardDeclared.type: type = fn_type @UseForwardDeclared [template]
// CHECK:STDOUT:   %UseForwardDeclared: %UseForwardDeclared.type = struct_value () [template]
// CHECK:STDOUT:   %assoc_type.1: type = assoc_entity_type %Basic.type, type [template]
// CHECK:STDOUT:   %assoc0.1: %assoc_type.1 = assoc_entity element0, imports.%import_ref.16 [template]
// CHECK:STDOUT:   %F.type.1: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %F.assoc_type.1: type = assoc_entity_type %Basic.type, %F.type.1 [template]
// CHECK:STDOUT:   %assoc1.1: %F.assoc_type.1 = assoc_entity element1, imports.%import_ref.17 [template]
// CHECK:STDOUT:   %assoc_type.2: type = assoc_entity_type %ForwardDeclared.type, type [template]
// CHECK:STDOUT:   %assoc0.2: %assoc_type.2 = assoc_entity element0, imports.%import_ref.18 [template]
// CHECK:STDOUT:   %F.type.2: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.assoc_type.2: type = assoc_entity_type %ForwardDeclared.type, %F.type.2 [template]
// CHECK:STDOUT:   %assoc1.2: %F.assoc_type.2 = assoc_entity element1, imports.%import_ref.19 [template]
// CHECK:STDOUT:   %ptr: type = ptr_type %ForwardDeclared.type [template]
// CHECK:STDOUT:   %struct_type.f.1: type = struct_type {.f: %ForwardDeclared.type} [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//a, Empty, loaded [template = constants.%Empty.type]
// CHECK:STDOUT:   %import_ref.2: type = import_ref Main//a, Basic, loaded [template = constants.%Basic.type]
// CHECK:STDOUT:   %import_ref.3: type = import_ref Main//a, ForwardDeclared, loaded [template = constants.%ForwardDeclared.type]
// CHECK:STDOUT:   %import_ref.4: ref %struct_type.f.1 = import_ref Main//a, f_ref, loaded
// CHECK:STDOUT:   %import_ref.5 = import_ref Main//a, inst15 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.6 = import_ref Main//a, inst19 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.7: %assoc_type.1 = import_ref Main//a, loc8_15, loaded [template = constants.%assoc0.1]
// CHECK:STDOUT:   %import_ref.8: %F.assoc_type.1 = import_ref Main//a, loc9_9, loaded [template = constants.%assoc1.1]
// CHECK:STDOUT:   %import_ref.9 = import_ref Main//a, T, unloaded
// CHECK:STDOUT:   %import_ref.10 = import_ref Main//a, F, unloaded
// CHECK:STDOUT:   %import_ref.11 = import_ref Main//a, inst34 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.12: %assoc_type.2 = import_ref Main//a, loc16_15, loaded [template = constants.%assoc0.2]
// CHECK:STDOUT:   %import_ref.13: %F.assoc_type.2 = import_ref Main//a, loc17_9, loaded [template = constants.%assoc1.2]
// CHECK:STDOUT:   %import_ref.14 = import_ref Main//a, T, unloaded
// CHECK:STDOUT:   %import_ref.15 = import_ref Main//a, F, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Empty = imports.%import_ref.1
// CHECK:STDOUT:     .Basic = imports.%import_ref.2
// CHECK:STDOUT:     .ForwardDeclared = imports.%import_ref.3
// CHECK:STDOUT:     .f_ref = imports.%import_ref.4
// CHECK:STDOUT:     .UseEmpty = %UseEmpty.decl
// CHECK:STDOUT:     .UseBasic = %UseBasic.decl
// CHECK:STDOUT:     .UseForwardDeclared = %UseForwardDeclared.decl
// CHECK:STDOUT:     .UseBasicT = %UseBasicT
// CHECK:STDOUT:     .UseBasicF = %UseBasicF
// CHECK:STDOUT:     .UseForwardDeclaredT = %UseForwardDeclaredT
// CHECK:STDOUT:     .UseForwardDeclaredF = %UseForwardDeclaredF
// CHECK:STDOUT:     .f = %f
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %UseEmpty.decl: %UseEmpty.type = fn_decl @UseEmpty [template = constants.%UseEmpty] {
// CHECK:STDOUT:     %e.patt: %Empty.type = binding_pattern e
// CHECK:STDOUT:     %e.param_patt: %Empty.type = value_param_pattern %e.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %e.param: %Empty.type = value_param runtime_param0
// CHECK:STDOUT:     %Empty.ref: type = name_ref Empty, imports.%import_ref.1 [template = constants.%Empty.type]
// CHECK:STDOUT:     %e: %Empty.type = bind_name e, %e.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %UseBasic.decl: %UseBasic.type = fn_decl @UseBasic [template = constants.%UseBasic] {
// CHECK:STDOUT:     %e.patt: %Basic.type = binding_pattern e
// CHECK:STDOUT:     %e.param_patt: %Basic.type = value_param_pattern %e.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %e.param: %Basic.type = value_param runtime_param0
// CHECK:STDOUT:     %Basic.ref: type = name_ref Basic, imports.%import_ref.2 [template = constants.%Basic.type]
// CHECK:STDOUT:     %e: %Basic.type = bind_name e, %e.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %UseForwardDeclared.decl: %UseForwardDeclared.type = fn_decl @UseForwardDeclared [template = constants.%UseForwardDeclared] {
// CHECK:STDOUT:     %f.patt: %ForwardDeclared.type = binding_pattern f
// CHECK:STDOUT:     %f.param_patt: %ForwardDeclared.type = value_param_pattern %f.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %f.param: %ForwardDeclared.type = value_param runtime_param0
// CHECK:STDOUT:     %ForwardDeclared.ref: type = name_ref ForwardDeclared, imports.%import_ref.3 [template = constants.%ForwardDeclared.type]
// CHECK:STDOUT:     %f: %ForwardDeclared.type = bind_name f, %f.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Basic.ref.loc10: type = name_ref Basic, imports.%import_ref.2 [template = constants.%Basic.type]
// CHECK:STDOUT:   %T.ref.loc10: %assoc_type.1 = name_ref T, imports.%import_ref.7 [template = constants.%assoc0.1]
// CHECK:STDOUT:   %UseBasicT: %assoc_type.1 = bind_alias UseBasicT, imports.%import_ref.7 [template = constants.%assoc0.1]
// CHECK:STDOUT:   %Basic.ref.loc11: type = name_ref Basic, imports.%import_ref.2 [template = constants.%Basic.type]
// CHECK:STDOUT:   %F.ref.loc11: %F.assoc_type.1 = name_ref F, imports.%import_ref.8 [template = constants.%assoc1.1]
// CHECK:STDOUT:   %UseBasicF: %F.assoc_type.1 = bind_alias UseBasicF, imports.%import_ref.8 [template = constants.%assoc1.1]
// CHECK:STDOUT:   %ForwardDeclared.ref.loc13: type = name_ref ForwardDeclared, imports.%import_ref.3 [template = constants.%ForwardDeclared.type]
// CHECK:STDOUT:   %T.ref.loc13: %assoc_type.2 = name_ref T, imports.%import_ref.12 [template = constants.%assoc0.2]
// CHECK:STDOUT:   %UseForwardDeclaredT: %assoc_type.2 = bind_alias UseForwardDeclaredT, imports.%import_ref.12 [template = constants.%assoc0.2]
// CHECK:STDOUT:   %ForwardDeclared.ref.loc14: type = name_ref ForwardDeclared, imports.%import_ref.3 [template = constants.%ForwardDeclared.type]
// CHECK:STDOUT:   %F.ref.loc14: %F.assoc_type.2 = name_ref F, imports.%import_ref.13 [template = constants.%assoc1.2]
// CHECK:STDOUT:   %UseForwardDeclaredF: %F.assoc_type.2 = bind_alias UseForwardDeclaredF, imports.%import_ref.13 [template = constants.%assoc1.2]
// CHECK:STDOUT:   %f.var: ref %ptr = var f
// CHECK:STDOUT:   %f: ref %ptr = bind_name f, %f.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Empty [from "a.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.5
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Basic [from "a.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.6
// CHECK:STDOUT:   .T = imports.%import_ref.7
// CHECK:STDOUT:   .F = imports.%import_ref.8
// CHECK:STDOUT:   witness = (imports.%import_ref.9, imports.%import_ref.10)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @ForwardDeclared [from "a.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.11
// CHECK:STDOUT:   .T = imports.%import_ref.12
// CHECK:STDOUT:   .F = imports.%import_ref.13
// CHECK:STDOUT:   witness = (imports.%import_ref.14, imports.%import_ref.15)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @UseEmpty(%e.param_patt: %Empty.type) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @UseBasic(%e.param_patt: %Basic.type) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @UseForwardDeclared(%f.param_patt: %ForwardDeclared.type) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F.1(constants.%Self.2: %Basic.type) [from "a.carbon"] {
// CHECK:STDOUT:
// CHECK:STDOUT:   fn();
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F.2(constants.%Self.3: %ForwardDeclared.type) [from "a.carbon"] {
// CHECK:STDOUT:
// CHECK:STDOUT:   fn();
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %f_ref.ref: ref %struct_type.f.1 = name_ref f_ref, imports.%import_ref.4
// CHECK:STDOUT:   %.loc16: ref %ForwardDeclared.type = struct_access %f_ref.ref, element0
// CHECK:STDOUT:   %addr: %ptr = addr_of %.loc16
// CHECK:STDOUT:   assign file.%f.var, %addr
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.1(constants.%Self.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.2(constants.%Self.3) {}
// CHECK:STDOUT:
