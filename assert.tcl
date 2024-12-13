

namespace eval ::tools::assert {

    namespace export *
    
    proc assert {cond {msg "Assestion failed"}} {
	set cond [uplevel 1 [list expr $cond]]
	if {!$cond} {
	    return -code error $msg
	}
    }

    proc assert-eq {v1 v2 {msg ""}} {
	assert {$v1 == $v2}  "Assertation failed: expected $v1 == $v2 is false - $msg"
    }

    proc assert-ne {v1 v2 {msg ""}} {
	assert {$v1 != $v2} "Assertation failed: expected $v1 != $v2 is false - $msg"
    }

    proc assert-empty {v {msg ""}} {
	assert { $v == ""} "Assertation failed: expected <empty> == $v is false - $msg"
    }

    proc assert-non-empty {v {msg ""}} {
	assert { $v != ""} "Assertation failed: expected <non empty> != <empty> is false - $msg"
    }
    
}
