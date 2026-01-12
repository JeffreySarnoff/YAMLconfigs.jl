# YAMLconfigs.jl - Copilot Instructions

## Project Overview

Julia package for loading, parsing, and batch-processing YAML configuration files. Designed for IEEE SA P3109 floating-point conformance specifications but generalizable to any YAML workflow.

## Architecture

```
src/YAMLconfigs.jl    # Single module with 3 exported functions
ConfigFiles/          # Example P3109 YAML configs (Configurations, Constraints, Kappas, Profiles, StandardOperations)
src/ConfigFiles.yaml  # Registry mapping config names to relative file paths
```

**Core API pattern**: All functions return `Dict` or `Vector{Any}` from parsed YAML.

| Function | Input | Output |
|----------|-------|--------|
| `load_yaml_config(filepath)` | Single file path | `Dict` |
| `load_yaml_configs(paths_or_dir)` | Vector of paths OR directory | `Vector{Any}` |
| `process_yaml_configs(fn, input)` | Processor function + paths/dir | `Vector` of transformed results |

## Development Commands

```julia
# Run tests
using Pkg; Pkg.test()

# Use package locally
using Pkg; Pkg.activate("."); using YAMLconfigs

# Build documentation
cd("docs"); Pkg.activate("."); Pkg.instantiate(); include("make.jl")
```

## Code Conventions

### Julia Style
- Use `AbstractString` for string type hints (not `String`)
- Prefer `do`-block syntax for processor callbacks:
  ```julia
  process_yaml_configs("configs/") do config
      config["processed"] = true
      return config
  end
  ```
- Use `@warn` for recoverable errors in batch operations, `error()` for fatal ones

### Error Handling Pattern
- Single file operations: throw `ErrorException` immediately
- Batch operations: log warning with `@warn`, continue processing remaining files

### File Pattern Matching
Default regex for YAML files: `r"\.ya?ml$"i` (case-insensitive, matches `.yaml` and `.yml`)

## IEEE SA P3109 Domain Context

This package was designed for **IEEE SA P3109** - a standard for low-precision floating-point formats used in machine learning and AI workloads. See [docs/P3109-CONCEPTS.md](docs/P3109-CONCEPTS.md) for detailed specification coverage.

### Key Concepts
- **Binary formats**: Named as `Binary{bits}p{precision}{signedness}{exponent}` (e.g., `Binary8p3se` = 8-bit, 3-bit precision, signed, with exponent)
- **Kappa (κ) values**: Approximation error bounds measured in ULPs (Units in Last Place)
- **Projection modes**: Rounding (`NearestTiesToEven`, `TowardZero`, `StochasticA/B/C`) and saturation (`OvfInf`, `SatFinite`)

### ConfigFiles Structure

Each YAML in `ConfigFiles/` follows this pattern:
```yaml
Metadata:
  conformance: "IEEE SA P3109"
  version: "3.2.0"
  # ... provider info, URIs

Core32:   # 32-bit format configurations
Core64:   # 64-bit format configurations
```

Key files:
- [Configurations.yaml](ConfigFiles/Configurations.yaml) - Format configurations with operation constraints
- [Constraints.yaml](ConfigFiles/Constraints.yaml) - Mathematical constraints per operation
- [Kappas.yaml](ConfigFiles/Kappas.yaml) - Approximation error bounds (κ values)
- [Profiles.yaml](ConfigFiles/Profiles.yaml) - Supported binary format profiles
- [StandardOperations.yaml](ConfigFiles/StandardOperations.yaml) - Operation categories (Classification, Comparison, Math, etc.)

See [docs/src/](docs/src/) for comprehensive Documenter.jl documentation.

## Testing

Tests use `mktempdir()` for isolated YAML fixtures. Pattern in [test/runtests.jl](test/runtests.jl):
```julia
temp_dir = mktempdir()
write(joinpath(temp_dir, "config.yaml"), "key: value")
# ... run tests ...
rm(temp_dir, recursive=true)
```

## Dependencies

- **YAML.jl** (v0.4) - Core parsing via `YAML.load_file()`
- **Julia 1.12+** required

## When Modifying

1. Export new functions in the `module YAMLconfigs` block
2. Add docstrings with `# Arguments`, `# Returns`, `# Example` sections
3. Add corresponding tests in `test/runtests.jl` using the temp directory pattern
