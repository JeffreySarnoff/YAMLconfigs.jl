# YAML Configuration Files - Error Report

**Analysis Date:** January 19, 2026  
**Files Analyzed:** Configurations.yaml, Profiles.yaml, Constraints.yaml, Kappas.yaml, StandardOperations.yaml  
**Reference:** ConfigSyntax.md

---

## Summary

This report identifies syntax errors and inconsistencies in the YAML configuration files based on the rules defined in ConfigSyntax.md.

---

## 1. Configurations.yaml

### Error 1.1: Duplicate Key (Line ~25-28)
**Severity:** Critical  
**Location:** Core64 section

```yaml
# INCORRECT:
- IEEE754_format: ["binary32", "binary64"]
- IEEE754_format:
  - "binary32"
  - "binary64"
```

**Issue:** The `IEEE754_format` key appears twice under `CoreOperations`, which violates YAML uniqueness rules.

**Correction:** Remove duplicate, use one format:
```yaml
- IEEE754_format: ["binary32", "binary64"]
```

---

### Error 1.2: Improper Indentation (Line ~29)
**Severity:** Critical  
**Location:** Core64 section

```yaml
# INCORRECT:
- IEEE754_format:
    - "binary32"
    - "binary64" 
  BlockSizes (B):    # Wrong indentation level
```

**Issue:** `BlockSizes (B):` should be at the same indentation level as `CoreOperations` or be a separate list item under Core64.

**Correction:**
```yaml
Core64:
  - CoreOperations:
      - IEEE754_format: ["binary32", "binary64"]
  - BlockSizes (B):
      - core:
          - elements: [16, 32]
```

---

### Error 1.3: Inconsistent Iterator Syntax (Line ~33)
**Severity:** Minor  
**Location:** Core64 > BlockSizes > supported

```yaml
# CURRENT:
- elements: "( 2^i for i=4..24 )"
```

**Issue:** The iterator uses `i=4..24` instead of the documented `i in [4..24]` format.

**Correction:**
```yaml
- elements: "( 2^i for i in [4..24] )"
```

---

### Error 1.4: Missing List Item Marker
**Severity:** Critical  
**Location:** Core32 section (Line ~18)

```yaml
# INCORRECT:
- CoreOperations:
    ...
- BlockSizes (B):    # Should be properly aligned
```

**Issue:** Inconsistent structure - unclear if BlockSizes should be a sibling or under CoreOperations.

**Correction:** Clarify structure:
```yaml
Core32:
  - CoreOperations:
      - IEEE754_format: ["binary32"]
      - Projection:
          - Rounding:
              - NearestTiesToEven
              - StochasticB:
                  - bits: "( Minimum(Precision(FMT), 16) )"
          - Saturation:
              - SatPropagate
  - BlockSizes (B):
      - core:
          - elements: 32
```

---

## 2. Profiles.yaml

### Error 2.1: Mismatched Brackets (Line ~22)
**Severity:** Critical  
**Location:** Core64 > formats

```yaml
# INCORRECT:
- formats: ["( Binary4p$(i)sf for i in [1..2] )", "( Binary8p$(i)se for i in [3..4])] )"]
```

**Issue:** Extra `]` and `)` at the end. The second string has `])]` which creates mismatched brackets.

**Correction:**
```yaml
- formats: ["( Binary4p$(i)sf for i in [1..2] )", "( Binary8p$(i)se for i in [3..4] )"]
```

---

## 3. Constraints.yaml

### Error 3.1: Missing Closing Quote (Line ~28)
**Severity:** Critical  
**Location:** Core64 > Add constraints

```yaml
# INCORRECT:
- "( fx == fy)
```

**Issue:** Missing closing double quote.

**Correction:**
```yaml
- "( fx == fy )"
```

---

### Error 3.2: Character Encoding Issue (Multiple lines)
**Severity:** High  
**Location:** Throughout file (φ symbol)

```yaml
# INCORRECT:
- Add(fx, fy, fr, Ï):
```

**Issue:** The Greek letter phi (φ) is appearing as `Ï` due to character encoding issues. This affects:
- Line ~23: `Add(fx, fy, fr, Ï):`
- Line ~30: `Add(fx, fy, fr, Ï):`
- Line ~34: `FMA(fx, fy, fz, fr, Ï):`
- Lines with phi in projection tuples

**Correction:**
```yaml
- Add(fx, fy, fr, φ):
# OR use ASCII representation:
- Add(fx, fy, fr, phi):
```

---

### Error 3.3: Undefined Tuple Syntax (Lines ~25-26, ~31-32, ~39-40)
**Severity:** High  
**Location:** Projection tuples

```yaml
# CURRENT:
- "( ToNearestTiesToEven, OvfInf  )"
```

**Issue:** The `( ... )` syntax is not defined in ConfigSyntax.md. Based on the syntax document:
- Tuples should be: `"( item1, item2 )"`
- This appears to be attempting to define a projection tuple

**Correction:** Use standard tuple syntax:
```yaml
Ï:
  - "( ToNearestTiesToEven, OvfInf )"
  - "( ToNearestTiesToEven, SatFinite )"
```

---

## 4. Kappas.yaml

### Error 4.1: Character Encoding Issue - Pi (Multiple lines)
**Severity:** High  
**Location:** Throughout file

