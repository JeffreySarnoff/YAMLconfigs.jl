# YAMLconfigs.jl

A Julia package for processing YAML configuration files. This package provides simple and efficient tools for loading, parsing, and processing YAML configuration files, whether you're working with a single file or thousands of configuration files.

## Features

- Load single or multiple YAML configuration files
- Process entire directories of YAML files
- Apply custom processing functions to configurations
- Robust error handling for missing files
- Support for both `.yaml` and `.yml` file extensions

## Installation

```julia
using Pkg
Pkg.add("YAMLconfigs")
```

## Usage

### Loading a Single Configuration File

```julia
using YAMLconfigs

# Load a single YAML configuration file
config = load_yaml_config("config.yaml")
```

### Loading Multiple Configuration Files

```julia
# Load multiple specific files
configs = load_yaml_configs(["config1.yaml", "config2.yaml", "config3.yaml"])

# Load all YAML files from a directory
configs = load_yaml_configs("configs/")
```

### Processing Configuration Files

You can apply custom processing functions to your configurations:

```julia
# Process configs with a custom function
processed = process_yaml_configs("configs/") do config
    # Your custom processing logic here
    config["processed"] = true
    config["timestamp"] = now()
    return config
end

# Process specific files with a transformation
values = process_yaml_configs(["config1.yaml", "config2.yaml"]) do config
    return config["value"] * 2
end
```

### Working with Large Numbers of Configuration Files

This package is designed to efficiently handle large numbers of configuration files. For example, processing 3109 YAML files:

```julia
# Process all YAML files in a directory tree
configs = load_yaml_configs("large_config_directory/")
println("Loaded $(length(configs)) configuration files")

# Apply transformations to all configs
processed = process_yaml_configs("large_config_directory/") do config
    # Extract specific fields
    return Dict(
        "id" => config["id"],
        "name" => config["name"],
        "enabled" => get(config, "enabled", false)
    )
end
```

## API Reference

### `load_yaml_config(filepath::AbstractString)`

Load a single YAML configuration file.

**Arguments:**
- `filepath`: Path to the YAML file

**Returns:** Dictionary containing the parsed YAML configuration

### `load_yaml_configs(filepaths::Vector{<:AbstractString})`

Load multiple YAML configuration files from a list of file paths.

**Arguments:**
- `filepaths`: Vector of file paths

**Returns:** Vector of dictionaries containing the parsed configurations

### `load_yaml_configs(directory::AbstractString; pattern::Regex=r"\.ya?ml$"i)`

Load all YAML files from a directory matching the given pattern.

**Arguments:**
- `directory`: Path to the directory
- `pattern`: Regular expression pattern to match files (default: matches `.yaml` and `.yml`)

**Returns:** Vector of dictionaries containing the parsed configurations

### `process_yaml_configs(processor::Function, filepaths_or_directory)`

Process YAML configuration files with a custom function.

**Arguments:**
- `processor`: Function to apply to each configuration
- `filepaths_or_directory`: Either a vector of file paths or a directory path

**Returns:** Vector of processed configurations

## Error Handling

The package includes robust error handling:

```julia
# Non-existent files will throw an error
try
    config = load_yaml_config("nonexistent.yaml")
catch e
    println("Error: $e")
end

# When loading multiple files, errors are logged as warnings
# and the package continues processing other files
configs = load_yaml_configs(["good.yaml", "bad.yaml", "another_good.yaml"])
```

## Requirements

- Julia 1.6 or higher
- YAML.jl package (automatically installed)

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
