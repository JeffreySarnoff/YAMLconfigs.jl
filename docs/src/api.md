# API Reference

## Functions

```@docs
load_yaml_config
load_yaml_configs
process_yaml_configs
```

## Type Conventions

| Parameter Type | Description |
|----------------|-------------|
| `AbstractString` | Any string type (allows `SubString`, etc.) |
| `Vector{<:AbstractString}` | Vector of any string types |
| `Function` | Any callable (function, closure, functor) |

## Error Handling

| Function | Missing File | Missing Directory |
|----------|--------------|-------------------|
| `load_yaml_config` | `ErrorException` | N/A |
| `load_yaml_configs` (Vector) | `@warn`, skip file | N/A |
| `load_yaml_configs` (directory) | `@warn`, skip file | `ErrorException` |
| `process_yaml_configs` | (delegates to above) | (delegates to above) |

### Error Handling Philosophy

- **Single file operations**: Fail fast with `ErrorException`
- **Batch operations**: Log warning with `@warn`, continue processing remaining files

This allows batch processing to be resilient while single-file operations provide immediate feedback.

## Usage Examples

### Loading Configurations

```julia
using YAMLconfigs

# Single file
config = load_yaml_config("settings.yaml")
println(config["database"]["host"])

# Multiple specific files
configs = load_yaml_configs([
    "app/config.yaml",
    "app/secrets.yaml",
    "app/overrides.yaml"
])

# All YAML files from directory tree
all_configs = load_yaml_configs("ConfigFiles/")

# Custom file pattern
schemas = load_yaml_configs("schemas/", pattern=r"schema\.yaml$"i)
```

### Processing Configurations

```julia
# Extract specific fields using do-block
summaries = process_yaml_configs("ConfigFiles/") do config
    metadata = get(config, "Metadata", Dict())
    return Dict(
        "version" => get(metadata, "version", "unknown"),
        "conformance" => get(metadata, "conformance", "none")
    )
end

# Using a named function
function extract_operations(config)
    ops = String[]
    for (category, items) in config
        category == "Metadata" && continue
        if items isa Dict
            append!(ops, collect(keys(items)))
        end
    end
    return ops
end

all_operations = process_yaml_configs(extract_operations, "ConfigFiles/")
```