```yaml
# INCORRECT:
- interval: "( [>=(-Ï€), <(Ï€)] )"
```

**Issue:** The Greek letter π is appearing as `Ï€` due to character encoding issues. Affects multiple lines in interval definitions.

**Correction:**
```yaml
- interval: "( [>=(-π), <(π)] )"
# OR use the symbolic name:
- interval: "( [>=(-Pi), <(Pi)] )"
```

---

### Error 4.2: Invalid List Structure (Line ~31)
**Severity:** Critical  
**Location:** SinFast > Projections > RoundingModes

```yaml
# INCORRECT:
["NearestTiesToEven", "TowardZero", ["StochasticA": "( Bits = 16 )"]]
```

**Issue:** A list item contains a single-element list with a mapping. This creates nested lists incorrectly. The syntax mixes list and mapping notations improperly.

**Correction:** Use proper YAML structure:
```yaml
RoundingModes:
  - "NearestTiesToEven"
  - "TowardZero"
  - StochasticA:
      bits: "( 16 )"
```

---

### Error 4.3: Undefined Curly Brace Syntax (Lines ~60, ~63, ~77, ~80)
**Severity:** High  
**Location:** ExpFast approximation definitions

```yaml
# INCORRECT:
- "Round{Ï} in {ToOdd, StochasticA}"
- "( Round(Ï) in {ToOdd, StochasticA} )"
```

**Issue:** Curly braces `{}` are not defined in ConfigSyntax.md. It's unclear if this represents:
- A set notation
- A parameter extraction
- A constraint expression

**Correction:** Clarify intent. If this means "Round mode from phi is in the set", use expression syntax:
```yaml
With:
  - "( Round(φ) in [ToOdd, StochasticA] )"
  - "( Sat(φ) in [SatPropagate] )"
```

---

### Error 4.4: Character Encoding Issue - Phi (Multiple lines)
**Severity:** High  
**Location:** ExpFast approximation sections

```yaml
# INCORRECT:
- Approximates: "Exp{Binary8p3se, Binary8p3se, Ï}"
```

**Issue:** Same φ encoding issue as in Constraints.yaml.

**Correction:**
```yaml
- Approximates: "Exp{Binary8p3se, Binary8p3se, φ}"
# OR:
- Approximates: "Exp{Binary8p3se, Binary8p3se, phi}"
```

---

### Error 4.5: Inconsistent Curly Brace Usage (Line ~59)
**Severity:** Medium  
**Location:** ExpFast > first approximation

```yaml
# CURRENT:
Approximates: "Exp{Binary8p3se, Binary8p3se, Ï}"
```

**Issue:** Uses curly braces `{}` which are not defined in ConfigSyntax.md for parameter lists. Should these be parentheses for tuples?

**Correction:** If representing function signature, use tuples or clarify notation:
```yaml
Approximates: "Exp( Binary8p3se, Binary8p3se, φ )"
```

---

## 5. StandardOperations.yaml

### No Errors Found

The StandardOperations.yaml file appears to conform to standard YAML 1.2.2 syntax and does not use the extended syntax features defined in ConfigSyntax.md, so no errors were detected.

---

## 6. General Recommendations

### 6.1 Character Encoding
**Issue:** Multiple files contain character encoding issues with Greek letters (π, φ).

**Recommendation:**
- Ensure all YAML files are saved with UTF-8 encoding
- Or use ASCII-safe symbolic names: `Pi`, `phi`, `Phi`

### 6.2 Syntax Documentation Gaps
The following constructs appear in the YAML files but are not documented in ConfigSyntax.md:

1. **Pipe notation:** `( item1, item2 )` - Appears to be a special tuple format
2. **Curly braces:** `{item1, item2}` - Appears to be set notation or parameter grouping
3. **Curly brace extraction:** `Round{φ}`, `Sat{φ}` - Appears to be component extraction

**Recommendation:** Update ConfigSyntax.md to document these constructs or revise YAML files to use documented syntax.

### 6.3 Iterator Consistency
**Issue:** Iterator syntax varies between `for i=range` and `for i in range`.

**Recommendation:** Standardize on `for i in [range]` as documented in ConfigSyntax.md.

---

## Correction Priority

### Critical (Must Fix)
1. Configurations.yaml: Duplicate `IEEE754_format` key
2. Configurations.yaml: Improper indentation of `BlockSizes`
3. Profiles.yaml: Mismatched brackets in formats list
4. Constraints.yaml: Missing closing quote in expression
5. Kappas.yaml: Invalid nested list structure in RoundingModes

### High (Should Fix)
1. All files: Character encoding issues (Ï€ → π, Ï → φ)
2. Constraints.yaml: Undefined `( ... )` tuple syntax
3. Kappas.yaml: Undefined curly brace syntax `{...}`

### Medium (Consider Fixing)
1. Configurations.yaml: Iterator syntax consistency
2. Documentation gap for undocumented syntax constructs

---

## Summary Statistics

- **Total Files Analyzed:** 5
- **Files with Errors:** 4
- **Total Errors Found:** 17
- **Critical Errors:** 5
- **High Priority Errors:** 6
- **Medium Priority Errors:** 3
- **Minor Errors:** 3

---

*End of Report*
