package require TclOO

namespace import ::tools::lists::lists
namespace import ::tools::dicts::dicts

namespace eval ::tools::props {

  namespace export Props

  #
  # Class to work with dynamic props
  #
  oo::class create Props {
    variable MyProps PermitsNew JsonProps OnlyJsonProps AllowedProps
  # Contruct new Props
  #
  # <code>
  # oo:define MyClass {
  #   superclass Props
  #   constructor {
  #     next prop1 prop2 prop3
  #   }
  # }
  # </code>
  # Use -permits-new to permitir add new props after object created. The default
  # behavior is throw error when props not found
  # @param args list of allowed props
    constructor {args} {
      my set_allowed_props {*}$args
    }

  # Configure allowed props
  #
    method set_allowed_props {args} {
      my variable MyProps PermitsNew AllowedProps OnlyJsonProps
      set MyProps [dict create]
      set AllowedProps [list]
      set PermitsNew [expr {[llength $args] == 0}]
      set JsonProps [dict create]
      set OnlyJsonProps false
      foreach prop $args {

        if {$prop == "-permits-new"} {
          set PermitsNew true
          continue
        }

        dict set MyProps $prop {}
        lappend AllowedProps $prop
      }
    }

    # Configute to permits add new props
    #
    method pemits_new_props {} {
      my variable PermitsNew
      set PermitsNew true
    }

  # Get or set prop
  # <code>
  # set name \[$obj prop name\]
  # $obj prop name {John Doo}
  # </code>
    method prop {args} {
      my variable MyProps PermitsNew AllowedProps
      set argc [llength $args]

      if {$argc == 0 || $argc > 2} {
        return -code error "use prop set or get to [info object class [self]]"
      }

      set prop_name [lindex $args 0]

      if {!$PermitsNew && [lsearch -exact $AllowedProps $prop_name] == -1} {
        return -code error "prop $prop_name not allowed to [info object class [self]]"
      }

      if {$argc == 2} {
        dict set MyProps $prop_name [lindex $args 1]
      }

      dict get $MyProps $prop_name
    }

  # Get prop or default value
  # <code>
  # set name \[$obj propdef name {John Doo}\]
  # </code>
    method propdef {name def} {
      my variable MyProps
      if {[my present $name]} {
        my prop $name
      } else {
        return $def
      }
    }

  # Map prop value to apply lambda result
  # <code>
  # set i \[$obj propmap counter {{i} {expr i + 1}}\]
  # </code>
    method propmap {name body} {
      apply $body [my prop $name]
    }

  # Commands to property of type list
  #
  # <code>
  # $obj proplist length
  # $obj proplist search <query>
  # $obj proplist map <lambda>
  # $obj proplist filter <lambda>
  # $obj proplist filtermap <lambda filter> <lambda map>
  # </code>
  #
  # @param propname Prop name
  # @param cmd Command
  # @param args Command args
  # @return Mapped list or filtered list
    method proplist {propname cmd args} {
      set val [my prop $propname]
      switch $cmd {
        length {
          llength $val
        }
        search {
          lsearch $val {*}$args
        }
        map {
          set lambda [lindex $args 0]
          return [lists map $val $lambda]
        }
        filter {
          set lambda [lindex $args 0]
          return [lists filter $val $lambda]
        }
        filtermap {
          lassign $args filter map
          return [lists filtermap $val $filter $map]
        }
      }
    }

    # Command to execute o prop of type list
    #
    # <code>
    # $obj propdict exists <key>
    # $obj propdict get <key> <defult>
    # $obj propdict size
    # $obj propdict set <key> <value>
    # </code>
    #
    # @param propname Prop name
    # @param cmd Command
    # @param args Arguments
    method propdict {propname cmd args} {
      set val [my prop $propname]
      switch $cmd {
        exists {
          lassign $args key
          dict exists $val $key
        }
        get {
          if {[llength $args] > 1} {
            return [dicts get $val {*}$args]
          } else {
            return [dict get $val [lindex $args 0]]
          }
        }
        size {
          dict size $val
        }
        set {
          set key [lindex $args 0]
          set values [lrange $args 1 end]
          dict set val $key {*}$values
          my prop $propname $val
        }
      }
    }

  # Change prop value to lambda result
  # <code>
  # set i \[$obj propmap counter {{i} {expr i + 1}}\]
  # </code>
  #
  # @param name Prop name
  # @param lambda Lambda to transform prop value
    method propapply {name lambda} {
      my prop $name [my propmap $name $lambda]
    }

    # Megre value of prop type list
    #
    # @param name Prop name
    # @param values List values to merge
    method propmerge {name values} {
      set val [my propdef $name {}]
      my prop $name [list {*}$val {*}$values]
    }

  # Set props from dict
  #
  # <code>
  # $obj props {id 1 name jonh}
  # </code>
  # @param The dict
    method props {args} {
      my variable MyProps PermitsNew AllowedProps

      if {[llength $args] == 0} {
        return $MyProps
      }

      foreach {k v} $args {
        if {!$PermitsNew && [lsearch -exact $AllowedProps $k] == -1} {
          return -code error "prop $k not allowed to [info object class [self]]"
        }
        dict set MyProps $k $v
      }
      return [self]
    }

    # Update props based on lambda map
    #
    # @param args The props list, the last value need be a lambda
    method updatemap {args} {
      set lambda [lists last $args]
      set keys [lists butlast $args]
      foreach k $keys {
        my prop $k [apply $lambda [my prop $k]]
      }
      return [self]
    }

    # Get value from boolean prop
    #
    # @param name The prop name
    # @return true if property is 1 or true
    method bool {name} {
      set val [my prop $name]
      expr {$val == 1 || $val == true}
    }

    # Check if a prop was defined
    #
    # @return true if is present, orelse false
    method present {name} {
      expr {[my prop $name] != ""}
    }

    # Convert props to dict
    #
    # @resurn The dict
    method to_dict {} {
      my variable MyProps
      set d [dict create]
      dict for {k v} $MyProps {
        dict set d $k $v
      }
      return $d
    }

    # Add the props from dict
    #
    # @param The dict
    method from_dict {d} {
      my variable AllowedProps
      foreach k $AllowedProps {
        if {[dict exists $d $k]} {
          my prop $k [dict get $d $k]
        }
      }
      return [self]
    }

    # Configure JSON props to generation.
    #
    # <code>
    # $obj set_json_props [{<prop name> <json name> <?json type>}]
    # $obj set_json_props [{id ID int} {name NAME string}]
    # </code>
    #
    # types: int, float, str, bool
    #
    # @param args List of fields configurations
    method set_json_props {args} {
      my variable JsonProps AllowedProps
      set data [dict create]

      foreach item $args {
        lassign $item field name type
        if {[lsearch $AllowedProps $field] > -1} {
          dict set data $field [list $name $type]
        }
      }
      set JsonProps $data
    }

    # Configure to JSON generation using only keys configured on JsonProps
    #
    method set_only_json_props {} {
      my variable OnlyJsonProps
      set OnlyJsonProps true
    }

    # Return a dict with two keys, data and tpl. Data contains
    # a dict with json values based on configs JsonProps and OnlyJsonProps
    #
    # <code>
    # {json {ID 1 NAME jonh} tpl {ID int NAME string}}
    # </code>
    #
    # If a prop not be configured by JsonProps and OnlyJsonProps is false, so
    # it not will be present on tpl values
    #
    # @return The json result
    method to_json {} {
      my variable JsonProps OnlyJsonProps AllowedProps
      set json [dict create]
      set tpl [dict create]
      foreach k $AllowedProps {
        set val [my prop $k]
        set prop $k
        if {[dict exists $JsonProps $k]} {
          set data [dict get $JsonProps $k]
          lassign $data prop type
          dict set tpl $prop $type
        } else {
          if { $OnlyJsonProps } {
            continue
          }
        }
        dict set json $prop $val
      }
      return [dict create data $json tpl $tpl]
    }
  }
}