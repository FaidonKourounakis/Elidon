import chisel3._
import chisel3.util._

class FetchStage extends Module {
  // val io = IO(new Bundle {
  // })
  val instructionMemory = Module(new InstructionMemory)
}