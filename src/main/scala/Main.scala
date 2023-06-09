import chisel3._
import chisel3.util._

// Integer power function, usefull,,,
object pow {
  def apply(a: Int, b: Int): Int = {
    var base = a
    var exp = b
    var result = 1
    while (exp > 0) {
      if ((exp & 1) == 1) result = result * base
      base = base * base
      exp = exp / 2
    }
    result
  }
}

class Elidon(filename: String) extends Module {
  val io = IO(new Bundle {
    val leds = Output(UInt(16.W))
    val display = new Bundle {
      val segments = Output(UInt(7.W))
      val selector = Output(UInt(4.W))
    }
    val switches = Input(UInt(16.W))
  })

  // Initialise Pipeline Stages
  val fetchStage = Module(new FetchStage(filename))
  val decodeStage = Module(new DecodeStage)
  val executeStage = Module(new ExecuteStage)
  val memoryStage = Module(new MemoryStage)

  // Connect stage pipelines:
  decodeStage.io.f2d := fetchStage.io.f2d
  executeStage.io.d2e := decodeStage.io.d2e 
  memoryStage.io.e2m := executeStage.io.e2m 
  decodeStage.io.m2w := memoryStage.io.m2w 

  // Connect other stage communications
  fetchStage.io.branch := executeStage.io.branch

  // Initialise communication of Memory stage with data segment
  val dataMemory = Module(new DataMemory)
  memoryStage.io.data <> dataMemory.io.data
  
  // Connect data memory segment to board IO:
  dataMemory.io.switches := io.switches
  io.leds := dataMemory.io.leds
  val displayMultiplexer = Module(new DisplayMultiplexer)
  displayMultiplexer.io.value := dataMemory.io.displayValue
  io.display := displayMultiplexer.io.display
}

// To run do
// > sbt "run filename"
// where filename is the path to the instruction 
object Main extends App {
  val filename = if (args.length > 0) args(0) else "test"
  println("************************************************")
  println("    Generating hardware for Elidon processor")
  println("    Machine code loaded: " + filename)
  println("****************************************")
  (new chisel3.stage.ChiselStage).emitVerilog(new Elidon(filename))
}