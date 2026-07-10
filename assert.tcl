namespace eval ::tools::assert {

  namespace export *

  # Throw error
  #
  # @param msg Message to fail
  proc fail {{msg "Assestion failed"}} {
    return -code error $msg
  }

  # Return error if is false
  #
  # @param bool Value
  # @param msg Message to fail
  proc assert-true {bool {msg "Assestion failed"}} {
    if {!$bool} {
      return -code error $msg
    }
  }

  # Return error if is true
  #
  # @param bool Value
  # @param msg Message to fail
  proc assert-false {bool {msg "Assestion failed"}} {
    if {$bool} {
      return -code error $msg
    }
  }

  # Return error if condition is false
  #
  # @param cond Condition
  # @param msg Message to fail on error
  proc assert {cond {msg "Assestion failed"}} {
    set cond [uplevel 1 [list expr $cond]]
    if {!$cond} {
      return -code error $msg
    }
  }

  # Return error if v1 not equal v2
  #
  # @param v1 First value
  # @param v2 Second value
  # @param msg Message to fail on error
  proc assert-eq {v1 v2 {msg ""}} {
    assert {$v1 == $v2}  "Assertation failed: expected $v1 == $v2 is false - $msg"
  }

  # Return error if v1 is equal v2
  #
  # @param v1 First value
  # @param v2 Second value
  # @param msg Message to fail on error
  proc assert-ne {v1 v2 {msg ""}} {
    assert {$v1 != $v2} "Assertation failed: expected $v1 != $v2 is false - $msg"
  }

  # Return error v is empty
  #
  # @param v Value to check
  # @param msg Message to fail on error
  proc assert-empty {v {msg ""}} {
    assert { $v == ""} "Assertation failed: expected <empty> == $v is false - $msg"
  }

  # Return error v is not empty
  #
  # @param v Value to check
  # @param msg Message to fail on error
  proc assert-non-empty {v {msg ""}} {
    assert { $v != ""} "Assertation failed: expected <non empty> != <empty> is false - $msg"
  }
}