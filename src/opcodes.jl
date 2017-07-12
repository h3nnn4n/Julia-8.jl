include("types.jl")

function step_cpu( st :: emulator_state )
    pc = st.PC

    opcode = st.rom[pc]
    arg = st.rom[pc+1]

    x   = opcode & 0x0f
    y   = arg >> 4
    kk  = arg
    nnn = arg | (x << 8)
    f   = opcode >> 4

    #=@printf("pc: %04x %02x %02x - ", pc, opcode, arg)=#

    if f == 0x0
        if kk == 0xe0
        #  00E0 - CLS
            @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
            @printf("CLS\n")
            st.PC += 2
        elseif kk == 0xee
        #  00EE - RET
            @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
            @printf("RET\n")
            st.PC = st.stack[st.SP]
            st.SP -= 1
        else
        #  0nnn - SYS addr
            @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
            #=@printf("SYS\n")=#
            @printf("SYS %03x\n", nnn)
            st.PC = nnn
        end
    elseif f == 0x1
        #  1nnn - JP addr
        @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
        @printf("JMP %03x\n", nnn)
        st.PC = nnn
    elseif f == 0x2
        #  2nnn - CALL addr
        @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
        #=@printf("%2x %2x %2x %2x %2x ", x, y, kk, nnn, f)=#
        @printf("CALL %03x\n", nnn)
        st.stack[st.SP] = st.PC
        st.SP += 1
        st.PC = nnn
    elseif f == 0x3
        #  3xkk - SE Vx, byte
        @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
        @printf("SE %01x %02x\n", x, kk)
        if st.registers[x+1] == kk
            st.PC += 4
        else
            st.PC += 2
        end
    elseif f == 0x4
        #  4xkk - SNE Vx, byte
        #  3xkk - SE Vx, byte
        @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
        @printf("SNE %01x %02x\n", x, kk)
        if st.registers[x+1] != kk
            st.PC += 4
        else
            st.PC += 2
        end
    #=elseif f == 0x5=#
    #=elseif f == 0x6=#
    #=elseif f == 0x7=#
    #=elseif f == 0x8=#
    #=elseif f == 0x9=#
    #=elseif f == 0xa=#
    #=elseif f == 0xb=#
    #=elseif f == 0xc=#
    #=elseif f == 0xd=#
    #=elseif f == 0xe=#
    #=elseif f == 0xf=#
    else
        @printf("pc: %04x %02x %02x - ", pc, opcode, arg)
        @printf("\n")
        st.PC += 2
    end
end

#  5xy0 - SE Vx, Vy
#  6xkk - LD Vx, byte
#  7xkk - ADD Vx, byte
#  8xy0 - LD Vx, Vy
#  8xy1 - OR Vx, Vy
#  8xy2 - AND Vx, Vy
#  8xy3 - XOR Vx, Vy
#  8xy4 - ADD Vx, Vy
#  8xy5 - SUB Vx, Vy
#  8xy6 - SHR Vx {, Vy}
#  8xy7 - SUBN Vx, Vy
#  8xyE - SHL Vx {, Vy}
#  9xy0 - SNE Vx, Vy
#  Annn - LD I, addr
#  Bnnn - JP V0, addr
#  Cxkk - RND Vx, byte
#  Dxyn - DRW Vx, Vy, nibble
#  Ex9E - SKP Vx
#  ExA1 - SKNP Vx
#  Fx07 - LD Vx, DT
#  Fx0A - LD Vx, K
#  Fx15 - LD DT, Vx
#  Fx18 - LD ST, Vx
#  Fx1E - ADD I, Vx
#  Fx29 - LD F, Vx
#  Fx33 - LD B, Vx
#  Fx55 - LD [I], Vx
#  Fx65 - LD Vx, [I]
