import chisel3._
import chisel3.util._

class DataMemory extends Module {
  val io = IO(new Bundle {
    val data = new Bundle {
      val readAdress = Input(UInt(16.W))
      val writeAdress = Input(UInt(16.W))
      val writeEnable = Input(Bool())
      val writeValue = Input(UInt(16.W))
      val readValue = Output(UInt(16.W))
    }
    
    val leds = Output(UInt(16.W))
    val displayValue = Output(UInt(16.W))
    val switches = Input(UInt(16.W))
  })

  /********************************************************
  * We split the memory into 2 parts because we want to handle
  * 16 bit words, with byte adressing and also missaligned adresses
  ********************************************************/
  val evenMem = SyncReadMem(2^15, UInt(8.W))
  val oddMem = SyncReadMem(2^15, UInt(8.W))

  /********************************************************
  * Read Functionality
  ********************************************************/
  class ReadBundle extends Bundle {
    val msB = UInt(8.W)
    val lsB = UInt(8.W)
  }

  val readBundle = Wire(new ReadBundle)
  val readAdressOdd = WireDefault(io.data.readAdress(15,1))
  val readAdressEven = Wire(UInt(15.W))

  when(io.data.readAdress(0)) {
    readAdressEven := readAdressOdd + 1.U
    readBundle.msB := evenMem.read(readAdressOdd)
    readBundle.lsB := oddMem.read(readAdressEven)
  } .otherwise {
    readAdressEven := readAdressOdd
    readBundle.msB := evenMem.read(readAdressEven)
    readBundle.lsB := oddMem.read(readAdressOdd)
  }

  class WriteBundle extends Bundle {
    val even = UInt(8.W)
    val odd = UInt(8.W)
  }

  /********************************************************
  * Write Functionality
  ********************************************************/
  val writeBundle = Wire(new WriteBundle)
  val writeAdressOdd = WireDefault(io.data.writeAdress(15,1))
  val writeAdressEven = Wire(UInt(15.W))

  when(io.data.writeAdress(0)) {
    writeAdressEven := writeAdressOdd + 1.U
    writeBundle.even := io.data.writeValue(7, 0)
    writeBundle.odd := io.data.writeValue(15, 8)
  } .otherwise {
    writeAdressEven := writeAdressOdd
    writeBundle.even := io.data.writeValue(15, 8)
    writeBundle.odd := io.data.writeValue(7, 0)
  }

  when(io.data.writeEnable) {
    evenMem.write(writeAdressEven, writeBundle.even)
    oddMem.write(writeAdressOdd, writeBundle.odd)
  }


  /********************************************************
  * Add IO functionality:
  * Bytes 0, 1: LEDs
  * Bytes 2, 3: Hex values of 7-segment display
  * Bytes 4, 5: Input from switches
  ********************************************************/
  // Store the values in registers
  val ledsReg = RegInit(0.U(16.W))
  val displayValueReg = RegInit(0.U(16.W))
  val switchesReg = RegNext(io.switches)

  // Connect with IO
  io.leds := ledsReg
  io.displayValue := displayValueReg

  // Set leds and displayValue on write
  // They can only be set when adress is aligned
  when(io.data.writeEnable) {
    when(io.data.writeAdress === 0.U) {
      ledsReg := io.data.writeValue
    }
    when(io.data.writeAdress === 2.U) {
      displayValueReg := io.data.writeValue
    }
  } 

  /********************************************************
  * Final read functionality
  ********************************************************/

  when(io.data.readAdress === 4.U) {  // Switches's value is only acessed when it's aligned:
    io.data.readValue := switchesReg
  } .elsewhen(io.data.readAdress === io.data.writeAdress) { // Forward value if adresses same
    io.data.readValue := io.data.writeValue
  } .otherwise {
    io.data.readValue := readBundle.asUInt // Otherwise get it from memory
  }
}