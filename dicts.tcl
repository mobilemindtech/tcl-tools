namespace eval ::tools::dicts {

  namespace export \
    dictget \
    dictmap \
    dictkeyslist \
    dictupdate \
    dicts

  # Get value from dict. Last 'key' is the default value
  #
  # @param d The dict
  # @patam Args keys to get
  # @return Value or default value
  proc get {d args} {
    set last [lindex $args end]
    set first [lrange $args 0 end-1]
    if {[dict exists $d {*}$first]} {
      dict get $d {*}$first
    } else {
      return $last
    }
  }

  # Map value of dict by key.
  #
  # <code>
  # map [dict key value] key {{v} {set v}}
  # </code>
  #
  # @param d The dict
  # @patam Dict key
  # @return Lambda to apply
  proc map {d key lambda} {
    if {[dict exists $d $key]} {
      apply $lambda [dict get $d $key]
    } else {
      return {}
    }
  }

  # Get list of values by keys
  #
  # @param d The dict
  # @param args List of keys to get
  proc keyslist {d args} {
    set values {}
    foreach k $args {
      lappend values [dict get $d $k]
    }
    return $values
  }

  # Update value by lambda result
  #
  # <code>
  # update [dict key value] key {{v} {return other}}
  # </code>
  #
  # @param var The dict
  # @param key The dict key
  # @param lambda The lambda
  proc update {var key lambda} {
    upvar $var d
    if {[dict exists $d $key]} {
      set val [dict get $d $key]
      set val [apply $lambda $val]
      dict set d $key $val
    }
  }

  # Function that handle all commands of dicts file
  #
  # @param cmd Command
  # @param d The dict
  # @param args The command arguments
  proc dicts {cmd d args} {
    switch $cmd {
      get {
        get $d {*}$args
      }
      map {
        map $d {*}$args
      }
      list {
        keyslist $d {*}$args
      }
      update {
        upvar $d val
        update val {*}$args
      }
      default {
        return -code error "unknown command: $cmd"
      }
    }
  }

  interp alias {} dictmap {} map
  interp alias {} dictget {} get
  interp alias {} dictupdate {} update
  interp alias {} dictkeyslist {} keyslist
}