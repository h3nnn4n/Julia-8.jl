type emulator_state
    rom       :: Array{UInt8, 1}
    memory    :: Array{UInt8, 1}
    registers :: Array{UInt8, 1}
    stack     :: Array{UInt8, 1}
    I         :: UInt16
    PC        :: UInt16
    SP        :: UInt8
    DT        :: UInt8
    ST        :: UInt8
    VF        :: UInt8
end
