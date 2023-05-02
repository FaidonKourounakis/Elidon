import chisel3._
import chisel3.util._

class InstructionMemory extends Module {
  val io = IO(new Bundle {
    val pc = Input(UInt(8.W))
    val instruction = Output(UInt(16.W))
  })

  // TODO: Assemble and get instruction machine code
  // Current machine code: 20 nop (add zero zero zero)
  val machineCode = Array.fill(20)(0x8000)
  val rom = VecInit(machineCode.map(_.U(16.W)))
  io.instruction := rom(io.pc(7, 1));
}