module YAMLconfigs

using YAML, PythonCall

export yaml_read, load_yaml_config, load_yaml_configs, process_yaml_configs

function yaml_read(filepath::AbstractString; reader=YAML.load_file)
    if !isfile(filepath)
        throw(FileNotFoundError(filepath))
    end
    try
        return reader(filepath)
    catch e
        throw(ParseError(filepath, e.msg))
    end
end

function pyyaml_read(filepath::AbstractString; reader=YAML.load_file)
    if !isfile(filepath)
        throw(FileNotFoundError(filepath))
    end
    # from ruamel.yaml import YAML
    pyimport("ruamel")
    try
        return reader(filepath)
    catch e
        throw(ParseError(filepath, e.msg))
    end
end

julia> re = pyimport("re")
Python: <module 're' from '[...]/lib/re.py'>

julia> words = re.findall("[a-zA-Z]+", "PythonCall.jl is very useful!")
Python: ['PythonCall', 'jl', 'is', 'very', 'useful']

julia> sentence = Py(" ").join(words)
Python: 'PythonCall jl is very useful'

julia> pyconvert(String, sentence)
"PythonCall jl is very useful"
"""
    load_yaml_config(filepath::AbstractString)

Load a single YAML configuration file and return its contents as a dictionary.

# Arguments
- `filepath::AbstractString`: Path to the YAML configuration file

# Returns
- Dictionary containing the parsed YAML configuration

# Example
```julia
config = load_yaml_config("config.yaml")
```
"""
function load_yaml_config(filepath::AbstractString)
    if !isfile(filepath)
        error("File not found: $filepath")
    end
    return YAML.load_file(filepath)
end

"""
    load_yaml_configs(filepaths::Vector{<:AbstractString})

Load multiple YAML configuration files and return their contents as a vector of dictionaries.

# Arguments
- `filepaths::Vector{<:AbstractString}`: Vector of paths to YAML configuration files

# Returns
- Vector of dictionaries containing the parsed YAML configurations

# Example
```julia
configs = load_yaml_configs(["config1.yaml", "config2.yaml"])
```
"""
function load_yaml_configs(filepaths::Vector{<:AbstractString})
    configs = Vector{Any}()
    for filepath in filepaths
        try
            config = load_yaml_config(filepath)
            push!(configs, config)
        catch e
            @warn "Failed to load $filepath: $e"
        end
    end
    return configs
end

"""
    load_yaml_configs(directory::AbstractString; pattern::Regex=r"\\.ya?ml\$"i)

Load all YAML configuration files from a directory matching the given pattern.

# Arguments
- `directory::AbstractString`: Path to the directory containing YAML files
- `pattern::Regex`: Regular expression pattern to match YAML files (default: matches .yaml and .yml files)

# Returns
- Vector of dictionaries containing the parsed YAML configurations

# Example
```julia
configs = load_yaml_configs("configs/")
```
"""
function load_yaml_configs(directory::AbstractString; pattern::Regex=r"\.ya?ml$"i)
    if !isdir(directory)
        error("Directory not found: $directory")
    end
    
    yaml_files = String[]
    for (root, dirs, files) in walkdir(directory)
        for file in files
            if occursin(pattern, file)
                push!(yaml_files, joinpath(root, file))
            end
        end
    end
    
    return load_yaml_configs(yaml_files)
end

"""
    process_yaml_configs(processor::Function, filepaths_or_directory)

Process YAML configuration files with a custom processing function.

# Arguments
- `processor::Function`: Function to apply to each loaded configuration
- `filepaths_or_directory`: Either a vector of file paths or a directory path

# Returns
- Vector of processed configurations

# Example
```julia
# Process configs with a custom function using do-block syntax
processed = process_yaml_configs("configs/") do config
    # Custom processing logic
    return config
end
```
"""
function process_yaml_configs(processor::Function, filepaths_or_directory)
    if isa(filepaths_or_directory, AbstractString) && isdir(filepaths_or_directory)
        configs = load_yaml_configs(filepaths_or_directory)
    elseif isa(filepaths_or_directory, Vector)
        configs = load_yaml_configs(filepaths_or_directory)
    else
        error("Invalid input: must be a directory path or vector of file paths")
    end
    
    return map(processor, configs)
end

end # module
