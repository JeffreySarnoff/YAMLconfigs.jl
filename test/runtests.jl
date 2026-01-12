using YAMLconfigs
using Test

@testset "YAMLconfigs.jl" begin
    # Create a temporary directory for test files
    temp_dir = mktempdir()
    
    # Create test YAML files
    test_yaml1 = joinpath(temp_dir, "config1.yaml")
    test_yaml2 = joinpath(temp_dir, "config2.yaml")
    test_yaml3 = joinpath(temp_dir, "config3.yml")
    
    write(test_yaml1, """
    name: config1
    value: 100
    enabled: true
    """)
    
    write(test_yaml2, """
    name: config2
    value: 200
    enabled: false
    """)
    
    write(test_yaml3, """
    name: config3
    value: 300
    items:
      - item1
      - item2
    """)
    
    @testset "load_yaml_config" begin
        config = load_yaml_config(test_yaml1)
        @test config isa Dict
        @test config["name"] == "config1"
        @test config["value"] == 100
        @test config["enabled"] == true
    end
    
    @testset "load_yaml_configs with file paths" begin
        configs = load_yaml_configs([test_yaml1, test_yaml2, test_yaml3])
        @test length(configs) == 3
        @test configs[1]["name"] == "config1"
        @test configs[2]["name"] == "config2"
        @test configs[3]["name"] == "config3"
    end
    
    @testset "load_yaml_configs with directory" begin
        configs = load_yaml_configs(temp_dir)
        @test length(configs) == 3
        
        # Check that all configs were loaded
        names = [config["name"] for config in configs]
        @test "config1" in names
        @test "config2" in names
        @test "config3" in names
    end
    
    @testset "process_yaml_configs" begin
        # Test with directory
        processed = process_yaml_configs(temp_dir) do config
            config["processed"] = true
            return config
        end
        @test length(processed) == 3
        @test all(config["processed"] == true for config in processed)
        
        # Test with file paths
        processed2 = process_yaml_configs([test_yaml1, test_yaml2]) do config
            config["value"] * 2
        end
        @test length(processed2) == 2
        @test 200 in processed2
        @test 400 in processed2
    end
    
    @testset "Error handling" begin
        # Test non-existent file
        @test_throws ErrorException load_yaml_config("nonexistent.yaml")
        
        # Test non-existent directory
        @test_throws ErrorException load_yaml_configs("nonexistent_dir/")
    end
    
    # Clean up
    rm(temp_dir, recursive=true)
end
