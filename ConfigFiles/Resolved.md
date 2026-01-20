```
Format["Core32"] = ["Binary8p3se", "Binary8p4se"]
Format["Core64"] = ["Binary4p1sf", "Binary4p2sf", "Binary8p3se", "Binary8p4se"]

IEEE754_format["Core32"] = ["binary32"]
  ConvertToIEEE754(fx, r, ρ)
  > ConvertToIEEE754(Binary8p3se, binary32, ρ)
  > ConvertToIEEE754(Binary8p4se, binary32, ρ)
  ρ in [
    (NearestTiesToEven, SatPropagate),
    (StochasticB(Minimum(Precision(FMT), 16)), SatPropagate),
  ]
  * ConvertToIEEE754(x::Binary8p3se, r=binary32, ρ=(NearestTiesToEven, SatPropagate))
  * ConvertToIEEE754(x::Binary8p3se, r=binary32, ρ=(StochasticB(3), SatPropagate))
  * ConvertToIEEE754(x::Binary8p4se, r=binary32, ρ=(NearestTiesToEven, SatPropagate))
  * ConvertToIEEE754(x::Binary8p4se, r=binary32, ρ=(StochasticB(4), SatPropagate))

  ConvertFromIEEE754(fx, r, ρ)
  > ConvertFromIEEE754(binary32, Binary8p3se, ρ)
  > ConvertFromIEEE754(binary32, Binary8p4se, ρ)
  ρ in [
    (NearestTiesToEven, SatPropagate),
    (StochasticB(Minimum(Precision(FMT), 16)), SatPropagate),
  ]
  * ConvertFromIEEE754(x::binary32, r=Binary8p3se, ρ=(NearestTiesToEven, SatPropagate))
  * ConvertFromIEEE754(x::binary32, r=Binary8p3se, ρ=(StochasticB(3), SatPropagate))
  * ConvertFromIEEE754(x::binary32, r=Binary8p4se, ρ=(NearestTiesToEven, SatPropagate))
  * ConvertFromIEEE754(x::binary32, r=Binary8p4se, ρ=(StochasticB(4), SatPropagate))

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
      * SqrtFast(Binary8p4se, Binary8p4se, (ToNearestTiesToEven, SatFinite)) 
      * SqrtFast(Binary8p3se, Binary8p3se, (TowardZero, SatFinite))
      * SqrtFast(Binary8p3se, Binary8p4se, (TowardZero, SatFinite))
      * SqrtFast(Binary8p4se, Binary8p4se, (TowardZero, SatFinite))

all ρ
  [ (ToNearestTiesToEven, OvfInf), (ToNearestTiesToEven, SatFinite), (TowardZero, SatFinite) ]

Signatures for "Core32":
   
    <Add(x::fx, y::fy, r::fr, ρ)>
    Add(x::Binary8p3se, y::Binary8p3se, r::Binary8p3se, ρ=(ToNearestTiesToEven, OvfInf))
    Add(x::Binary8p3se, y::Binary8p3se, r::Binary8p4se, ρ=(ToNearestTiesToEven, OvfInf))
    Add(x::Binary8p4se, y::Binary8p4se, r::Binary8p4se, ρ=(ToNearestTiesToEven, OvfInf))
    Add(x::Binary8p3se, y::Binary8p3se, r::Binary8p3se, ρ=(ToNearestTiesToEven, SatFinite))
    Add(x::Binary8p3se, y::Binary8p3se, r::Binary8p4se, ρ=(ToNearestTiesToEven, SatFinite))
    Add(x::Binary8p4se, y::Binary8p4se, r::Binary8p4se, ρ=(ToNearestTiesToEven, SatFinite))

    <SqrtFast(x::fx, r::fr, ρ)>
    SqrtFast(x::Binary8p3se, r::Binary8p3se, ρ=(ToNearestTiesToEven, SatFinite))
    SqrtFast(x::Binary8p3se, r::Binary8p4se, ρ=(ToNearestTiesToEven, SatFinite))
    SqrtFast(x::Binary8p4se, r::Binary8p4se, ρ=(ToNearestTiesToEven, SatFinite)) 
    SqrtFast(x::Binary8p3se, r::Binary8p3se, ρ=(TowardZero, SatFinite))
    SqrtFast(x::Binary8p3se, r::Binary8p4se, ρ=(TowardZero, SatFinite))
    SqrtFast(x::Binary8p4se, r::Binary8p4se, ρ=(TowardZero, SatFinite))

    <ConvertToIEEE754(x::f, r, ρ)>
    ConvertToIEEE754(x::Binary8p3se, r=binary32, ρ=(NearestTiesToEven, SatPropagate))
    ConvertToIEEE754(x::Binary8p3se, r=binary32, ρ=(StochasticB(3), SatPropagate))
    ConvertToIEEE754(x::Binary8p4se, r=binary32, ρ=(NearestTiesToEven, SatPropagate))
    ConvertToIEEE754(x::Binary8p4se, r=binary32, ρ=(StochasticB(4), SatPropagate))

    <ConvertFromIEEE754(x::f754, r, ρ)>
    ConvertFromIEEE754(x::binary32, r=Binary8p3se, ρ=(NearestTiesToEven, SatPropagate))
    ConvertFromIEEE754(x::binary32, r=Binary8p3se, ρ=(StochasticB(3), SatPropagate))
    ConvertFromIEEE754(x::binary32, r=Binary8p4se, ρ=(NearestTiesToEven, SatPropagate))
    ConvertFromIEEE754(x::binary32, r=Binary8p4se, ρ=(StochasticB(4), SatPropagate))

    <Convert(x::f, r, ρ)>
    Convert(x::Binary8p3se, r=Binary8p4se, ρ=(NearestTiesToEven, SatPropagate))
    Convert(x::Binary8p4se, r=Binary8p3se, ρ=(NearestTiesToEven, SatPropagate))
    Convert(x::Binary8p3se, r=Binary8p4se, ρ=(StochasticB(3), SatPropagate))
    Convert(x::Binary8p4se, r=Binary8p3se, ρ=(StochasticB(4), SatPropagate))
```
