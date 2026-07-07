namespace eval ::tools::lists {

  namespace export \
	list-map list-filter lfilter-map lfold lfirst lfind-next lfindall-next lfirst llast ltail lists

  proc map {l lambda} {
    set results []
    foreach it $l {
      lappend results [apply $lambda $it]
    }
    return $results
  }

  proc filter {l lambda} {
    set results []
    foreach it $l {
      if {[apply $lambda $it]} {
        lappend results $it
      }
    }
    return $results
  }

  proc filtermap {l lfilter lmap} {
    map [filter $l $lfilter] $lmap
  }

    # @param l list
    # @param acc accumulator
    # @param lambda {acc val {}}
  proc fold {l acc lambda} {
    foreach it $l {
      set acc [apply $lambda $acc $it]
    }
    return $acc
  }

  proc first {l {def ""}} {
    if {[llength $l] > 0} {
      lindex $l 0
    } else {
      return $def
    }
  }

  proc second {l {def ""}} {
    if {[llength $l] > 1} {
      lindex $l 1
    } else {
      return $def
    }
  }

  proc last {l {def ""}} {
    if {[llength $l] > 0} {
      lindex $l end
    } else {
      return $def
    }
  }

  proc tail {l} {
    if {[llength $l] > 1} {
      lrange $l 1 end
    } else {
      return {}
    }
  }

  proc butlast {l} {
    if {[llength $l] > 1} {
      lrange $l 0 end-1
    } else {
      return {}
    }
  }

    # find index, return index+1 if x = 1 or list of <index+1...index+1+x> if x > 0.
  proc findnext-x {l val x} {
    set i [lsearch $l $val]
    if {$i > 0} {
      if {$x == 1} {
        incr i
        if {$i < [llength $l]} {
          return [lindex $l $i]
        }
      } else {
        incr x $i
        incr i ;# next, position + 1
        if {$x < [llength $l]} {
          return [lrange $l $i $x]
        }
      }
    }
    return {}
  }

    # find by index, return index+1 or {}
  proc findnext {l val {x 1}} {
    findnext-x $l $val $x
  }

    # find all index by val. return list of <index+1...index+1+x>
  proc findallnext-x {l val x} {
    set idxs [lsearch -all $l $val]
    set results {}
    foreach i $idxs {
      set vals {}
      set y [expr {$i + 1}]
      set max [expr {$i + $x}]
      if {$max < [llength $l]} {
        lappend results [lrange $l $y $max]
      }
    }
    return $results
  }

    # return all index by val. return list of <index+1>
  proc findallnext {l val {x 0}} {

    if {$x > 1} {
      return [findallnext-x $l $val $x]
    }

    set idxs [lsearch -all $l $val]
    set results {}
    foreach i $idxs {
      set y [expr {$i + 1}]
      if {$y < [llength $l]} {
        lappend results [lindex $l $y]
      }
    }
    return $results
  }

  proc lists {cmd args} {
    switch $cmd {
      map { map {*}$args }
      filter { filter {*}$args }
      filtermap { filtermap {*}$args }
      fold {fold {*}$args}
      first {first {*}$args}
      head {first {*}$args}
      second {second {*}$args}
      butlast {butlast {*}$args}
      last {last {*}$args}
      tail {tail {*}$args}
      findnext {findnext {*}$args}
      findallnext {findallnext {*}$args}
      findnext-x {findnext {*}$args}
      findallnext-x {findallnext {*}$args}
      default {
        return -code error "unknown cmd"
      }
    }

  }

  interp alias {} list-map {} map
  interp alias {} list-filter {} filter
  interp alias {} lfilter-map {} filtermap
  interp alias {} lfold {} fold
  interp alias {} lfirst {} first
  interp alias {} lhead {} first
  interp alias {} lsecond {} second
  interp alias {} lbutlast {} butlast
  interp alias {} llast {} last
  interp alias {} ltail {} tail
  interp alias {} lfind-next {} findnext
  interp alias {} lfindall-next {} findallnext
}