\subsection{YAML Configuration Files Additional Syntax}

All YAML 1.2.2 constructs are supported. Below are the specific structures used in configuration files for defining operation constraints, profiles, and approximation parameters.

\subsubsection{Intervals}
Intervals are given as single-quoted strings where square brackets are used for closed intervals and parentheses for open intervals. For example:

```yaml
closed_interval: '[0, 1]'  # Closed interval from 0 to 1
open_interval:   '(0, 1)'  # Open interval from negative to positive infinity
clopen_interval: '[0, 1)'  # Closed on left, open on right
```

When an interval is used as an expression, the expression delimiters are wrapped.

```yaml
closed_interval: "( '[0, 1]' )"  # Closed interval from 0 to 1
open_interval:   "( '(0, 1)' )"  # Open interval 
clopen_interval: "( '[0, 1)' )"  # Closed on left, open on right
```

Multiple, disjoint intervals may be given as an expression list:

```yaml
"([ '[-Inf, -π)', '(π, Inf]' ])"
```
