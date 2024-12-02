onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb_1/clk
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb_1/rst
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_1/dut/program_storage/AddrIn
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_1/dut/program_storage/DataOut
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_1/dut/decode/Instruction
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_1/dut/decode/RdOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_1/dut/decode/RsOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_1/dut/decode/DataImmediate
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_1/dut/decode/InstAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_1/dut/decode/InstOffsetOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_1/dut/decode/DataAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_1/dut/decode/DataOffsetOut
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb_1/OpcodeIn
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb_1/ConditionIn
add wave -noupdate -expand -group {Control Logic In} /cpu_control_simulation_tb_1/ConditionSign
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/PrStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/PCload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/PCldInBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/PCldOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/PCselOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/IRload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/RegFileLoad
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/AluOpSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/RegFIleDataSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/SPinc
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/SPdec
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/DataStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/DataStrInSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_1/DataStrLoad
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_1/dut/execute/ALUout
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_1/dut/execute/RegFileDataIn
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_1/dut/execute/register_file/Data
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_1/dut/data_storage/AddrIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_1/dut/data_storage/DataIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_1/dut/data_storage/DataOut
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_1/dut/data_storage/ram
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
