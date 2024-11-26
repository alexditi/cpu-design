onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb/clk
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb/rst
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb/dut/program_storage/AddrIn
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb/dut/program_storage/DataOut
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb/dut/decode/Instruction
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb/dut/decode/RdOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb/dut/decode/RsOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb/dut/decode/DataImmediate
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb/dut/decode/InstAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb/dut/decode/InstOffsetOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb/dut/decode/DataAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb/dut/decode/DataOffsetOut
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb/OpcodeIn
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb/ConditionIn
add wave -noupdate -expand -group {Control Logic In} /cpu_control_simulation_tb/ConditionSign
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/PrStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/PCload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/PCldInBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/PCldOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/PCselOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/IRload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/RegFileLoad
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/AluOpSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/RegFIleDataSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/SPinc
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/SPdec
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/DataStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/DataStrInSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb/DataStrLoad
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb/dut/execute/ALUout
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb/dut/execute/RegFileDataIn
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb/dut/execute/register_file/Data
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb/dut/data_storage/AddrIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb/dut/data_storage/DataIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb/dut/data_storage/DataOut
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb/dut/data_storage/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 344
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {804 ns}
