#!/usr/bin/env tclsh

namespace eval ::tools::tcldoc {

# Gerenate markdown documentaiton from TCL code comments
#
# @param sources Source files do analyze
# @param docpath Path do create documentation
  proc generate_markdown {sources docpath} {
    set out [open $docpath w]
    set library_name [file tail [pwd]]

    # Global tracking structures
    set raw_entries {}
    set aliases_map [dict create]
    array set menu {}

    # --- PHASE 1: SCANNING & PARSING ---
    foreach file $sources {
      if {![file exists $file]} { continue }

      set fp [open $file r]
      set comment_block {}
      set inside_block 0
      set current_namespace "::"
      set current_class ""
      set namespace_brace_level -1
      set class_brace_level -1
      set current_brace_level 0

      while {[gets $fp line] >= 0} {
        set trimmed [string trim $line]

            # Track brace depth safely
        set opens [regexp -all -- {\{} $line]
        set closes [regexp -all -- {\}} $line]

            # Detect TclOO Class definitions
        if {[string match "oo::class create *" $trimmed] || [string match "class create *" $trimmed]} {
          if {[regexp {class\s+create\s+([^\s\{]+)} $trimmed -> class_name]} {
            set current_class $class_name
            if {![string match "::*" $current_class]} {
              set current_class "${current_namespace}::$current_class"
            }
            set class_brace_level $current_brace_level

            if {$inside_block} {
              lappend raw_entries [dict create \
                            type "class" \
                            name $current_class \
                            scope $current_namespace \
                            signature "oo::class create $class_name" \
                            comments $comment_block]
              set comment_block {}
              set inside_block 0
            }
          }
        }

            # Detect standard namespace definitions
        if {[string match "namespace eval *" $trimmed] && $current_class eq ""} {
          if {[regexp {namespace\s+eval\s+([^\s\{]+)} $trimmed -> ns_name]} {
            set current_namespace $ns_name
            if {![string match "::*" $current_namespace]} {
              set current_namespace "::$current_namespace"
            }
            set namespace_brace_level $current_brace_level
          }
        }

            # Update depth tracking
        incr current_brace_level [expr {$opens - $closes}]

            # Check if we exited class or namespace scopes
        if {$class_brace_level != -1 && $current_brace_level <= $class_brace_level} {
          set current_class ""
          set class_brace_level -1
        }
        if {$namespace_brace_level != -1 && $current_brace_level <= $namespace_brace_level} {
          set current_namespace "::"
          set namespace_brace_level -1
        }

            # Track global/namespace aliases
        if {[string match "interp alias *" $trimmed]} {
          if {[regexp {interp\s+alias\s+\{\}\s+(\S+)\s+\{\}\s+(\S+)} $trimmed -> alias_name real_cmd]} {
            set full_real_cmd $real_cmd
            if {![string match "::*" $full_real_cmd]} {
              set full_real_cmd "${current_namespace}::$real_cmd"
            }
            dict set aliases_map $full_real_cmd $alias_name
          }
          continue
        }

            # Capture documentation comments
        if {[string match "#*" $trimmed]} {
          set content [string trim [string range $trimmed 1 end]]
          lappend comment_block $content
          set inside_block 1
        } else {
                # ADJUSTED: Now checks for 'method *', 'proc *' OR 'constructor *'
          set is_cmd [expr {[string match "method *" $trimmed] || [string match "proc *" $trimmed] || [string match "constructor *" $trimmed]}]

          if {$inside_block && $is_cmd} {
            set signature [string trim $trimmed]

                    # Safe removal of trailing execution brace
            if {[string match "* \{" $signature]} {
              set signature [string range $signature 0 end-2]
              set signature [string trimright $signature]
            }

            set sig_parts [split $signature " "]
            set clean_sig_parts {}
            foreach part $sig_parts { if {$part ne ""} { lappend clean_sig_parts $part } }

            set cmd_type [lindex $clean_sig_parts 0]

                    # If it's a constructor, it won't have a custom name in index 1, its name is 'constructor'
            if {$cmd_type eq "constructor"} {
              set cmd_name "constructor"
            } else {
              set cmd_name [lindex $clean_sig_parts 1]
            }

            if {$current_class ne ""} {
              set entity_scope "Class: $current_class"
              set full_lookup_name "${current_class}::$cmd_name"
            } else {
              set entity_scope $current_namespace
              set full_lookup_name "${current_namespace}::$cmd_name"
            }

            lappend raw_entries [dict create \
                        type $cmd_type \
                        name $cmd_name \
                        lookup_id $full_lookup_name \
                        scope $entity_scope \
                        signature $signature \
                        comments $comment_block]
          }
          set comment_block {}
          set inside_block 0
        }
      }
      close $fp
    }

    # --- PHASE 2: RESOLVING ALIASES & GENERATING MARKDOWN ---
    set processed_entries {}

    foreach entry $raw_entries {
      set type [dict get $entry type]
      set scope [dict get $entry scope]
      set orig_name [dict get $entry name]
      set signature [dict get $entry signature]

      if {$type eq "class"} {
        lappend menu($orig_name) [list "Class Definition" $orig_name]
        set entry_md "## <a name=\"$orig_name\"></a>Class: **$orig_name**\n\n```tcl\n$signature\n```\n\n"
      } else {
        set lookup_id [dict get $entry lookup_id]
        set display_name $orig_name
        set extra_tag ""

        if {[dict exists $aliases_map $lookup_id]} {
          set display_name [dict get $aliases_map $lookup_id]
          set extra_tag " `\[alias exported]`"
          regsub -- $orig_name $signature $display_name signature
        }

            # Formatting anchor name safely
        set target_anchor "${scope}::$display_name"
        lappend menu($scope) [list $display_name $target_anchor]

            # Better visual label for constructor
        if {$type eq "constructor"} {
          set entry_md "## <a name=\"$target_anchor\"></a>Scope: `$scope` | **$type**\n\n"
        } else {
          set entry_md "## <a name=\"$target_anchor\"></a>Scope: `$scope` | $type: **$display_name**$extra_tag\n\n"
        }

        append entry_md "```tcl\n$signature\n```\n\n"
      }

        # Process comments block
      set in_code 0
      set params {}
      foreach c_line [dict get $entry comments] {
        if {[string match "<code>" $c_line]} { append entry_md "```tcl\n"; set in_code 1; continue }
        if {[string match "</code>" $c_line]} { append entry_md "```\n\n"; set in_code 0; continue }
        if {$in_code} { append entry_md "$c_line\n"; continue }

        if {[string match "@param*" $c_line]} {
          set parts [split $c_line " "]
          set clean_parts {}
          foreach p $parts { if {$p ne ""} { lappend clean_parts $p } }
          set p_name [lindex $clean_parts 1]
          set p_desc [lrange $clean_parts 2 end]
          lappend params "  * **$p_name**: $p_desc"
          continue
        }
        if {$c_line ne ""} { append entry_md "$c_line  \n" } else { append entry_md "\n" }
      }

      if {[llength $params] > 0} {
        append entry_md "\n**Parameters:**\n\n"
        foreach p $params { append entry_md "$p\n" }
      }
      append entry_md "\n---\n"
      lappend processed_entries $entry_md
    }

    # --- OUTPUT GENERATION ---
    puts $out "# Library: $library_name — Source Code Documentation\n"
    puts $out "Generated automatically via Tcl script.\n"
    puts $out "---"

    # 1. Output Navigation Menu
    puts $out "## Navigation Menu\n"
    foreach section [lsort [array names menu]] {
      if {[string match "Class: *" $section]} {
        puts $out "* **$section (Members):**"
      } else {
        puts $out "* **Namespace:** `$section`"
      }
      foreach cmd_info $menu($section) {
        set name [lindex $cmd_info 0]
        set link [lindex $cmd_info 1]
        puts $out "    * \[$name\](#$link)"
      }
    }
    puts $out "\n---\n"

    # 2. Output Document Entries
    foreach entry $processed_entries {
      puts $out $entry
    }

    close $out
    puts "Done! Full documentation including Constructors built in: $docpath"
  }
}

proc show_help {} {
  puts "Usage:"
  puts ""
  puts "tcldoc <options>"
  puts ""
  puts "Options:"
  puts "--doc        Documentation file destination"
  puts "--sources    Documentation sources path"
  puts "--help       Show this"
  puts ""
  puts "Example:"
  puts "tcldoc --sources `pwd` --doc `pwd`/doc.md"
}

proc main {args} {

  set i [lsearch $args --doc]

  if {$i > 0} {
    set docpath [lindex $args [expr {$i+1}]]
  } else {
    set docpath "[pwd]/Documentation.md"
  }

  set i [lsearch $args --sources]

  if {$i > 0} {
    set path [lindex $args [incr {$i+1}]]
    set tcl_files [glob -nocomplain $path/*.tcl]
  } else {
    set tcl_files [glob -nocomplain [pwd]/*.tcl]
    set self [file tail [info script]]
    set idx [lsearch $tcl_files $self]
    if {$idx != -1} { set tcl_files [lreplace $tcl_files $idx $idx] }
  }

  if {[lsearch $args --help] > -1} {
    show_help
    exit 0
  }

  if {[llength $tcl_files] == 0} {
    puts "No target .tcl files found."
  } else {
    ::tools::tcldoc::generate_markdown $tcl_files $docpath
  }

}

main {*}::argv