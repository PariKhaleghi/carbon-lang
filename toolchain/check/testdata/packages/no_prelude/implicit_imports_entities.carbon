// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/packages/no_prelude/implicit_imports_entities.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/packages/no_prelude/implicit_imports_entities.carbon

// ============================================================================
// Setup files
// ============================================================================

// --- c1.carbon

library "[[@TEST_NAME]]";

class C1 {}

// --- c2.carbon

library "[[@TEST_NAME]]";

class C2 {}

// --- ns.carbon

library "[[@TEST_NAME]]";

namespace NS;
class NS.C {}

// --- o1.carbon

package Other library "[[@TEST_NAME]]";

class O1 {}

// --- o2.carbon

package Other library "[[@TEST_NAME]]";

class O2 {}

// --- local_other.carbon

library "[[@TEST_NAME]]";

class Other {}

// ============================================================================
// Test files
// ============================================================================

// --- mix_current_package.carbon

library "[[@TEST_NAME]]";

import library "c1";

// --- mix_current_package.impl.carbon

impl library "[[@TEST_NAME]]";

import library "c2";

var c1: C1 = {};
var c2: C2 = {};

// --- dup_c1.carbon

library "[[@TEST_NAME]]";

import library "c1";

// --- dup_c1.impl.carbon

impl library "[[@TEST_NAME]]";

import library "c1";

var c1: C1 = {};

// --- use_ns.carbon

library "[[@TEST_NAME]]";

import library "ns";

// --- use_ns.impl.carbon

impl library "[[@TEST_NAME]]";

var c: NS.C = {};

// --- mix_other.carbon

library "[[@TEST_NAME]]";

import Other library "o1";

// --- mix_other.impl.carbon

impl library "[[@TEST_NAME]]";

import Other library "o2";

var o1: Other.O1 = {};
var o2: Other.O2 = {};

// --- dup_o1.carbon

library "[[@TEST_NAME]]";

import Other library "o1";

// --- dup_o1.impl.carbon

impl library "[[@TEST_NAME]]";

import Other library "o1";

var o1: Other.O1 = {};

// --- import_conflict.carbon

library "[[@TEST_NAME]]";

import Other library "o1";

// --- fail_import_conflict.impl.carbon

// CHECK:STDERR: fail_import_conflict.impl.carbon:[[@LINE+9]]:6: in import [InImport]
// CHECK:STDERR: import_conflict.carbon:4:1: error: duplicate name being declared in the same scope [NameDeclDuplicate]
// CHECK:STDERR: import Other library "o1";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: fail_import_conflict.impl.carbon:[[@LINE+5]]:6: in import [InImport]
// CHECK:STDERR: local_other.carbon:4:1: note: name is previously declared here [NameDeclPrevious]
// CHECK:STDERR: class Other {}
// CHECK:STDERR: ^~~~~~~~~~~~~
// CHECK:STDERR:
impl library "[[@TEST_NAME]]";

import library "local_other";

// --- import_conflict_reverse.carbon

library "[[@TEST_NAME]]";

import library "local_other";

// --- fail_import_conflict_reverse.impl.carbon

impl library "[[@TEST_NAME]]";

// CHECK:STDERR: fail_import_conflict_reverse.impl.carbon:[[@LINE+8]]:1: error: duplicate name being declared in the same scope [NameDeclDuplicate]
// CHECK:STDERR: import Other library "o1";
// CHECK:STDERR: ^~~~~~
// CHECK:STDERR: fail_import_conflict_reverse.impl.carbon:[[@LINE-5]]:6: in import [InImport]
// CHECK:STDERR: import_conflict_reverse.carbon:4:1: in import [InImport]
// CHECK:STDERR: local_other.carbon:4:1: note: name is previously declared here [NameDeclPrevious]
// CHECK:STDERR: class Other {}
// CHECK:STDERR: ^~~~~~~~~~~~~
import Other library "o1";

