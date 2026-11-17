//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// REQUIRES: target={{.+}}-windows-msvc, has-filecheck

// The VCRuntime library owns std::nothrow when libc++ uses its ABI. Defining
// the object in libc++.lib as well makes whole-archive links fail with a
// duplicate symbol.

// FileCheck, not grep: a Windows machine has no grep on its PATH.
// RUN: llvm-nm --defined-only "%{lib-dir}/libc++.lib" | FileCheck %s

// CHECK-NOT: ?nothrow@std@@3Unothrow_t@1@B
// CHECK: ?__throw_bad_alloc@std@@YAXXZ
// CHECK-NOT: ?nothrow@std@@3Unothrow_t@1@B
