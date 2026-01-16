(1): match formats to supported configurations
    (a) read Profiles.yaml
    (b) for each profile P in Profiles.yaml
        (i) get F = P["formats"]
            (a) is F is a list
                (no) error "Profile $P formats is not a list"
            (b) resolve F into Formats, a list of "BinaryKpPσδ"s
            (c) pair P with Formats
    --> Format["Core32"] = ["Binary8p3se", "Binary8p4se"]
    --> Format["Core64"] = ["Binary4p1sf", "Binary4p2sf", "Binary8p3se", "Binary8p4se]

(2): initialize each Profile (result of 1) with list of all standard operations
    (a) for each Configuration in Format
        (i) get Ops = StandardOperations()
        (ii) pair F with Ops
             --> Operations["Core32"] = [Add(fx,fy,fr,ρ), ..., Sqrt(fx,fr,ρ), ..., SinPi(fx,fr,ρ), ...]
             --> Operations["Core64"] = [Add,..., Sqrt, ..., SinPi, ...]
     (b) for each Configuration Conf in Constraints.yaml
            (a) resolve constraints for Conf over formats in Operations[Conf]

        (ii) for each configuration for each constraint C in Constraints.yaml
            (a) get C = Constraints[F]
            (b) for each operation O in Ops
                (i) if O in C
                    (a) apply constraints C[O] to O
                (ii) else
                    (a) keep O as is


