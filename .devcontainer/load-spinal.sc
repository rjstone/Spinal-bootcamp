import $ivy.`com.github.spinalhdl::spinalhdl-core:1.12.2`
import $ivy.`com.github.spinalhdl::spinalhdl-lib:1.12.2`
import $plugin.$ivy.`com.github.spinalhdl::spinalhdl-idsl-plugin:1.12.2`

import spinal.core._
import spinal.lib._
import spinal.core.sim._

implicit class SpinalReportExtend(sp :SpinalReport[Component]) {
  def getRtlString_local(): String = {
    assert(sp.generatedSourcesPaths.size > 0)
    scala.io.Source.fromFile(sp.generatedSourcesPaths.head).mkString
  }
}

val spcfg = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      clockEdge = RISING,
      resetKind = ASYNC,
      resetActiveLevel = LOW
    ),
    headerWithDate = true,
    removePruned = false,
    anonymSignalPrefix = "t",
    mergeAsyncProcess  = true,
    targetDirectory = "rtl/"
  )

def showRtl(dut: => Component, mode: SpinalMode = `Verilog`) = {
  println(spcfg.copy(mode = mode).generate(dut).getRtlString_local)
}

def showVhdl(dut: => Component) = showRtl(dut, VHDL)

@deprecated("Deprecated, showRtl is recommended", "spinal-bootcamp 0.1.0")
def showVerilog(dut: => Component, moduleName: String) = {
  spcfg.copy(mode = Verilog).generate(dut)
  println(scala.io.Source.fromFile("rtl/"+moduleName+".v").mkString)
}

