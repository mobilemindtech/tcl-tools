# Library: tools — Source Code Documentation

Generated automatically via Tcl script.

---
## Navigation Menu

* **Namespace:** `::tools::assert`
    * [fail](#::tools::assert::fail)
    * [assert-true](#::tools::assert::assert-true)
    * [assert-false](#::tools::assert::assert-false)
    * [assert](#::tools::assert::assert)
    * [assert-eq](#::tools::assert::assert-eq)
    * [assert-ne](#::tools::assert::assert-ne)
    * [assert-empty](#::tools::assert::assert-empty)
    * [assert-non-empty](#::tools::assert::assert-non-empty)
* **Namespace:** `::tools::dicts`
    * [dictget](#::tools::dicts::dictget)
    * [dictmap](#::tools::dicts::dictmap)
    * [dictkeyslist](#::tools::dicts::dictkeyslist)
    * [dictupdate](#::tools::dicts::dictupdate)
    * [dicts](#::tools::dicts::dicts)
* **Namespace:** `::tools::lists`
    * [listmap](#::tools::lists::listmap)
    * [listfilter](#::tools::lists::listfilter)
    * [lfiltermap](#::tools::lists::lfiltermap)
    * [lfold](#::tools::lists::lfold)
    * [lhead](#::tools::lists::lhead)
    * [lsecond](#::tools::lists::lsecond)
    * [llast](#::tools::lists::llast)
    * [ltail](#::tools::lists::ltail)
    * [head](#::tools::lists::head)
    * [lbutlast](#::tools::lists::lbutlast)
    * [nth](#::tools::lists::nth)
    * [nthrest](#::tools::lists::nthrest)
    * [lfindnext](#::tools::lists::lfindnext)
    * [lists](#::tools::lists::lists)
* **Namespace:** `::tools::props::Props`
    * [Class Definition](#::tools::props::Props)
* **Namespace:** `::tools::tcldoc`
    * [generate_markdown](#::tools::tcldoc::generate_markdown)
* **Class: ::tools::props::Props (Members):**
    * [constructor](#Class: ::tools::props::Props::constructor)
    * [set_allowed_props](#Class: ::tools::props::Props::set_allowed_props)
    * [pemits_new_props](#Class: ::tools::props::Props::pemits_new_props)
    * [prop](#Class: ::tools::props::Props::prop)
    * [propdef](#Class: ::tools::props::Props::propdef)
    * [propmap](#Class: ::tools::props::Props::propmap)
    * [proplist](#Class: ::tools::props::Props::proplist)
    * [propdict](#Class: ::tools::props::Props::propdict)
    * [propapply](#Class: ::tools::props::Props::propapply)
    * [propmerge](#Class: ::tools::props::Props::propmerge)
    * [props](#Class: ::tools::props::Props::props)
    * [updatemap](#Class: ::tools::props::Props::updatemap)
    * [bool](#Class: ::tools::props::Props::bool)
    * [present](#Class: ::tools::props::Props::present)
    * [to_dict](#Class: ::tools::props::Props::to_dict)
    * [from_dict](#Class: ::tools::props::Props::from_dict)
    * [set_json_props](#Class: ::tools::props::Props::set_json_props)
    * [set_only_json_props](#Class: ::tools::props::Props::set_only_json_props)
    * [to_json](#Class: ::tools::props::Props::to_json)

---

## <a name="::tools::assert::fail"></a>Scope: `::tools::assert` | proc: **fail**

```tcl
proc fail {{msg "Assestion failed"}}
```

Throw error  


**Parameters:**

  * **msg**: Message to fail

---

## <a name="::tools::assert::assert-true"></a>Scope: `::tools::assert` | proc: **assert-true**

```tcl
proc assert-true {bool {msg "Assestion failed"}}
```

Return error if is false  


**Parameters:**

  * **bool**: Value
  * **msg**: Message to fail

---

## <a name="::tools::assert::assert-false"></a>Scope: `::tools::assert` | proc: **assert-false**

```tcl
proc assert-false {bool {msg "Assestion failed"}}
```

Return error if is true  


**Parameters:**

  * **bool**: Value
  * **msg**: Message to fail

---

## <a name="::tools::assert::assert"></a>Scope: `::tools::assert` | proc: **assert**

```tcl
proc assert {cond {msg "Assestion failed"}}
```

Return error if condition is false  


**Parameters:**

  * **cond**: Condition
  * **msg**: Message to fail on error

---

## <a name="::tools::assert::assert-eq"></a>Scope: `::tools::assert` | proc: **assert-eq**

```tcl
proc assert-eq {v1 v2 {msg ""}}
```

Return error if v1 not equal v2  


**Parameters:**

  * **v1**: First value
  * **v2**: Second value
  * **msg**: Message to fail on error

---

## <a name="::tools::assert::assert-ne"></a>Scope: `::tools::assert` | proc: **assert-ne**

```tcl
proc assert-ne {v1 v2 {msg ""}}
```

Return error if v1 is equal v2  


**Parameters:**

  * **v1**: First value
  * **v2**: Second value
  * **msg**: Message to fail on error

---

## <a name="::tools::assert::assert-empty"></a>Scope: `::tools::assert` | proc: **assert-empty**

```tcl
proc assert-empty {v {msg ""}}
```

Return error v is empty  


**Parameters:**

  * **v**: Value to check
  * **msg**: Message to fail on error

---

## <a name="::tools::assert::assert-non-empty"></a>Scope: `::tools::assert` | proc: **assert-non-empty**

```tcl
proc assert-non-empty {v {msg ""}}
```

Return error v is not empty  


**Parameters:**

  * **v**: Value to check
  * **msg**: Message to fail on error

---

## <a name="::tools::tcldoc::generate_markdown"></a>Scope: `::tools::tcldoc` | proc: **generate_markdown**

```tcl
proc generate_markdown {sources docpath}
```

Gerenate markdown documentaiton from TCL code comments  


**Parameters:**

  * **sources**: Source files do analyze
  * **docpath**: Path do create documentation

---

## <a name="::tools::props::Props"></a>Class: **::tools::props::Props**

```tcl
oo::class create Props
```


Class to work with dynamic props  


---

## <a name="Class: ::tools::props::Props::constructor"></a>Scope: `Class: ::tools::props::Props` | **constructor**

```tcl
constructor {args}
```

Contruct new Props  

```tcl
oo:define MyClass {
superclass Props
constructor {
next prop1 prop2 prop3
}
}
```

Use -permits-new to permitir add new props after object created. The default  
behavior is throw error when props not found  

**Parameters:**

  * **args**: list of allowed props

---

## <a name="Class: ::tools::props::Props::set_allowed_props"></a>Scope: `Class: ::tools::props::Props` | method: **set_allowed_props**

```tcl
method set_allowed_props {args}
```

Configure allowed props  


---

## <a name="Class: ::tools::props::Props::pemits_new_props"></a>Scope: `Class: ::tools::props::Props` | method: **pemits_new_props**

```tcl
method pemits_new_props {}
```

Configute to permits add new props  


---

## <a name="Class: ::tools::props::Props::prop"></a>Scope: `Class: ::tools::props::Props` | method: **prop**

```tcl
method prop {args}
```

Get or set prop  
```tcl
set name \[$obj prop name\]
$obj prop name {John Doo}
```


---

## <a name="Class: ::tools::props::Props::propdef"></a>Scope: `Class: ::tools::props::Props` | method: **propdef**

```tcl
method propdef {name def}
```

Get prop or default value  
```tcl
set name \[$obj propdef name {John Doo}\]
```


---

## <a name="Class: ::tools::props::Props::propmap"></a>Scope: `Class: ::tools::props::Props` | method: **propmap**

```tcl
method propmap {name body}
```

Map prop value to apply lambda result  
```tcl
set i \[$obj propmap counter {{i} {expr i + 1}}\]
```


---

## <a name="Class: ::tools::props::Props::proplist"></a>Scope: `Class: ::tools::props::Props` | method: **proplist**

```tcl
method proplist {propname cmd args}
```

Commands to property of type list  

```tcl
$obj proplist length
$obj proplist search <query>
$obj proplist map <lambda>
$obj proplist filter <lambda>
$obj proplist filtermap <lambda filter> <lambda map>
```


@return Mapped list or filtered list  

**Parameters:**

  * **propname**: Prop name
  * **cmd**: Command
  * **args**: Command args

---

## <a name="Class: ::tools::props::Props::propdict"></a>Scope: `Class: ::tools::props::Props` | method: **propdict**

```tcl
method propdict {propname cmd args}
```

Command to execute o prop of type list  

```tcl
$obj propdict exists <key>
$obj propdict get <key> <defult>
$obj propdict size
$obj propdict set <key> <value>
```



**Parameters:**

  * **propname**: Prop name
  * **cmd**: Command
  * **args**: Arguments

---

## <a name="Class: ::tools::props::Props::propapply"></a>Scope: `Class: ::tools::props::Props` | method: **propapply**

```tcl
method propapply {name lambda}
```

Change prop value to lambda result  
```tcl
set i \[$obj propmap counter {{i} {expr i + 1}}\]
```



**Parameters:**

  * **name**: Prop name
  * **lambda**: Lambda to transform prop value

---

## <a name="Class: ::tools::props::Props::propmerge"></a>Scope: `Class: ::tools::props::Props` | method: **propmerge**

```tcl
method propmerge {name values}
```

Megre value of prop type list  


**Parameters:**

  * **name**: Prop name
  * **values**: List values to merge

---

## <a name="Class: ::tools::props::Props::props"></a>Scope: `Class: ::tools::props::Props` | method: **props**

```tcl
method props {args}
```

Set props from dict  

```tcl
$obj props {id 1 name jonh}
```


**Parameters:**

  * **The**: dict

---

## <a name="Class: ::tools::props::Props::updatemap"></a>Scope: `Class: ::tools::props::Props` | method: **updatemap**

```tcl
method updatemap {args}
```

Update props based on lambda map  


**Parameters:**

  * **args**: The props list, the last value need be a lambda

---

## <a name="Class: ::tools::props::Props::bool"></a>Scope: `Class: ::tools::props::Props` | method: **bool**

```tcl
method bool {name}
```

Get value from boolean prop  

@return true if property is 1 or true  

**Parameters:**

  * **name**: The prop name

---

## <a name="Class: ::tools::props::Props::present"></a>Scope: `Class: ::tools::props::Props` | method: **present**

```tcl
method present {name}
```

Check if a prop was defined  

@return true if is present, orelse false  

---

## <a name="Class: ::tools::props::Props::to_dict"></a>Scope: `Class: ::tools::props::Props` | method: **to_dict**

```tcl
method to_dict {}
```

Convert props to dict  

@resurn The dict  

---

## <a name="Class: ::tools::props::Props::from_dict"></a>Scope: `Class: ::tools::props::Props` | method: **from_dict**

```tcl
method from_dict {d}
```

Add the props from dict  


**Parameters:**

  * **The**: dict

---

## <a name="Class: ::tools::props::Props::set_json_props"></a>Scope: `Class: ::tools::props::Props` | method: **set_json_props**

```tcl
method set_json_props {args}
```

Configure JSON props to generation.  

```tcl
$obj set_json_props [{<prop name> <json name> <?json type>}]
$obj set_json_props [{id ID int} {name NAME string}]
```


types: int, float, str, bool  


**Parameters:**

  * **args**: List of fields configurations

---

## <a name="Class: ::tools::props::Props::set_only_json_props"></a>Scope: `Class: ::tools::props::Props` | method: **set_only_json_props**

```tcl
method set_only_json_props {}
```

Configure to JSON generation using only keys configured on JsonProps  


---

## <a name="Class: ::tools::props::Props::to_json"></a>Scope: `Class: ::tools::props::Props` | method: **to_json**

```tcl
method to_json {}
```

Return a dict with two keys, data and tpl. Data contains  
a dict with json values based on configs JsonProps and OnlyJsonProps  

```tcl
{json {ID 1 NAME jonh} tpl {ID int NAME string}}
```


If a prop not be configured by JsonProps and OnlyJsonProps is false, so  
it not will be present on tpl values  

@return The json result  

---

## <a name="::tools::lists::listmap"></a>Scope: `::tools::lists` | proc: **listmap** `[alias exported]`

```tcl
proc listmap {l lambda}
```

# Create new list with mapped items  

@retrun New list  

**Parameters:**

  * **l**: List
  * **lambda**: Lambda to apply create new item

---

## <a name="::tools::lists::listfilter"></a>Scope: `::tools::lists` | proc: **listfilter** `[alias exported]`

```tcl
proc listfilter {l lambda}
```

# Return a new list with filtered items  

@retrun New list  

**Parameters:**

  * **l**: List
  * **lambda**: Lambda to apply filter

---

## <a name="::tools::lists::lfiltermap"></a>Scope: `::tools::lists` | proc: **lfiltermap** `[alias exported]`

```tcl
proc lfiltermap {l lfilter lmap}
```

# Map only filteres items  

@retrun New list  

**Parameters:**

  * **l**: List
  * **lfilter**: Lambda to apply filter
  * **lmap**: Lambda to apply map

---

## <a name="::tools::lists::lfold"></a>Scope: `::tools::lists` | proc: **lfold** `[alias exported]`

```tcl
proc lfold {l acc lambda}
```

# Fold list  


**Parameters:**

  * **l**: The list
  * **acc**: Inicial accumulator
  * **lambda**: Lambda to apply accumulator

---

## <a name="::tools::lists::lhead"></a>Scope: `::tools::lists` | proc: **lhead** `[alias exported]`

```tcl
proc lhead {l {def ""}}
```

# Get first or default value  

@return The first value or default  

**Parameters:**

  * **l**: The list
  * **def**: The default value

---

## <a name="::tools::lists::lsecond"></a>Scope: `::tools::lists` | proc: **lsecond** `[alias exported]`

```tcl
proc lsecond {l {def ""}}
```

# Get second or default value  

@return The second value or default  

**Parameters:**

  * **l**: The list
  * **def**: The default value

---

## <a name="::tools::lists::llast"></a>Scope: `::tools::lists` | proc: **llast** `[alias exported]`

```tcl
proc llast {l {def ""}}
```

# Get last or default value  

@return The last value or default  

**Parameters:**

  * **l**: The list
  * **def**: The default value

---

## <a name="::tools::lists::ltail"></a>Scope: `::tools::lists` | proc: **ltail** `[alias exported]`

```tcl
proc ltail {l}
```

# Get tail of list  

@return The tail of list  

**Parameters:**

  * **l**: The list

---

## <a name="::tools::lists::head"></a>Scope: `::tools::lists` | proc: **head**

```tcl
proc head {l {def ""}}
```

# Get first or default value  

@return The first value or default  

**Parameters:**

  * **l**: The list
  * **def**: The default value

---

## <a name="::tools::lists::lbutlast"></a>Scope: `::tools::lists` | proc: **lbutlast** `[alias exported]`

```tcl
proc lbutlast {l {def ""}}
```

# Get list[end-1]  

@return list[end-1] or default  

**Parameters:**

  * **l**: The list
  * **def**: Default value

---

## <a name="::tools::lists::nth"></a>Scope: `::tools::lists` | proc: **nth**

```tcl
proc nth {l i {def ""}}
```

# Get list item by index  

@return The value of index or default value  

**Parameters:**

  * **l**: The list
  * **i**: The index

---

## <a name="::tools::lists::nthrest"></a>Scope: `::tools::lists` | proc: **nthrest**

```tcl
proc nthrest {l i}
```

# Get sublist start on index to end  

@return The new sublist  

**Parameters:**

  * **l**: The list
  * **i**: The index

---

## <a name="::tools::lists::lfindnext"></a>Scope: `::tools::lists` | proc: **lfindnext** `[alias exported]`

```tcl
proc lfindnext {l query args}
```

# Return next of query index  

Next is found index + 1. If -all is set, each founded index + 1 is returned orlse only first result is returned.  
Of size is set, calcule next + size to generate a list of results that represents the next of founded index.  

args:  
-all Use to return all next values to all index found, orelse return only first result.  
-size Use to set return size (next+size), default is 1  

If next + max > list size, a erros is thrown  
```tcl
[findnext {a b c d c y} c -all] == {d y}
[findnext {a b -opt x y} -opt -size 2] == {x y}
[findnext {a b -opt x y -opt z f} -opt -all -size 2] == {{x y} {z f}}
[findnext {a b -opt x y c -opt z f d} -opt -all -size 2] == {{x y} {z f}}
[findnext {a b -opt x y c -opt z f d} -opt -all] == {x z}
[findnext {a b -opt x y c -opt z f d} -opt] == x
```

@return The next  

**Parameters:**

  * **l**: The list
  * **query**: Query to search
  * **args**: Arguments -all or/and -size

---

## <a name="::tools::lists::lists"></a>Scope: `::tools::lists` | proc: **lists**

```tcl
proc lists {cmd args}
```

# Function that handle all commands of lists file  


**Parameters:**

  * **cmd**: Command
  * **d**: The dict
  * **args**: The command arguments

---

## <a name="::tools::dicts::dictget"></a>Scope: `::tools::dicts` | proc: **dictget** `[alias exported]`

```tcl
proc dictget {d args}
```

Get value from dict. Last 'key' is the default value  

@patam Args keys to get  
@return Value or default value  

**Parameters:**

  * **d**: The dict

---

## <a name="::tools::dicts::dictmap"></a>Scope: `::tools::dicts` | proc: **dictmap** `[alias exported]`

```tcl
proc dictmap {d key lambda}
```

Map value of dict by key.  

```tcl
map [dict key value] key {{v} {set v}}
```


@patam Dict key  
@return Lambda to apply  

**Parameters:**

  * **d**: The dict

---

## <a name="::tools::dicts::dictkeyslist"></a>Scope: `::tools::dicts` | proc: **dictkeyslist** `[alias exported]`

```tcl
proc dictkeyslist {d args}
```

Get list of values by keys  


**Parameters:**

  * **d**: The dict
  * **args**: List of keys to get

---

## <a name="::tools::dicts::dictupdate"></a>Scope: `::tools::dicts` | proc: **dictupdate** `[alias exported]`

```tcl
proc dictupdate {var key lambda}
```

Update value by lambda result  

```tcl
update [dict key value] key {{v} {return other}}
```



**Parameters:**

  * **var**: The dict
  * **key**: The dict key
  * **lambda**: The lambda

---

## <a name="::tools::dicts::dicts"></a>Scope: `::tools::dicts` | proc: **dicts**

```tcl
proc dicts {cmd d args}
```

Function that handle all commands of dicts file  


**Parameters:**

  * **cmd**: Command
  * **d**: The dict
  * **args**: The command arguments

---

