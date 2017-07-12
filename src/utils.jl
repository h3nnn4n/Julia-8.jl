include("types.jl")

function init_emulator()
    state = emulator_state([], [], [], [],
                            0, 0, 0, 0, 0, 0)

    state.memory    = zeros(Int8, 0xfff)
    state.registers = zeros(Int8, 0xf  )
    state.stack     = zeros(Int8, 0xf  )

    state.PC = 1
    state.SP = 1

    return state
end

function load_rom!(state, name)
    println("Opening: ", name)
    state.rom = read(name)
end