// CHECK:STDOUT: --- c1.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C1: type = class_type @C1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C1 = %C1.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C1.decl: type = class_decl @C1 [template = constants.%C1] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C1 {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C1
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- c2.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C2: type = class_type @C2 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C2 = %C2.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C2.decl: type = class_decl @C2 [template = constants.%C2] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C2 {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C2
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- ns.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .NS = %NS
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %NS: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {} {}
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
// CHECK:STDOUT: --- o1.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %O1: type = class_type @O1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .O1 = %O1.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %O1.decl: type = class_decl @O1 [template = constants.%O1] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @O1 {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%O1
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- o2.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %O2: type = class_type @O2 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .O2 = %O2.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %O2.decl: type = class_decl @O2 [template = constants.%O2] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @O2 {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%O2
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- local_other.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Other: type = class_type @Other [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = %Other.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.decl: type = class_decl @Other [template = constants.%Other] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Other {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Other
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- mix_current_package.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//c1, C1, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C1 = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- mix_current_package.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C1: type = class_type @C1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %C1.val: %C1 = struct_value () [template]
// CHECK:STDOUT:   %C2: type = class_type @C2 [template]
// CHECK:STDOUT:   %C2.val: %C2 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//mix_current_package, C1, loaded [template = constants.%C1]
// CHECK:STDOUT:   %import_ref.2: type = import_ref Main//c2, C2, loaded [template = constants.%C2]
// CHECK:STDOUT:   %import_ref.3: <witness> = import_ref Main//c1, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//c1, inst14 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.5: <witness> = import_ref Main//c2, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.6 = import_ref Main//c2, inst14 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C1 = imports.%import_ref.1
// CHECK:STDOUT:     .C2 = imports.%import_ref.2
// CHECK:STDOUT:     .c1 = %c1
// CHECK:STDOUT:     .c2 = %c2
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %c1.var: ref %C1 = var c1
// CHECK:STDOUT:   %c1: ref %C1 = bind_name c1, %c1.var
// CHECK:STDOUT:   %c2.var: ref %C2 = var c2
// CHECK:STDOUT:   %c2: ref %C2 = bind_name c2, %c2.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C1 [from "c1.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C2 [from "c2.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.6
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.5
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc6_15.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc6_15.2: init %C1 = class_init (), file.%c1.var [template = constants.%C1.val]
// CHECK:STDOUT:   %.loc6_16: init %C1 = converted %.loc6_15.1, %.loc6_15.2 [template = constants.%C1.val]
// CHECK:STDOUT:   assign file.%c1.var, %.loc6_16
// CHECK:STDOUT:   %.loc7_15.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc7_15.2: init %C2 = class_init (), file.%c2.var [template = constants.%C2.val]
// CHECK:STDOUT:   %.loc7_16: init %C2 = converted %.loc7_15.1, %.loc7_15.2 [template = constants.%C2.val]
// CHECK:STDOUT:   assign file.%c2.var, %.loc7_16
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- dup_c1.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//c1, C1, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C1 = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- dup_c1.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C1: type = class_type @C1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %C1.val: %C1 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//dup_c1, C1, loaded [template = constants.%C1]
// CHECK:STDOUT:   %import_ref.2: <witness> = import_ref Main//c1, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.3 = import_ref Main//c1, inst14 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C1 = imports.%import_ref.1
// CHECK:STDOUT:     .c1 = %c1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %c1.var: ref %C1 = var c1
// CHECK:STDOUT:   %c1: ref %C1 = bind_name c1, %c1.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C1 [from "c1.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.3
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc6_15.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc6_15.2: init %C1 = class_init (), file.%c1.var [template = constants.%C1.val]
// CHECK:STDOUT:   %.loc6_16: init %C1 = converted %.loc6_15.1, %.loc6_15.2 [template = constants.%C1.val]
// CHECK:STDOUT:   assign file.%c1.var, %.loc6_16
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_ns.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: <namespace> = import_ref Main//ns, NS, loaded
// CHECK:STDOUT:   %NS: <namespace> = namespace %import_ref.1, [template] {
// CHECK:STDOUT:     .C = %import_ref.2
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .NS = imports.%NS
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_ns.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %C.val: %C = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: <namespace> = import_ref Main//use_ns, NS, loaded
// CHECK:STDOUT:   %NS: <namespace> = namespace %import_ref.1, [template] {
// CHECK:STDOUT:     .C = %import_ref.2
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.3: <witness> = import_ref Main//ns, loc5_13, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//ns, inst15 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .NS = imports.%NS
// CHECK:STDOUT:     .c = %c
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %c.var: ref %C = var c
// CHECK:STDOUT:   %c: ref %C = bind_name c, %c.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C [from "ns.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc4_16.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc4_16.2: init %C = class_init (), file.%c.var [template = constants.%C.val]
// CHECK:STDOUT:   %.loc4_17: init %C = converted %.loc4_16.1, %.loc4_16.2 [template = constants.%C.val]
// CHECK:STDOUT:   assign file.%c.var, %.loc4_17
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- mix_other.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- mix_other.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %O1: type = class_type @O1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %O1.val: %O1 = struct_value () [template]
// CHECK:STDOUT:   %O2: type = class_type @O2 [template]
// CHECK:STDOUT:   %O2.val: %O2 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     .O1 = %import_ref.1
// CHECK:STDOUT:     .O2 = %import_ref.4
// CHECK:STDOUT:     import Other//o2
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.2: <witness> = import_ref Other//o1, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.3 = import_ref Other//o1, inst14 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.5: <witness> = import_ref Other//o2, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.6 = import_ref Other//o2, inst14 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:     .o1 = %o1
// CHECK:STDOUT:     .o2 = %o2
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %o1.var: ref %O1 = var o1
// CHECK:STDOUT:   %o1: ref %O1 = bind_name o1, %o1.var
// CHECK:STDOUT:   %o2.var: ref %O2 = var o2
// CHECK:STDOUT:   %o2: ref %O2 = bind_name o2, %o2.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @O1 [from "o1.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.3
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @O2 [from "o2.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.6
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.5
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc6_21.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc6_21.2: init %O1 = class_init (), file.%o1.var [template = constants.%O1.val]
// CHECK:STDOUT:   %.loc6_22: init %O1 = converted %.loc6_21.1, %.loc6_21.2 [template = constants.%O1.val]
// CHECK:STDOUT:   assign file.%o1.var, %.loc6_22
// CHECK:STDOUT:   %.loc7_21.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc7_21.2: init %O2 = class_init (), file.%o2.var [template = constants.%O2.val]
// CHECK:STDOUT:   %.loc7_22: init %O2 = converted %.loc7_21.1, %.loc7_21.2 [template = constants.%O2.val]
// CHECK:STDOUT:   assign file.%o2.var, %.loc7_22
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- dup_o1.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- dup_o1.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %O1: type = class_type @O1 [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %O1.val: %O1 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     .O1 = %import_ref.1
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.2: <witness> = import_ref Other//o1, loc4_11, loaded [template = constants.%complete_type]
// CHECK:STDOUT:   %import_ref.3 = import_ref Other//o1, inst14 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:     .o1 = %o1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT:   %o1.var: ref %O1 = var o1
// CHECK:STDOUT:   %o1: ref %O1 = bind_name o1, %o1.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @O1 [from "o1.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.3
// CHECK:STDOUT:   complete_type_witness = imports.%import_ref.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc6_21.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %.loc6_21.2: init %O1 = class_init (), file.%o1.var [template = constants.%O1.val]
// CHECK:STDOUT:   %.loc6_22: init %O1 = converted %.loc6_21.1, %.loc6_21.2 [template = constants.%O1.val]
// CHECK:STDOUT:   assign file.%o1.var, %.loc6_22
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- import_conflict.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_import_conflict.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc11_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc11_6.2 = import <invalid>
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- import_conflict_reverse.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//local_other, Other, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_import_conflict_reverse.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Other: <namespace> = namespace file.%Other.import, [template] {
// CHECK:STDOUT:     import Other//o1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Other = imports.%Other
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc2_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc2_6.2 = import <invalid>
// CHECK:STDOUT:   %Other.import = import Other
// CHECK:STDOUT: }
// CHECK:STDOUT:
