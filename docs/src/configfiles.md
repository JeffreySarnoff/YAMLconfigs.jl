# Configuration Files Guide

This document describes the example IEEE SA P3109 configuration files in the `ConfigFiles/` directory.

## File Registry

The `src/ConfigFiles.yaml` file maps logical names to file paths:

```yaml
StandardOperations: "../ConfigFiles/StandardOperations.yaml"
Configurations: "../ConfigFiles/Configurations.yaml"
Profiles: "../ConfigFiles/Profiles.yaml"
Constraints: "../ConfigFiles/Constraints.yaml"
Kappas: "../ConfigFiles/Kappas.yaml"
```

## Common Structure

All P3109 config files share a `Metadata` section:

```yaml
Metadata:
  conformance: "IEEE SA P3109"
  version: "3.2.0"
  provider: "Provider"
  contact:
    email: 'info@implementer.site'
    uri: https://implementer.site
  implementation:
    name: "release name"
    version: '1.0.0'
    date: 2026-01-11
```

Configuration sections are typically divided by target architecture:
- `Core32` - 32-bit implementations
- `Core64` - 64-bit implementations

## File Descriptions

### StandardOperations.yaml

Defines the P3109 operation taxonomy:

| Category | Purpose | Example Operations |
|----------|---------|-------------------|
| `Classification` | Value predicates | `IsZero`, `IsNan`, `IsFinite` |
| `Comparison` | Relational operations | `CompareLess`, `TotalOrder` |
| `Extrema` | Min/max operations | `Minimum`, `MaximumMagnitude` |
| `Projection` | Rounding/saturation | `NearestTiesToEven`, `SatFinite` |
| `Math` | Arithmetic & transcendental | `Add`, `FMA`, `Exp`, `Sin` |
| `Block` | SIMD vector operations | `BlockAdd`, `BlockDotProduct` |
| `Conversion` | Format conversion | `Convert`, `ConvertToIEEE754` |
| `Format` | Format property queries | `BitwidthOf`, `PrecisionOf` |

### Configurations.yaml

Defines supported operation configurations with format constraints:

```yaml
Core32:
  - 'Add{fx, fy, fr}':
    - "(fx == fy && fy == fr)"
  - 'Multiply{fx, fy, fr}':
    - "(fx == fy)"
    - "(BitwidthOf(fr) >= BitwidthOf(fx))"
```

### Constraints.yaml

Mathematical constraints for each operation, separate from configurations:

```yaml
Core32:
  - 'Add{fx, fy, fr}': ["(fx == fy && fy == fr)"]
  - 'SqrtFast{fx, fr, ρ}':
    - "(fx in {Binary8p3se})"
    - "(fr in {Binary8p3se, Binary8p4se})"
```

### Profiles.yaml

Defines conformance profiles specifying supported format sets:

```yaml
Core32:
  - formats: ["Binary8p3se", "Binary8p4se"]

Core64:
  - formats: "( [[Binary4p{i}sf for i=1..3], [Binary8p{i}se for i=2..3] )"
```

### Kappas.yaml

Approximation error bounds for "fast" (approximate) functions:

```yaml
SqrtFast:
  Approximates: "Sqrt"
  Kappa:
    - intervals: "([-Inf, Inf])"
      kappa: 1
  Projections:
    RoundingModes: ["NearestTiesToAway", "AllDirected"]
    SaturationModes: "All"
```

## Usage Examples

### Loading and Inspecting

```julia
using YAMLconfigs

# Load operations taxonomy
ops = load_yaml_config("ConfigFiles/StandardOperations.yaml")

# Get all math arithmetic operations
math_ops = ops["Math"]["arithmetic"]
# => ["Recip", "Sqrt", "Rsqrt", "Add", "Subtract", "Multiply", ...]

# Get all classification predicates
predicates = ops["Classification"]["predicates"]
# => ["IsZero", "IsOne", "IsNan", "IsSignMinus", ...]
```

### Processing All ConfigFiles

```julia
# Load all P3109 configs
configs = load_yaml_configs("ConfigFiles/")
println("Loaded $(length(configs)) configuration files")

# Extract all versions
versions = process_yaml_configs("ConfigFiles/") do config
    get(get(config, "Metadata", Dict()), "version", "unknown")
end
# => ["3.2.0", "3.2.0", "3.2.0", "3.2.0", "3.2.0"]
```

### Checking Kappa Values

```julia
kappas = load_yaml_config("ConfigFiles/Kappas.yaml")

# Check SqrtFast error bound
sqrt_kappa = kappas["SqrtFast"]["Kappa"][1]["kappa"]
# => 1 (at most 1 ULP error)

# Get verification method
verification = kappas["SinFast"]["Verification"]["method"]
# => "formal proof"
```
