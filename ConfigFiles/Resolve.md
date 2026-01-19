1. match formats to supported configurations
    1. read Profiles.yaml
    2. for each profile P in Profiles.yaml
        1. get F = P["formats"]
            1. is F is a list
                (no) error "Profile $P formats is not a list"
            2. resolve F into Formats, a list of "BinaryKpPσδ"s
            3. pair P with Formats
    3. * --> Format["Core32"] = ["Binary8p3se", "Binary8p4se"]
       * --> Format["Core64"] = ["Binary4p1sf", "Binary4p2sf", "Binary8p3se", "Binary8p4se]

2. initialize each Profile (result of 1) with list of all standard operations
    1. for each Configuration in Format
        1. get Ops = StandardOperations()
        2. pair F with Ops
             * --> Operations["Core32"] = [Add(fx,fy,fr,ρ), ..., Sqrt(fx,fr,ρ), ..., SinPi(fx,fr,ρ), ...]
             * --> Operations["Core64"] = [Add,..., Sqrt, ..., SinPi, ...]
    2. for each Configuration Conf in Constraints.yaml
        1. resolve constraints for Conf over formats in Operations[Conf]


        2. for each configuration for each constraint C in Constraints.yaml
            1. get C = Constraints[F]
            2. for each operation O in Ops
                1. if O in C
                        (a) apply constraints C[O] to O
                    else
                        (a) keep O as is


