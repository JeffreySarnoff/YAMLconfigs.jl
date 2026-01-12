# YAMLconfigs.jl

A Julia package for loading, parsing, and batch-processing YAML configuration files.

## Features

- Load single or multiple YAML configuration files
- Process entire directories of YAML files recursively
- Apply custom processing functions to configurations
- Robust error handling for batch operations
- Support for both `.yaml` and `.yml` file extensions

## Installation

```julia
using Pkg
Pkg.add("YAMLconfigs")
```

## Quick Start

```julia
using YAMLconfigs

# Load a single config
config = load_yaml_config("config.yaml")

# Load all configs from a directory
configs = load_yaml_configs("configs/")

# Process configs with custom logic
results = process_yaml_configs("configs/") do config
    config["processed"] = true
    return config
end
```

## Package Overview

YAMLconfigs.jl exports three functions:

| Function | Purpose |
|----------|---------|
| [`load_yaml_config`](@ref) | Load a single YAML file |
| [`load_yaml_configs`](@ref) | Load multiple YAML files (paths or directory) |
| [`process_yaml_configs`](@ref) | Apply transformations to loaded configs |

## Contents

```@contents
Pages = ["api.md", "p3109.md", "configfiles.md", "contributing.md"]
Depth = 2
```

## Index

```@index
```
