circuit Elidon :
  module InstructionMemory :
    input clock : Clock
    input reset : Reset
    output io : { flip pc : UInt<16>, instruction : UInt<16>}

    wire rom : UInt<16>[22] @[InstructionMemory.scala 15:20]
    rom[0] <= UInt<16>("hdb04") @[InstructionMemory.scala 15:20]
    rom[1] <= UInt<16>("h9c03") @[InstructionMemory.scala 15:20]
    rom[2] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[3] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[4] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[5] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[6] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[7] <= UInt<16>("h4dbc") @[InstructionMemory.scala 15:20]
    rom[8] <= UInt<16>("h2ebc") @[InstructionMemory.scala 15:20]
    rom[9] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[10] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[11] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[12] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[13] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[14] <= UInt<16>("hed00") @[InstructionMemory.scala 15:20]
    rom[15] <= UInt<16>("hee02") @[InstructionMemory.scala 15:20]
    rom[16] <= UInt<16>("hf000") @[InstructionMemory.scala 15:20]
    rom[17] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[18] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[19] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[20] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    rom[21] <= UInt<16>("h2000") @[InstructionMemory.scala 15:20]
    node _io_instruction_T = bits(io.pc, 7, 1) @[InstructionMemory.scala 17:30]
    node _io_instruction_T_1 = bits(_io_instruction_T, 4, 0)
    io.instruction <= rom[_io_instruction_T_1] @[InstructionMemory.scala 17:18]

  module FetchStage :
    input clock : Clock
    input reset : Reset
    output io : { flip branch : { enable : UInt<1>, pc : UInt<16>}, f2d : { pc : UInt<16>, instruction : UInt<16>}}

    node _pcReg_T = asUInt(asSInt(UInt<16>("hfffe"))) @[FetchStage.scala 20:36]
    reg pcReg : UInt, clock with :
      reset => (reset, _pcReg_T) @[FetchStage.scala 20:22]
    node _pc_T = add(pcReg, UInt<2>("h2")) @[FetchStage.scala 21:54]
    node _pc_T_1 = tail(_pc_T, 1) @[FetchStage.scala 21:54]
    node pc = mux(io.branch.enable, io.branch.pc, _pc_T_1) @[FetchStage.scala 21:15]
    pcReg <= pc @[FetchStage.scala 22:9]
    inst instructionMemory of InstructionMemory @[FetchStage.scala 24:33]
    instructionMemory.clock <= clock
    instructionMemory.reset <= reset
    instructionMemory.io.pc <= pc @[FetchStage.scala 25:27]
    io.f2d.pc <= pcReg @[FetchStage.scala 27:13]
    reg io_f2d_instruction_REG : UInt, clock with :
      reset => (UInt<1>("h0"), io_f2d_instruction_REG) @[FetchStage.scala 28:32]
    io_f2d_instruction_REG <= instructionMemory.io.instruction @[FetchStage.scala 28:32]
    io.f2d.instruction <= io_f2d_instruction_REG @[FetchStage.scala 28:22]

  module DecodeStage :
    input clock : Clock
    input reset : Reset
    output io : { flip f2d : { pc : UInt<16>, instruction : UInt<16>}, d2e : { pc : UInt<16>, instruction : UInt<16>, rs1 : UInt<16>, rs2 : UInt<16>}, flip m2w : { rd : UInt<16>, rdAdress : UInt<4>, writeBack : UInt<1>}}

    wire _registerFile_WIRE : UInt<16>[16] @[DecodeStage.scala 18:46]
    _registerFile_WIRE[0] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[1] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[2] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[3] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[4] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[5] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[6] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[7] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[8] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[9] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[10] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[11] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[12] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[13] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[14] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    _registerFile_WIRE[15] <= UInt<16>("h0") @[DecodeStage.scala 18:46]
    reg registerFile : UInt<16>[16], clock with :
      reset => (reset, _registerFile_WIRE) @[DecodeStage.scala 18:29]
    node opcode = bits(io.f2d.instruction, 15, 12) @[DecodeStage.scala 22:27]
    reg d2eReg : { pc : UInt<16>, instruction : UInt<16>, rs1 : UInt<16>, rs2 : UInt<16>}, clock with :
      reset => (UInt<1>("h0"), d2eReg) @[DecodeStage.scala 25:19]
    io.d2e <= d2eReg @[DecodeStage.scala 26:10]
    d2eReg.pc <= io.f2d.pc @[DecodeStage.scala 27:13]
    d2eReg.instruction <= io.f2d.instruction @[DecodeStage.scala 28:22]
    node _d2eReg_rs1_T = bits(opcode, 3, 3) @[DecodeStage.scala 29:40]
    node _d2eReg_rs1_T_1 = bits(io.f2d.instruction, 7, 4) @[DecodeStage.scala 29:56]
    node _d2eReg_rs1_T_2 = bits(io.f2d.instruction, 11, 8) @[DecodeStage.scala 29:75]
    node _d2eReg_rs1_T_3 = mux(_d2eReg_rs1_T, _d2eReg_rs1_T_1, _d2eReg_rs1_T_2) @[DecodeStage.scala 29:33]
    d2eReg.rs1 <= registerFile[_d2eReg_rs1_T_3] @[DecodeStage.scala 29:14]
    node _d2eReg_rs2_T = bits(io.f2d.instruction, 3, 0) @[DecodeStage.scala 30:41]
    d2eReg.rs2 <= registerFile[_d2eReg_rs2_T] @[DecodeStage.scala 30:14]
    when io.m2w.writeBack : @[DecodeStage.scala 36:27]
      registerFile[io.m2w.rdAdress] <= io.m2w.rd @[DecodeStage.scala 37:36]


  module ExecuteStage :
    input clock : Clock
    input reset : Reset
    output io : { branch : { enable : UInt<1>, pc : UInt<16>}, flip d2e : { pc : UInt<16>, instruction : UInt<16>, rs1 : UInt<16>, rs2 : UInt<16>}, e2m : { resultOrAdress : UInt<16>, rdAdressOrStoreValue : UInt<16>, writeBack : UInt<1>, store : UInt<1>, load : UInt<1>}}

    wire _e2mReg_WIRE : { resultOrAdress : UInt<16>, rdAdressOrStoreValue : UInt<16>, writeBack : UInt<1>, store : UInt<1>, load : UInt<1>} @[ExecuteStage.scala 38:36]
    _e2mReg_WIRE.load <= UInt<1>("h0") @[ExecuteStage.scala 38:36]
    _e2mReg_WIRE.store <= UInt<1>("h0") @[ExecuteStage.scala 38:36]
    _e2mReg_WIRE.writeBack <= UInt<1>("h0") @[ExecuteStage.scala 38:36]
    _e2mReg_WIRE.rdAdressOrStoreValue <= UInt<16>("h0") @[ExecuteStage.scala 38:36]
    _e2mReg_WIRE.resultOrAdress <= UInt<16>("h0") @[ExecuteStage.scala 38:36]
    reg e2mReg : { resultOrAdress : UInt<16>, rdAdressOrStoreValue : UInt<16>, writeBack : UInt<1>, store : UInt<1>, load : UInt<1>}, clock with :
      reset => (reset, _e2mReg_WIRE) @[ExecuteStage.scala 38:23]
    io.e2m <= e2mReg @[ExecuteStage.scala 39:10]
    node opcode = bits(io.d2e.instruction, 15, 12) @[ExecuteStage.scala 41:34]
    wire toAdd1 : UInt<16> @[ExecuteStage.scala 44:27]
    toAdd1 <= UInt<16>("h0") @[ExecuteStage.scala 44:27]
    wire toAdd2 : UInt<16> @[ExecuteStage.scala 45:27]
    toAdd2 <= UInt<16>("h0") @[ExecuteStage.scala 45:27]
    node _added_T = add(toAdd1, toAdd2) @[ExecuteStage.scala 46:34]
    node _added_T_1 = tail(_added_T, 1) @[ExecuteStage.scala 46:34]
    wire added : UInt @[ExecuteStage.scala 46:26]
    added <= _added_T_1 @[ExecuteStage.scala 46:26]
    node _io_branch_enable_T = eq(opcode, UInt<4>("hd")) @[ExecuteStage.scala 51:14]
    node _io_branch_enable_T_1 = eq(opcode, UInt<4>("he")) @[ExecuteStage.scala 52:14]
    node _io_branch_enable_T_2 = or(_io_branch_enable_T, _io_branch_enable_T_1) @[ExecuteStage.scala 51:28]
    node _io_branch_enable_T_3 = eq(opcode, UInt<4>("hf")) @[ExecuteStage.scala 53:14]
    node _io_branch_enable_T_4 = or(_io_branch_enable_T_2, _io_branch_enable_T_3) @[ExecuteStage.scala 52:30]
    node _io_branch_enable_T_5 = eq(opcode, UInt<4>("hc")) @[ExecuteStage.scala 54:14]
    node _io_branch_enable_T_6 = eq(io.d2e.rs1, UInt<1>("h0")) @[ExecuteStage.scala 55:18]
    node _io_branch_enable_T_7 = and(_io_branch_enable_T_5, _io_branch_enable_T_6) @[ExecuteStage.scala 54:29]
    node _io_branch_enable_T_8 = or(_io_branch_enable_T_4, _io_branch_enable_T_7) @[ExecuteStage.scala 53:27]
    io.branch.enable <= _io_branch_enable_T_8 @[ExecuteStage.scala 50:20]
    node _io_branch_pc_T = eq(opcode, UInt<4>("he")) @[ExecuteStage.scala 58:30]
    node _io_branch_pc_T_1 = eq(opcode, UInt<4>("hd")) @[ExecuteStage.scala 58:56]
    node _io_branch_pc_T_2 = or(_io_branch_pc_T, _io_branch_pc_T_1) @[ExecuteStage.scala 58:46]
    node _io_branch_pc_T_3 = mux(_io_branch_pc_T_2, io.d2e.rs1, added) @[ExecuteStage.scala 58:22]
    io.branch.pc <= _io_branch_pc_T_3 @[ExecuteStage.scala 58:16]
    e2mReg.resultOrAdress <= added @[ExecuteStage.scala 59:25]
    node _e2mReg_rdAdressOrStoreValue_T = eq(opcode, UInt<4>("h9")) @[ExecuteStage.scala 63:46]
    node _e2mReg_rdAdressOrStoreValue_T_1 = bits(io.d2e.instruction, 11, 8) @[ExecuteStage.scala 63:91]
    node _e2mReg_rdAdressOrStoreValue_T_2 = mux(_e2mReg_rdAdressOrStoreValue_T, io.d2e.rs1, _e2mReg_rdAdressOrStoreValue_T_1) @[ExecuteStage.scala 63:38]
    e2mReg.rdAdressOrStoreValue <= _e2mReg_rdAdressOrStoreValue_T_2 @[ExecuteStage.scala 63:32]
    node _e2mReg_writeBack_T = eq(opcode, UInt<4>("h9")) @[ExecuteStage.scala 66:32]
    node _e2mReg_writeBack_T_1 = eq(opcode, UInt<4>("hf")) @[ExecuteStage.scala 66:56]
    node _e2mReg_writeBack_T_2 = or(_e2mReg_writeBack_T, _e2mReg_writeBack_T_1) @[ExecuteStage.scala 66:46]
    node _e2mReg_writeBack_T_3 = eq(opcode, UInt<4>("hd")) @[ExecuteStage.scala 66:79]
    node _e2mReg_writeBack_T_4 = or(_e2mReg_writeBack_T_2, _e2mReg_writeBack_T_3) @[ExecuteStage.scala 66:69]
    node _e2mReg_writeBack_T_5 = eq(opcode, UInt<4>("hc")) @[ExecuteStage.scala 66:103]
    node _e2mReg_writeBack_T_6 = or(_e2mReg_writeBack_T_4, _e2mReg_writeBack_T_5) @[ExecuteStage.scala 66:93]
    node _e2mReg_writeBack_T_7 = eq(_e2mReg_writeBack_T_6, UInt<1>("h0")) @[ExecuteStage.scala 66:23]
    e2mReg.writeBack <= _e2mReg_writeBack_T_7 @[ExecuteStage.scala 66:20]
    node _e2mReg_store_T = eq(opcode, UInt<4>("h9")) @[ExecuteStage.scala 69:26]
    e2mReg.store <= _e2mReg_store_T @[ExecuteStage.scala 69:16]
    node _e2mReg_load_T = eq(opcode, UInt<4>("h8")) @[ExecuteStage.scala 71:25]
    e2mReg.load <= _e2mReg_load_T @[ExecuteStage.scala 71:15]
    node _T = bits(io.d2e.instruction, 15, 12) @[ExecuteStage.scala 74:28]
    node _T_1 = eq(UInt<4>("h0"), _T) @[ExecuteStage.scala 74:38]
    when _T_1 : @[ExecuteStage.scala 74:38]
      node _e2mReg_resultOrAdress_T = and(io.d2e.rs1, io.d2e.rs2) @[ExecuteStage.scala 76:43]
      e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T @[ExecuteStage.scala 76:29]
    else :
      node _T_2 = eq(UInt<4>("h1"), _T) @[ExecuteStage.scala 74:38]
      when _T_2 : @[ExecuteStage.scala 74:38]
        node _e2mReg_resultOrAdress_T_1 = or(io.d2e.rs1, io.d2e.rs2) @[ExecuteStage.scala 79:45]
        node _e2mReg_resultOrAdress_T_2 = not(_e2mReg_resultOrAdress_T_1) @[ExecuteStage.scala 79:32]
        e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_2 @[ExecuteStage.scala 79:29]
      else :
        node _T_3 = eq(UInt<4>("h2"), _T) @[ExecuteStage.scala 74:38]
        when _T_3 : @[ExecuteStage.scala 74:38]
          toAdd1 <= io.d2e.rs1 @[ExecuteStage.scala 82:14]
          toAdd2 <= io.d2e.rs2 @[ExecuteStage.scala 83:14]
        else :
          node _T_4 = eq(UInt<4>("h3"), _T) @[ExecuteStage.scala 74:38]
          when _T_4 : @[ExecuteStage.scala 74:38]
            toAdd1 <= io.d2e.rs1 @[ExecuteStage.scala 86:14]
            node _toAdd2_T = asSInt(io.d2e.rs2) @[ExecuteStage.scala 87:31]
            node _toAdd2_T_1 = sub(asSInt(UInt<1>("h0")), _toAdd2_T) @[ExecuteStage.scala 87:18]
            node _toAdd2_T_2 = tail(_toAdd2_T_1, 1) @[ExecuteStage.scala 87:18]
            node _toAdd2_T_3 = asSInt(_toAdd2_T_2) @[ExecuteStage.scala 87:18]
            node _toAdd2_T_4 = asUInt(_toAdd2_T_3) @[ExecuteStage.scala 87:39]
            toAdd2 <= _toAdd2_T_4 @[ExecuteStage.scala 87:14]
          else :
            node _T_5 = eq(UInt<4>("h4"), _T) @[ExecuteStage.scala 74:38]
            when _T_5 : @[ExecuteStage.scala 74:38]
              node _e2mReg_resultOrAdress_T_3 = bits(io.d2e.rs2, 15, 15) @[ExecuteStage.scala 91:46]
              node _e2mReg_resultOrAdress_T_4 = sub(UInt<1>("h0"), io.d2e.rs2) @[ExecuteStage.scala 91:67]
              node _e2mReg_resultOrAdress_T_5 = tail(_e2mReg_resultOrAdress_T_4, 1) @[ExecuteStage.scala 91:67]
              node _e2mReg_resultOrAdress_T_6 = dshr(io.d2e.rs1, _e2mReg_resultOrAdress_T_5) @[ExecuteStage.scala 91:63]
              node _e2mReg_resultOrAdress_T_7 = dshl(io.d2e.rs1, io.d2e.rs2) @[ExecuteStage.scala 91:99]
              node _e2mReg_resultOrAdress_T_8 = mux(_e2mReg_resultOrAdress_T_3, _e2mReg_resultOrAdress_T_6, _e2mReg_resultOrAdress_T_7) @[ExecuteStage.scala 91:35]
              e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_8 @[ExecuteStage.scala 91:29]
            else :
              node _T_6 = eq(UInt<4>("h5"), _T) @[ExecuteStage.scala 74:38]
              when _T_6 : @[ExecuteStage.scala 74:38]
                node _e2mReg_resultOrAdress_T_9 = asSInt(io.d2e.rs1) @[ExecuteStage.scala 94:44]
                node _e2mReg_resultOrAdress_T_10 = asSInt(io.d2e.rs2) @[ExecuteStage.scala 94:64]
                node _e2mReg_resultOrAdress_T_11 = lt(_e2mReg_resultOrAdress_T_9, _e2mReg_resultOrAdress_T_10) @[ExecuteStage.scala 94:51]
                e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_11 @[ExecuteStage.scala 94:29]
              else :
                node _T_7 = eq(UInt<4>("h6"), _T) @[ExecuteStage.scala 74:38]
                when _T_7 : @[ExecuteStage.scala 74:38]
                  node _e2mReg_resultOrAdress_T_12 = asSInt(io.d2e.rs1) @[ExecuteStage.scala 98:44]
                  node _e2mReg_resultOrAdress_T_13 = asSInt(io.d2e.rs2) @[ExecuteStage.scala 98:64]
                  node _e2mReg_resultOrAdress_T_14 = div(_e2mReg_resultOrAdress_T_12, _e2mReg_resultOrAdress_T_13) @[ExecuteStage.scala 98:51]
                  node _e2mReg_resultOrAdress_T_15 = asUInt(_e2mReg_resultOrAdress_T_14) @[ExecuteStage.scala 98:72]
                  e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_15 @[ExecuteStage.scala 98:29]
                else :
                  node _T_8 = eq(UInt<4>("h7"), _T) @[ExecuteStage.scala 74:38]
                  when _T_8 : @[ExecuteStage.scala 74:38]
                    node _e2mReg_resultOrAdress_T_16 = asSInt(io.d2e.rs1) @[ExecuteStage.scala 101:44]
                    node _e2mReg_resultOrAdress_T_17 = asSInt(io.d2e.rs2) @[ExecuteStage.scala 101:64]
                    node _e2mReg_resultOrAdress_T_18 = mul(_e2mReg_resultOrAdress_T_16, _e2mReg_resultOrAdress_T_17) @[ExecuteStage.scala 101:51]
                    node _e2mReg_resultOrAdress_T_19 = asUInt(_e2mReg_resultOrAdress_T_18) @[ExecuteStage.scala 101:72]
                    e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_19 @[ExecuteStage.scala 101:29]
                  else :
                    node _T_9 = eq(UInt<4>("h8"), _T) @[ExecuteStage.scala 74:38]
                    node _T_10 = eq(UInt<4>("h9"), _T) @[ExecuteStage.scala 74:38]
                    node _T_11 = or(_T_9, _T_10) @[ExecuteStage.scala 74:38]
                    when _T_11 : @[ExecuteStage.scala 74:38]
                      toAdd1 <= io.d2e.rs1 @[ExecuteStage.scala 104:14]
                      node _toAdd2_T_5 = bits(io.d2e.instruction, 3, 0) @[ExecuteStage.scala 105:35]
                      toAdd2 <= _toAdd2_T_5 @[ExecuteStage.scala 105:14]
                    else :
                      node _T_12 = eq(UInt<4>("ha"), _T) @[ExecuteStage.scala 74:38]
                      when _T_12 : @[ExecuteStage.scala 74:38]
                        node _e2mReg_resultOrAdress_T_20 = bits(io.d2e.instruction, 7, 0) @[ExecuteStage.scala 108:50]
                        node _e2mReg_resultOrAdress_T_21 = bits(io.d2e.rs1, 7, 0) @[ExecuteStage.scala 108:70]
                        node _e2mReg_resultOrAdress_T_22 = cat(_e2mReg_resultOrAdress_T_20, _e2mReg_resultOrAdress_T_21) @[ExecuteStage.scala 108:57]
                        e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_22 @[ExecuteStage.scala 108:29]
                      else :
                        node _T_13 = eq(UInt<4>("hb"), _T) @[ExecuteStage.scala 74:38]
                        when _T_13 : @[ExecuteStage.scala 74:38]
                          node _e2mReg_resultOrAdress_T_23 = bits(io.d2e.rs1, 15, 8) @[ExecuteStage.scala 111:42]
                          node _e2mReg_resultOrAdress_T_24 = bits(io.d2e.instruction, 7, 0) @[ExecuteStage.scala 111:71]
                          node _e2mReg_resultOrAdress_T_25 = cat(_e2mReg_resultOrAdress_T_23, _e2mReg_resultOrAdress_T_24) @[ExecuteStage.scala 111:50]
                          e2mReg.resultOrAdress <= _e2mReg_resultOrAdress_T_25 @[ExecuteStage.scala 111:29]
                        else :
                          node _T_14 = eq(UInt<4>("he"), _T) @[ExecuteStage.scala 74:38]
                          when _T_14 : @[ExecuteStage.scala 74:38]
                            toAdd1 <= io.d2e.pc @[ExecuteStage.scala 114:14]
                            toAdd2 <= UInt<2>("h2") @[ExecuteStage.scala 115:14]
                          else :
                            node _T_15 = eq(UInt<4>("hc"), _T) @[ExecuteStage.scala 74:38]
                            when _T_15 : @[ExecuteStage.scala 74:38]
                              toAdd1 <= io.d2e.pc @[ExecuteStage.scala 118:14]
                              wire toAdd2Temp : SInt<16> @[ExecuteStage.scala 120:28]
                              node _toAdd2Temp_T = bits(io.d2e.instruction, 7, 0) @[ExecuteStage.scala 121:39]
                              node _toAdd2Temp_T_1 = asSInt(_toAdd2Temp_T) @[ExecuteStage.scala 121:46]
                              toAdd2Temp <= _toAdd2Temp_T_1 @[ExecuteStage.scala 121:18]
                              node _toAdd2_T_6 = asUInt(toAdd2Temp) @[ExecuteStage.scala 122:28]
                              toAdd2 <= _toAdd2_T_6 @[ExecuteStage.scala 122:14]
                            else :
                              node _T_16 = eq(UInt<4>("hf"), _T) @[ExecuteStage.scala 74:38]
                              when _T_16 : @[ExecuteStage.scala 74:38]
                                toAdd1 <= io.d2e.pc @[ExecuteStage.scala 125:14]
                                wire toAdd2Temp_1 : SInt<16> @[ExecuteStage.scala 127:28]
                                node _toAdd2Temp_T_2 = bits(io.d2e.instruction, 11, 0) @[ExecuteStage.scala 128:39]
                                node _toAdd2Temp_T_3 = asSInt(_toAdd2Temp_T_2) @[ExecuteStage.scala 128:47]
                                toAdd2Temp_1 <= _toAdd2Temp_T_3 @[ExecuteStage.scala 128:18]
                                node _toAdd2_T_7 = asUInt(toAdd2Temp_1) @[ExecuteStage.scala 129:28]
                                toAdd2 <= _toAdd2_T_7 @[ExecuteStage.scala 129:14]


  module MemoryStage :
    input clock : Clock
    input reset : Reset
    output io : { flip data : { flip adress : UInt<16>, flip read : UInt<1>, readValue : UInt<16>, flip write : UInt<1>, flip writeValue : UInt<16>}, flip e2m : { resultOrAdress : UInt<16>, rdAdressOrStoreValue : UInt<16>, writeBack : UInt<1>, store : UInt<1>, load : UInt<1>}, m2w : { rd : UInt<16>, rdAdress : UInt<4>, writeBack : UInt<1>}}

    io.data.adress <= io.e2m.resultOrAdress @[MemoryStage.scala 17:18]
    io.data.writeValue <= io.e2m.rdAdressOrStoreValue @[MemoryStage.scala 18:22]
    io.data.write <= io.e2m.store @[MemoryStage.scala 19:17]
    io.data.read <= io.e2m.load @[MemoryStage.scala 20:16]
    reg writeValueReg : UInt, clock with :
      reset => (UInt<1>("h0"), writeValueReg) @[MemoryStage.scala 21:30]
    writeValueReg <= io.e2m.rdAdressOrStoreValue @[MemoryStage.scala 21:30]
    when io.e2m.load : @[MemoryStage.scala 22:21]
      io.m2w.rd <= io.data.readValue @[MemoryStage.scala 23:16]
    else :
      io.m2w.rd <= writeValueReg @[MemoryStage.scala 25:16]
    node _io_m2w_rdAdress_T = bits(io.e2m.rdAdressOrStoreValue, 3, 0) @[MemoryStage.scala 27:51]
    io.m2w.rdAdress <= _io_m2w_rdAdress_T @[MemoryStage.scala 27:20]
    node _io_m2w_writeBack_T = or(io.e2m.load, io.e2m.writeBack) @[MemoryStage.scala 28:35]
    io.m2w.writeBack <= _io_m2w_writeBack_T @[MemoryStage.scala 28:20]

  module DataMemory :
    input clock : Clock
    input reset : Reset
    output io : { data : { flip adress : UInt<16>, flip read : UInt<1>, readValue : UInt<16>, flip write : UInt<1>, flip writeValue : UInt<16>}, leds : UInt<16>, displayValue : UInt<16>, flip switches : UInt<16>}

    smem memory : UInt<8> [18] @[DataMemory.scala 22:27]
    wire _lsB_WIRE : UInt @[DataMemory.scala 30:24]
    _lsB_WIRE is invalid @[DataMemory.scala 30:24]
    when io.data.read : @[DataMemory.scala 30:24]
      _lsB_WIRE <= io.data.adress @[DataMemory.scala 30:24]
      node _lsB_T = or(_lsB_WIRE, UInt<5>("h0")) @[DataMemory.scala 30:24]
      node _lsB_T_1 = bits(_lsB_T, 4, 0) @[DataMemory.scala 30:24]
      read mport lsB = memory[_lsB_T_1], clock @[DataMemory.scala 30:24]
    node _msB_T = add(io.data.adress, UInt<1>("h1")) @[DataMemory.scala 31:40]
    node _msB_T_1 = tail(_msB_T, 1) @[DataMemory.scala 31:40]
    wire _msB_WIRE : UInt @[DataMemory.scala 31:24]
    _msB_WIRE is invalid @[DataMemory.scala 31:24]
    when io.data.read : @[DataMemory.scala 31:24]
      _msB_WIRE <= _msB_T_1 @[DataMemory.scala 31:24]
      node _msB_T_2 = or(_msB_WIRE, UInt<5>("h0")) @[DataMemory.scala 31:24]
      node _msB_T_3 = bits(_msB_T_2, 4, 0) @[DataMemory.scala 31:24]
      read mport msB = memory[_msB_T_3], clock @[DataMemory.scala 31:24]
    node _io_data_readValue_T = cat(msB, lsB) @[DataMemory.scala 32:28]
    io.data.readValue <= _io_data_readValue_T @[DataMemory.scala 32:21]
    when io.data.write : @[DataMemory.scala 34:23]
      node _T = bits(io.data.writeValue, 7, 0) @[DataMemory.scala 35:52]
      node _T_1 = bits(io.data.adress, 4, 0)
      write mport MPORT = memory[_T_1], clock
      MPORT <= _T
      node _T_2 = add(io.data.adress, UInt<1>("h1")) @[DataMemory.scala 36:33]
      node _T_3 = tail(_T_2, 1) @[DataMemory.scala 36:33]
      node _T_4 = bits(io.data.writeValue, 15, 8) @[DataMemory.scala 36:58]
      node _T_5 = bits(_T_3, 4, 0)
      write mport MPORT_1 = memory[_T_5], clock
      MPORT_1 <= _T_4
    reg leds : UInt<16>, clock with :
      reset => (reset, UInt<16>("h0")) @[DataMemory.scala 46:21]
    reg displayValue : UInt<16>, clock with :
      reset => (reset, UInt<16>("h0")) @[DataMemory.scala 47:29]
    reg switches : UInt, clock with :
      reset => (UInt<1>("h0"), switches) @[DataMemory.scala 48:25]
    switches <= io.switches @[DataMemory.scala 48:25]
    io.leds <= leds @[DataMemory.scala 51:11]
    io.displayValue <= displayValue @[DataMemory.scala 52:19]
    when io.data.write : @[DataMemory.scala 56:23]
      node _T_6 = eq(io.data.adress, UInt<1>("h0")) @[DataMemory.scala 57:25]
      when _T_6 : @[DataMemory.scala 57:34]
        leds <= io.data.writeValue @[DataMemory.scala 58:12]
      node _T_7 = eq(io.data.adress, UInt<2>("h2")) @[DataMemory.scala 60:25]
      when _T_7 : @[DataMemory.scala 60:34]
        displayValue <= io.data.writeValue @[DataMemory.scala 61:20]
    node _T_8 = eq(io.data.adress, UInt<3>("h4")) @[DataMemory.scala 64:23]
    when _T_8 : @[DataMemory.scala 64:32]
      io.data.readValue <= switches @[DataMemory.scala 65:23]


  module SevenSegDec :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<4>, out : UInt<7>}

    wire sevSeg : UInt @[DisplayMultiplexer.scala 65:27]
    sevSeg <= UInt<1>("h0") @[DisplayMultiplexer.scala 65:27]
    node _T = eq(UInt<1>("h0"), io.in) @[DisplayMultiplexer.scala 67:18]
    when _T : @[DisplayMultiplexer.scala 67:18]
      sevSeg <= UInt<6>("h3f") @[DisplayMultiplexer.scala 68:23]
    else :
      node _T_1 = eq(UInt<1>("h1"), io.in) @[DisplayMultiplexer.scala 67:18]
      when _T_1 : @[DisplayMultiplexer.scala 67:18]
        sevSeg <= UInt<3>("h6") @[DisplayMultiplexer.scala 69:23]
      else :
        node _T_2 = eq(UInt<2>("h2"), io.in) @[DisplayMultiplexer.scala 67:18]
        when _T_2 : @[DisplayMultiplexer.scala 67:18]
          sevSeg <= UInt<7>("h5b") @[DisplayMultiplexer.scala 70:23]
        else :
          node _T_3 = eq(UInt<2>("h3"), io.in) @[DisplayMultiplexer.scala 67:18]
          when _T_3 : @[DisplayMultiplexer.scala 67:18]
            sevSeg <= UInt<7>("h4f") @[DisplayMultiplexer.scala 71:23]
          else :
            node _T_4 = eq(UInt<3>("h4"), io.in) @[DisplayMultiplexer.scala 67:18]
            when _T_4 : @[DisplayMultiplexer.scala 67:18]
              sevSeg <= UInt<7>("h66") @[DisplayMultiplexer.scala 72:23]
            else :
              node _T_5 = eq(UInt<3>("h5"), io.in) @[DisplayMultiplexer.scala 67:18]
              when _T_5 : @[DisplayMultiplexer.scala 67:18]
                sevSeg <= UInt<7>("h6d") @[DisplayMultiplexer.scala 73:23]
              else :
                node _T_6 = eq(UInt<3>("h6"), io.in) @[DisplayMultiplexer.scala 67:18]
                when _T_6 : @[DisplayMultiplexer.scala 67:18]
                  sevSeg <= UInt<7>("h7d") @[DisplayMultiplexer.scala 74:23]
                else :
                  node _T_7 = eq(UInt<3>("h7"), io.in) @[DisplayMultiplexer.scala 67:18]
                  when _T_7 : @[DisplayMultiplexer.scala 67:18]
                    sevSeg <= UInt<3>("h7") @[DisplayMultiplexer.scala 75:23]
                  else :
                    node _T_8 = eq(UInt<4>("h8"), io.in) @[DisplayMultiplexer.scala 67:18]
                    when _T_8 : @[DisplayMultiplexer.scala 67:18]
                      sevSeg <= UInt<7>("h7f") @[DisplayMultiplexer.scala 76:23]
                    else :
                      node _T_9 = eq(UInt<4>("h9"), io.in) @[DisplayMultiplexer.scala 67:18]
                      when _T_9 : @[DisplayMultiplexer.scala 67:18]
                        sevSeg <= UInt<7>("h6f") @[DisplayMultiplexer.scala 77:23]
                      else :
                        node _T_10 = eq(UInt<4>("ha"), io.in) @[DisplayMultiplexer.scala 67:18]
                        when _T_10 : @[DisplayMultiplexer.scala 67:18]
                          sevSeg <= UInt<7>("h77") @[DisplayMultiplexer.scala 78:24]
                        else :
                          node _T_11 = eq(UInt<4>("hb"), io.in) @[DisplayMultiplexer.scala 67:18]
                          when _T_11 : @[DisplayMultiplexer.scala 67:18]
                            sevSeg <= UInt<7>("h7c") @[DisplayMultiplexer.scala 79:24]
                          else :
                            node _T_12 = eq(UInt<4>("hc"), io.in) @[DisplayMultiplexer.scala 67:18]
                            when _T_12 : @[DisplayMultiplexer.scala 67:18]
                              sevSeg <= UInt<6>("h39") @[DisplayMultiplexer.scala 80:24]
                            else :
                              node _T_13 = eq(UInt<4>("hd"), io.in) @[DisplayMultiplexer.scala 67:18]
                              when _T_13 : @[DisplayMultiplexer.scala 67:18]
                                sevSeg <= UInt<7>("h5e") @[DisplayMultiplexer.scala 81:24]
                              else :
                                node _T_14 = eq(UInt<4>("he"), io.in) @[DisplayMultiplexer.scala 67:18]
                                when _T_14 : @[DisplayMultiplexer.scala 67:18]
                                  sevSeg <= UInt<7>("h79") @[DisplayMultiplexer.scala 82:24]
                                else :
                                  node _T_15 = eq(UInt<4>("hf"), io.in) @[DisplayMultiplexer.scala 67:18]
                                  when _T_15 : @[DisplayMultiplexer.scala 67:18]
                                    sevSeg <= UInt<7>("h71") @[DisplayMultiplexer.scala 83:24]
    io.out <= sevSeg @[DisplayMultiplexer.scala 86:10]

  module DisplayMultiplexer :
    input clock : Clock
    input reset : Reset
    output io : { flip value : UInt<16>, display : { segments : UInt<7>, selector : UInt<4>}}

    wire sevSeg : UInt<7> @[DisplayMultiplexer.scala 14:27]
    sevSeg <= UInt<7>("h7f") @[DisplayMultiplexer.scala 14:27]
    wire select : UInt<4> @[DisplayMultiplexer.scala 15:27]
    select <= UInt<4>("h1") @[DisplayMultiplexer.scala 15:27]
    reg countReg : UInt<17>, clock with :
      reset => (reset, UInt<17>("h0")) @[DisplayMultiplexer.scala 19:25]
    node _countReg_T = add(countReg, UInt<1>("h1")) @[DisplayMultiplexer.scala 20:24]
    node _countReg_T_1 = tail(_countReg_T, 1) @[DisplayMultiplexer.scala 20:24]
    countReg <= _countReg_T_1 @[DisplayMultiplexer.scala 20:12]
    node tick = eq(countReg, UInt<17>("h1869f")) @[DisplayMultiplexer.scala 21:23]
    when tick : @[DisplayMultiplexer.scala 23:15]
      countReg <= UInt<1>("h0") @[DisplayMultiplexer.scala 24:14]
    reg digitReg : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[DisplayMultiplexer.scala 27:25]
    node _digitReg_T = add(digitReg, tick) @[DisplayMultiplexer.scala 28:24]
    node _digitReg_T_1 = tail(_digitReg_T, 1) @[DisplayMultiplexer.scala 28:24]
    digitReg <= _digitReg_T_1 @[DisplayMultiplexer.scala 28:12]
    inst sevenSegDec of SevenSegDec @[DisplayMultiplexer.scala 30:27]
    sevenSegDec.clock <= clock
    sevenSegDec.reset <= reset
    sevenSegDec.io.in <= UInt<4>("h0") @[DisplayMultiplexer.scala 32:21]
    node _T = eq(UInt<1>("h0"), digitReg) @[DisplayMultiplexer.scala 34:20]
    when _T : @[DisplayMultiplexer.scala 34:20]
      node _sevenSegDec_io_in_T = bits(io.value, 3, 0) @[DisplayMultiplexer.scala 36:36]
      sevenSegDec.io.in <= _sevenSegDec_io_in_T @[DisplayMultiplexer.scala 36:25]
      select <= UInt<1>("h1") @[DisplayMultiplexer.scala 37:14]
    else :
      node _T_1 = eq(UInt<1>("h1"), digitReg) @[DisplayMultiplexer.scala 34:20]
      when _T_1 : @[DisplayMultiplexer.scala 34:20]
        node _sevenSegDec_io_in_T_1 = bits(io.value, 7, 4) @[DisplayMultiplexer.scala 40:36]
        sevenSegDec.io.in <= _sevenSegDec_io_in_T_1 @[DisplayMultiplexer.scala 40:25]
        select <= UInt<2>("h2") @[DisplayMultiplexer.scala 41:14]
      else :
        node _T_2 = eq(UInt<2>("h2"), digitReg) @[DisplayMultiplexer.scala 34:20]
        when _T_2 : @[DisplayMultiplexer.scala 34:20]
          node _sevenSegDec_io_in_T_2 = bits(io.value, 11, 8) @[DisplayMultiplexer.scala 44:36]
          sevenSegDec.io.in <= _sevenSegDec_io_in_T_2 @[DisplayMultiplexer.scala 44:25]
          select <= UInt<3>("h4") @[DisplayMultiplexer.scala 45:14]
        else :
          node _T_3 = eq(UInt<2>("h3"), digitReg) @[DisplayMultiplexer.scala 34:20]
          when _T_3 : @[DisplayMultiplexer.scala 34:20]
            node _sevenSegDec_io_in_T_3 = bits(io.value, 15, 12) @[DisplayMultiplexer.scala 48:36]
            sevenSegDec.io.in <= _sevenSegDec_io_in_T_3 @[DisplayMultiplexer.scala 48:25]
            select <= UInt<4>("h8") @[DisplayMultiplexer.scala 49:14]
    sevSeg <= sevenSegDec.io.out @[DisplayMultiplexer.scala 53:10]
    node _io_display_segments_T = not(sevSeg) @[DisplayMultiplexer.scala 55:26]
    io.display.segments <= _io_display_segments_T @[DisplayMultiplexer.scala 55:23]
    node _io_display_selector_T = not(select) @[DisplayMultiplexer.scala 56:26]
    io.display.selector <= _io_display_selector_T @[DisplayMultiplexer.scala 56:23]

  module Elidon :
    input clock : Clock
    input reset : UInt<1>
    output io : { leds : UInt<16>, display : { segments : UInt<7>, selector : UInt<4>}, flip switches : UInt<16>}

    inst fetchStage of FetchStage @[Main.scala 15:26]
    fetchStage.clock <= clock
    fetchStage.reset <= reset
    inst decodeStage of DecodeStage @[Main.scala 16:27]
    decodeStage.clock <= clock
    decodeStage.reset <= reset
    inst executeStage of ExecuteStage @[Main.scala 17:28]
    executeStage.clock <= clock
    executeStage.reset <= reset
    inst memoryStage of MemoryStage @[Main.scala 18:27]
    memoryStage.clock <= clock
    memoryStage.reset <= reset
    decodeStage.io.f2d.instruction <= fetchStage.io.f2d.instruction @[Main.scala 21:22]
    decodeStage.io.f2d.pc <= fetchStage.io.f2d.pc @[Main.scala 21:22]
    executeStage.io.d2e.rs2 <= decodeStage.io.d2e.rs2 @[Main.scala 22:23]
    executeStage.io.d2e.rs1 <= decodeStage.io.d2e.rs1 @[Main.scala 22:23]
    executeStage.io.d2e.instruction <= decodeStage.io.d2e.instruction @[Main.scala 22:23]
    executeStage.io.d2e.pc <= decodeStage.io.d2e.pc @[Main.scala 22:23]
    memoryStage.io.e2m.load <= executeStage.io.e2m.load @[Main.scala 23:22]
    memoryStage.io.e2m.store <= executeStage.io.e2m.store @[Main.scala 23:22]
    memoryStage.io.e2m.writeBack <= executeStage.io.e2m.writeBack @[Main.scala 23:22]
    memoryStage.io.e2m.rdAdressOrStoreValue <= executeStage.io.e2m.rdAdressOrStoreValue @[Main.scala 23:22]
    memoryStage.io.e2m.resultOrAdress <= executeStage.io.e2m.resultOrAdress @[Main.scala 23:22]
    decodeStage.io.m2w.writeBack <= memoryStage.io.m2w.writeBack @[Main.scala 24:22]
    decodeStage.io.m2w.rdAdress <= memoryStage.io.m2w.rdAdress @[Main.scala 24:22]
    decodeStage.io.m2w.rd <= memoryStage.io.m2w.rd @[Main.scala 24:22]
    fetchStage.io.branch.pc <= executeStage.io.branch.pc @[Main.scala 27:24]
    fetchStage.io.branch.enable <= executeStage.io.branch.enable @[Main.scala 27:24]
    inst dataMemory of DataMemory @[Main.scala 30:26]
    dataMemory.clock <= clock
    dataMemory.reset <= reset
    memoryStage.io.data <= dataMemory.io.data @[Main.scala 31:23]
    dataMemory.io.switches <= io.switches @[Main.scala 34:26]
    io.leds <= dataMemory.io.leds @[Main.scala 35:11]
    inst displayMultiplexer of DisplayMultiplexer @[Main.scala 36:34]
    displayMultiplexer.clock <= clock
    displayMultiplexer.reset <= reset
    displayMultiplexer.io.value <= dataMemory.io.displayValue @[Main.scala 37:31]
    io.display <= displayMultiplexer.io.display @[Main.scala 38:14]

