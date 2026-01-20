1. match formats to supported configurations
    1. read Profiles.yaml
    2. for each profile P in Profiles.yaml
        1. get F = P["formats"]
            1. is F is a list
                (no) error "Profile $P formats is not a list"
            2. resolve F into Formats, a list of "BinaryKpPσδ"s
            3. pair P with Formats
    3. * --> Format["Core32"] = ["Binary8p3se", "Binary8p4se"]
       * --> Format["Core64"] = ["Binary4p1sf", "Binary4p2sf", "Binary8p3se", "Binary8p4se"]

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


Format["Core32"] = ["Binary8p3se", "Binary8p4se"]
Format["Core64"] = ["Binary4p1sf", "Binary4p2sf", "Binary8p3se", "Binary8p4se"]

Constraints["Core32"] = [
  [ Add(fx, fy, fr, ρ) = [
      "( fx == fy )",
      "( BitwidthOf(fr) >= BitwidthOf(fx) )",
      "( PrecisionOf(fr) >= PrecisionOf(fx) )" 
      ]
  ],
  [ SqrtFast(fx, fr, ρ) = [
     "( fx in {Binary8p3se} )",
     "( fr in {Binary8p3se, Binary8p4se} )"
     ]
  ]
]

Add(fx, fy, fr, ρ)
    available formats: [Binary8p3se, Binary8p4se]
    constraints:
      - "( BitwidthOf(fr) >= BitwidthOf(fx) )"
        - fr in {Binary8p3se, Binary8p4se}
        - fx in {Binary8p3se, Binary8p4se}
      - PrecisionOf(fr) >= PrecisionOf(fx)"
        - fr in {Binary8p4se}, fx in {Binary8p3se, Binary8p4se}
        - fr in {Binary8p3se}, fx in {Binary8p3se}
      - fx == fy
      > Add(Binary8p3se, Binary8p3se, Binary8p3se, ρ)
      > Add(Binary8p3se, Binary8p3se, Binary8p4se, ρ)
      > Add(Binary8p4se, Binary8p4se, Binary8p4se, ρ)
      - ρ in { (ToNearestTiesToEven, OvfInf), (ToNearestTiesToEven, SatFinite) }
      * Add(Binary8p3se, Binary8p3se, Binary8p3se, (ToNearestTiesToEven, OvfInf))
      * Add(Binary8p3se, Binary8p3se, Binary8p4se, (ToNearestTiesToEven, OvfInf))
      * Add(Binary8p4se, Binary8p4se, Binary8p4se, (ToNearestTiesToEven, OvfInf))
      * Add(Binary8p3se, Binary8p3se, Binary8p3se, (ToNearestTiesToEven, SatFinite))
      * Add(Binary8p3se, Binary8p3se, Binary8p4se, (ToNearestTiesToEven, SatFinite))
      * Add(Binary8p4se, Binary8p4se, Binary8p4se, (ToNearestTiesToEven, SatFinite))

SqrtFast(fx, fr, ρ)
    available formats: [Binary8p3se, Binary8p4se]
    constraints:
      - fr in {Binary8p3se, Binary8p4se}
      - fx in {Binary8p4se, Binary8p4se}
      - PrecisionOf(fr) >= PrecisionOf(fx)
      > SqrtFast(Binary8p3se, Binary8p3se, ρ)
      > SqrtFast(Binary8p3se, Binary8p4se, ρ)
      > SqrtFast(Binary8p4se, Binary8p4se, ρ)
      -  ρ in { (ToNearestTiesToEven, SatFinite), (TowardZero, SatFinite) }
      * SqrtFast(Binary8p3se, Binary8p3se, (ToNearestTiesToEven, SatFinite))
      * SqrtFast(Binary8p3se, Binary8p4se, (ToNearestTiesToEven, SatFinite))
      * SqrtFast(Binary8p4se, Binary8p4se, (ToNearestTiesToEven, SatFinite))- 
      * SqrtFast(Binary8p3se, Binary8p3se, (TowardZero, SatFinite))
      * SqrtFast(Binary8p3se, Binary8p4se, (TowardZero, SatFinite))
      * SqrtFast(Binary8p4se, Binary8p4se, (TowardZero, SatFinite))

Signatures for Profile "Core32":
    * Add(Binary8p3se, Binary8p3se, Binary8p3se, (ToNearestTiesToEven, OvfInf))
    * Add(Binary8p3se, Binary8p3se, Binary8p4se, (ToNearestTiesToEven, OvfInf))
    * Add(Binary8p4se, Binary8p4se, Binary8p4se, (ToNearestTiesToEven, OvfInf))
    * Add(Binary8p3se, Binary8p3se, Binary8p3se, (ToNearestTiesToEven, SatFinite))
    * Add(Binary8p3se, Binary8p3se, Binary8p4se, (ToNearestTiesToEven, SatFinite))
    * Add(Binary8p4se, Binary8p4se, Binary8p4se, (ToNearestTiesToEven, SatFinite))

    * SqrtFast(Binary8p3se, Binary8p3se, (ToNearestTiesToEven, SatFinite))
    * SqrtFast(Binary8p3se, Binary8p4se, (ToNearestTiesToEven, SatFinite))
    * SqrtFast(Binary8p4se, Binary8p4se, (ToNearestTiesToEven, SatFinite)) 
    * SqrtFast(Binary8p3se, Binary8p3se, (TowardZero, SatFinite))
    * SqrtFast(Binary8p3se, Binary8p4se, (TowardZero, SatFinite))
    * SqrtFast(Binary8p4se, Binary8p4se, (TowardZero, SatFinite))

