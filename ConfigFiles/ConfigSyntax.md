## YAML Configuration Files Additional Syntax

All YAML 1.2.2 constructs are supported. Below are the specific structures used in configuration files for defining operation constraints, profiles, and approximation parameters.

### Key-Value Pairs

Key-value pairs are given as standard YAML mappings: `key: <value>`.

### Lists

Lists are given as standard YAML lists: `[ <item1>, <item2>, ... ]`.

### Tuples

A tuple is given as a string bounded by parenthesis wrapped colons:

- `"( <first>, <second>  )"`.
  - In a list of tuples, all tuples must be of the same length.

### Intervals

An interval is given as a string bounded by parenthesis wrapped brackets:

- `"([<lowerbound>, <upperbound>])"`, `"( [<lowerbound>, <upperbound>] )"`.
  - `<lowerbound>`, `<upperbound>` each are `<inequality>(<value>)`
    - `"( [>=(0), <(1)] )"`, `"( [>=(-Sqrt(2)), <=(3/2)] )"`.
  - The brackets distinguish intervals from tuples.
  - The bounds always resolve to a floating-point value in the contextual format.
  - The lowerbound must resolve less than or equal to the upperbound.
- where <inequality> is one of:
    - `>`  : greater than
    - `>=` : greater than or equal to
    - `<`  : less than
    - `<=` : less than or equal to
- and <value> is a numeric or a symbolic value.
  - symbolic values are given as shown in the examples.
    - recognized symbols include [π, e, φ]
      - "( [>=(π/2), <(3/π)] )", "( [2π/Exp(2), φ^(4/3))] )"

### Expressions

An expression is given as a string bounded by parenthesis wrapped parenthesis:

- `"( <expression> )"`
within an expression,
- a list  is given:     `"( [ <item1>, <item2>, ... ] )"`.
- a tuple is given:     `"( ( <first>, <second>, ...  ) )"`.
- an interval is given: `"( ([ <lowerbound>, <upperbound> ]) )"`.

#### Iterators

Within an expression, string interpolating iterators may be used to generate lists.

String interpolation is done with "prefix${i}suffix", where `i` is replaced:
- `"( [ (Binary4p${i}sf for i in [1..3]) ] )" `
  -  `[ Binary4p1sf, Binary4p2sf, Binary4p3sf ]`.

Multiple substitutions may be done within a single item:
- `"( [ (Binary4p${i}s${j} for i in [1..2] for j in ["f", "e"]) ] )"`
  -  `[ Binary4p1sf, Binary4p2sf, Binary4p1se, Binary4p2se ]`.

Two generated lists are concatenated when they are are adjacent within a YAML list:
- `["( [Binary6p{i}sf for i in [1, 3, 4]] )", "( [Binary8p{i}se for i in [2..4]] )"]`
  - `[ Binary6p1sf, Binary6p3sf, Binary6p4sf, Binary8p2se, Binary8p3se, Binary8p4se ]`.

