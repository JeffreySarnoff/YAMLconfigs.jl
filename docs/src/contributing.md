# Contributing

Thank you for your interest in contributing to YAMLconfigs.jl!

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/YAMLconfigs.jl.git
   cd YAMLconfigs.jl
   ```

2. Start Julia and activate the project:
   ```julia
   using Pkg
   Pkg.activate(".")
   Pkg.instantiate()
   ```

3. Run tests to verify setup:
   ```julia
   Pkg.test()
   ```

## Project Structure

```
YAMLconfigs.jl/
├── src/
│   ├── YAMLconfigs.jl    # Main module (all exported functions)
│   └── ConfigFiles.yaml  # Registry of example config file paths
├── ConfigFiles/          # Example P3109 YAML configurations
├── test/
│   └── runtests.jl       # Test suite
├── docs/
│   ├── make.jl           # Documenter.jl build script
│   ├── Project.toml      # Docs dependencies
│   └── src/              # Documentation source files
├── Project.toml          # Package dependencies
└── README.md
```

## Building Documentation

```julia
cd("docs")
using Pkg
Pkg.activate(".")
Pkg.instantiate()

include("make.jl")
```

The built documentation will be in `docs/build/`.

## Code Conventions

### Julia Style

- **Type hints**: Use `AbstractString` not `String` for string parameters
- **Callbacks**: Prefer `do`-block syntax in examples

### Error Handling

| Context | Approach |
|---------|----------|
| Single file operations | Throw `ErrorException` immediately |
| Batch operations | Log `@warn`, continue processing |

### Documentation

All exported functions require docstrings with:

```julia
"""
    my_function(arg1::Type1, arg2::Type2)

Brief description of what the function does.

# Arguments
- `arg1::Type1`: Description of arg1
- `arg2::Type2`: Description of arg2

# Returns
- Description of return value

# Example
```julia
result = my_function(value1, value2)
```
"""
function my_function(arg1::Type1, arg2::Type2)
    ...
end
```

## Testing

Tests use temporary directories for isolation:

```julia
@testset "My Feature" begin
    temp_dir = mktempdir()
    
    # Create test fixtures
    write(joinpath(temp_dir, "test.yaml"), """
    key: value
    nested:
      item: 42
    """)
    
    # Run tests
    result = load_yaml_config(joinpath(temp_dir, "test.yaml"))
    @test result["key"] == "value"
    
    # Cleanup
    rm(temp_dir, recursive=true)
end
```

### Running Tests

```julia
using Pkg; Pkg.test()
```

## Adding New Functionality

1. **Add function** to `src/YAMLconfigs.jl`
2. **Export** in the module block: `export new_function`
3. **Add docstring** following the template above
4. **Add tests** in `test/runtests.jl`
5. **Add to docs** - reference with `@docs` block in `docs/src/api.md`

## Pull Request Guidelines

- Include tests for new functionality
- Update documentation as needed
- Follow existing code style
- Keep commits focused and atomic
