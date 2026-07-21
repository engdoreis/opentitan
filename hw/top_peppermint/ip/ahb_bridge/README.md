# AHB Bridge

Bidirectional AHB-Lite &harr; TL-UL protocol bridge for Peppermint. A
register-less structural wrapper (`rtl/ahb_bridge.sv`) instantiating two
single-direction converters, wired into the top by topgen.
