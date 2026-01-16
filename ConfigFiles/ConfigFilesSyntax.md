## YAML Configuration Files Additional Syntax

All YAML 1.2.2 constructs are supported. Below are the specific structures used in configuration files for defining operation constraints, profiles, and approximation parameters.

### Key-Value Pairs

Key-value pairs are given as standard YAML mappings: `key: <value>`.

### Lists

Lists are given as standard YAML lists: `[ <item1>, <item2>, ... ]`.

### Tuples

A tuple is given as a string bounded by parenthesis wrapped colons: `"(: <first>, <second> :)"`.
- In a list of tuples, all tuples must be of the same length.

### Intervals

An interval is given as a string bounded by parenthesis wrapped bracket: `"([ <lowerbound>, <upperbound> ])"`.
- The brackets distinguish intervals from tuples.


### Expressions

An expression is given as a string bounded by parenthesis wrapped parenthesis: `"(( <expression> ))"`.

Within an expression, a list  is given:     `"(( [ <item1>, <item2>, ... ] ))"`.
Within an expression, a tuple is given:     `"(( (: <first>, <second>, ... :) ))"`.
Within an expression, an interval is given: `"(( ([ <lowerbound>, <upperbound ]) ))"`.

#### Iterators

Within an expression, string interpolating iterators may be used to generate lists.
String interpolation is done with "prefix${i}suffix", where `i` is replaced:
`"(( [ (Binary4p${i}sf for i in [1..3]) ] ))" ` evaluates as
    `[ Binary4p1sf, Binary4p2sf, Binary4p3sf ]`.
Multiple substitutions may be done within a single item:
`"(( [ (Binary4p${i}s${j} for i in [1..2] for j in ["f", "e"]) ] ))" ` evaluates as 
    `[ Binary4p1sf, Binary4p2sf, Binary4p1se, Binary4p2se ]`.
Two generated lists are concatenated when they are collectively wrapped in parenthesis:
   `formats: "(( ([Binary6p{i}sf for i in [1, 3, 4]], [Binary8p{i}se for i in [2..4]]) ))"` evaluates as
   `formats:  [ Binary6p1sf, Binary6p3sf, Binary6p4sf, Binary8p2se, Binary8p3se, Binary8p4se ]`.


```
by iterative string substitution may be used to generate lists.

A few tokens have special meaning within expressions.
- `ALL` - as a value it includes every one of the collection given as the key
  - `SaturationModes: "( ALL )"` evaluates to all defined saturation modes

- `FMT` - refers to the format appropriate to the expression context
  - `RandBits: "( BitwidthOf(FMT) )"` evaluates to bitwidth of the current format
    - Stochastic rounding of a Binary4p2uf value uses 4 random bits.
    - Stochastic rounding of a Binary8p3se value uses 8 random bits.

The standard format querying functions may be used with formats or with FMT
```
  "BitwidthOf", "PrecisionOf", "SignednessOf", "DomainOf"
  "TrailingBitsOf", "ExponentBitsOf", "ExponentBiasOf"
  "MinFiniteOf", "MaxFiniteOf", "MinPositiveOf", "MaxSubnormalOf", "MaxPositiveOf", "MaxNormalOf", "MinNormalOf"
```
The standard value querying functions may be used with values.
```
  "SignificandOf", "NextLessThan", "NextGreaterThan"
```
The standard compare and select functions may be used with values.
```
  "Minimum", "Maximum", "Clamp"
  "MinimumNumber", "MaximumNumber", "MinimumFinite", "MaximumFinite"
  "MinimumMagnitude", "MaximumMagnitude", "MinimumMagnitudeNumber", "MaximumMagnitudeNumber"
```
The standard arithmetic functions may be used with values.
- in expressions, there is one Projection: (NearestTiesToEven, SatPropogate).
```
  "+", "-", "*", "div", "mod",
  "Recip", "Sqrt", "RSqrt", "Exp2", "Log2"
```
### Intervals

Intervals are given with single-quoted strings bounded by brackets: `'[ <lowerbound>, <upperbound> ]'`.
- The single-quote delimiters distinguish intervals from other 2-element lists.

```
closed_interval: '[0, 1]'  # Closed interval from 0 to 1
open_interval:   '(0, 1)'  # Open interval from negative to positive infinity
clopen_interval: '[0, 1)'  # Closed on left, open on right
```

When an interval is used as an expression, the expression delimiters are wrapped.

```
closed_interval: "( '[0, 1]' )"  # Closed interval from 0 to 1
open_interval:   "( '(0, 1)' )"  # Open interval 
clopen_interval: "( '[0, 1)' )"  # Closed on left, open on right
```

Multiple, disjoint intervals may be given as an expression list:

```
"([ '[-Inf, -π)', '(π, Inf]' ])"
```


----