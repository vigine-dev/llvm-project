! RUN: %not_todo_cmd bbc -fopenacc -emit-hlfir %s -o - 2>&1 | FileCheck %s

subroutine sub1(x, a)
  real :: x(200)
  integer :: a

  !$acc loop
  do i = 100, 200
    x(i) = 1.0
    if (i == a) return
  end do

  i = 2
end

! CHECK: not yet implemented: unstructured do loop in acc loop construct

!! TODO: For now this is disabled because we emit an NYI if an unstructured loop is
!! associated with an OpenACC directive.
!!
!! xCHECK-LABEL: func.func @_QPsub1
!! xCHECK: %[[A:.*]]:2 = hlfir.declare %arg1 dummy_scope %{{[0-9]+}} arg {{[0-9]+}} {uniq_name = "_QFsub1Ea"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!! xCHECK: %[[I:.*]]:2 = hlfir.declare %{{[0-9]+}} {uniq_name = "_QFsub1Ei"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
!! xCHECK: %[[EXIT_COND:.*]] = acc.loop
!! xCHECK:   %[[I:.*]]:2 = hlfir.declare %{{[0-9]+}} {uniq_name = "_QFsub1Ei"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
!! xCHECK: ^bb{{.*}}:
!! xCHECK: ^bb{{.*}}:
!! xCHECK:   %[[LOAD_I:.*]] = fir.load %[[I]]#0 : !fir.ref<i32>
!! xCHECK:   %[[LOAD_I:.*]] = fir.load %[[I]]#0 : !fir.ref<i32>
!! xCHECK:   %[[LOAD_A:.*]] = fir.load %[[A]]#0 : !fir.ref<i32>
!! xCHECK:   %[[CMP:.*]] = arith.cmpi eq, %[[LOAD_I]], %[[LOAD_A]] : i32
!! xCHECK:   cf.cond_br %[[CMP]], ^[[EARLY_RET:.*]], ^[[NO_RET:.*]]
!! xCHECK: ^[[EARLY_RET]]:
!! xCHECK:   acc.yield %true : i1
!! xCHECK: ^[[NO_RET]]:
!! xCHECK:   cf.br ^bb{{.*}}
!! xCHECK: ^bb{{.*}}:
!! xCHECK:   acc.yield %false : i1
!! xCHECK: }(i1)
!! xCHECK: cf.cond_br %[[EXIT_COND]], ^[[EXIT_BLOCK:.*]], ^[[CONTINUE_BLOCK:.*]]
!! xCHECK: ^[[CONTINUE_BLOCK]]:
!! xCHECK:   hlfir.assign
!! xCHECK:   cf.br ^[[EXIT_BLOCK]]
!! xCHECK: ^[[EXIT_BLOCK]]:
!! xCHECK:   return
!! xCHECK: }

