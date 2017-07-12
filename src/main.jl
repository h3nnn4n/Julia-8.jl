include("types.jl")
include("utils.jl")
include("opcodes.jl")

function main()
    rom_name = ""

    if length(ARGS) > 0
        rom_name = ARGS[1]
    else
        println("Please give me a filename")
    end

    state = init_emulator()

    load_rom!(state, rom_name)

    #=println(state.rom)=#

    for i in 1:div(length(state.rom), 2)
        step_cpu(state)
    end
end

main()

