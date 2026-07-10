namespace eval ::tools::lists {

  namespace export \
  listmap \
  listfilter \
  lfiltermap \
  lfold \
  lfirst \
  lfirst \
  llast \
  ltail \
  lfindnext \
  lhead \
  lists

  ## Create new list with mapped items
  #
  # @param l List
  # @param lambda Lambda to apply create new item
  # @retrun New list
  proc map {l lambda} {
    set results []
    foreach it $l {
      lappend results [apply $lambda $it]
    }
    return $results
  }

  ## Return a new list with filtered items
  #
  # @param l List
  # @param lambda Lambda to apply filter
  # @retrun New list
  proc filter {l lambda} {
    set results []
    foreach it $l {
      if {[apply $lambda $it]} {
        lappend results $it
      }
    }
    return $results
  }

  ## Map only filteres items
  #
  # @param l List
  # @param lfilter Lambda to apply filter
  # @param lmap Lambda to apply map
  # @retrun New list
  proc filtermap {l lfilter lmap} {
    map [filter $l $lfilter] $lmap
  }

  ## Fold list
  #
  # @param l The list
  # @param acc Inicial accumulator
  # @param lambda Lambda to apply accumulator
  proc fold {l acc lambda} {
    foreach it $l {
      set acc [apply $lambda $acc $it]
    }
    return $acc
  }

  ## Get first or default value
  #
  # @param l The list
  # @param def The default value
  # @return The first value or default
  proc first {l {def ""}} {
    if {[llength $l] > 0} {
      lindex $l 0
    } else {
      return $def
    }
  }

  ## Get second or default value
  #
  # @param l The list
  # @param def The default value
  # @return The second value or default
  proc second {l {def ""}} {
    if {[llength $l] > 1} {
      lindex $l 1
    } else {
      return $def
    }
  }

  ## Get last or default value
  #
  # @param l The list
  # @param def The default value
  # @return The last value or default
  proc last {l {def ""}} {
    if {[llength $l] > 0} {
      lindex $l end
    } else {
      return $def
    }
  }

  ## Get tail of list
  #
  # @param l The list
  # @return The tail of list
  proc tail {l} {
    if {[llength $l] > 1} {
      lrange $l 1 end
    } else {
      return {}
    }
  }

  ## Get first or default value
  #
  # @param l The list
  # @param def The default value
  # @return The first value or default
  proc head {l {def ""}} {
    if {[llength $l] > 0} {
      lindex $l 0
    } else {
      return $def
    }
  }

  ## Get list[end-1]
  #
  # @param l The list
  # @param def Default value
  # @return list[end-1] or default
  proc butlast {l {def ""}} {
    if {[llength $l] > 1} {
      lrange $l 0 end-1
    } else {
      return $def
    }
  }

  ## Get list item by index
  #
  # @param l The list
  # @param i The index
  # @return The value of index or default value
  proc nth {l i {def ""}} {
    if {$i < [llength $l]} {
      lindex $l $i
    } else {
      return $def
    }
  }

  ## Get sublist start on index to end
  #
  # @param l The list
  # @param i The index
  # @return The new sublist
  proc nthrest {l i} {
    if {$i < [llength $l]} {
      lrange $l $i end
    } else {
      return {}
    }
  }

  ## Return next of query index
  #
  # Next is found index + 1. If -all is set, each founded index + 1 is returned orlse only first result is returned.
  # Of size is set, calcule next + size to generate a list of results that represents the next of founded index.
  #
  # args:
  #  -all Use to return all next values to all index found, orelse return only first result.
  #  -size Use to set return size (next+size), default is 1
  #
  # If next + max > list size, a erros is thrown
  # <code>
  #   [findnext {a b c d c y} c -all] == {d y}
  #   [findnext {a b -opt x y} -opt -size 2] == {x y}
  #   [findnext {a b -opt x y -opt z f} -opt -all -size 2] == {{x y} {z f}}
  #   [findnext {a b -opt x y c -opt z f d} -opt -all -size 2] == {{x y} {z f}}
  #   [findnext {a b -opt x y c -opt z f d} -opt -all] == {x z}
  #   [findnext {a b -opt x y c -opt z f d} -opt] == x
  # </code>
  # @param l The list
  # @param query Query to search
  # @param args -all -size
  # @return The next
  proc findnext {l query args} {
    set all [expr {[lsearch $args {-all}] > -1}]
    set size [lsearch $args {-size}]
    set sizenext [expr {$size + 1}]

    if {$size > -1 && $sizenext < [llength $args]} {
      set size [lindex $args $sizenext]
    } else {
      set size 1
    }

    set idxs [lsearch -all $l $query]
    set results {}
    foreach i $idxs {
      set next [expr {$i + 1}]
      set max [expr {$i + $size}]
      if {$max < [llength $l]} {

        if { !$all } {
          if { $size == 1 } {
            return [lindex $l $next]
          } else {
            return [lrange $l $next $max]
          }
        }

        lappend results [lrange $l $next $max]
      } else {
        return -code error "index $i has not next+$size"
      }
    }
    return $results
  }

  ## Function that handle all commands of lists file
  #
  # @param cmd Command
  # @param d The dict
  # @param args The command arguments
  proc lists {cmd args} {
    switch $cmd {
      map {map {*}$args}
      filter {filter {*}$args}
      filtermap {filtermap {*}$args}
      fold {fold {*}$args}
      first {first {*}$args}
      head {head {*}$args}
      second {second {*}$args}
      butlast {butlast {*}$args}
      last {last {*}$args}
      tail {tail {*}$args}
      head {head {*}$args}
      nth {nth {*}$args}
      nthrest {nthrest {*}$args}
      findnext {findnext {*}$args}
      default {
        return -code error "unknown command: $cmd"
      }
    }

  }

  interp alias {} listmap {} map
  interp alias {} listfilter {} filter
  interp alias {} lfiltermap {} filtermap
  interp alias {} lfold {} fold
  interp alias {} lfirst {} first
  interp alias {} lhead {} head
  interp alias {} lsecond {} second
  interp alias {} lbutlast {} butlast
  interp alias {} llast {} last
  interp alias {} ltail {} tail
  interp alias {} lfindnext {} findnext
}