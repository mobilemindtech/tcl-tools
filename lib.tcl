
package provide tools 1.0

namespace eval tools {}

set dir [file dirname [file normalize [info script]]]
source [file join $dir assert.tcl]
source [file join $dir dicts.tcl]
source [file join $dir lists.tcl]
source [file join $dir props.tcl]

