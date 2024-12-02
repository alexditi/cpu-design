onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb_2/clk
add wave -noupdate -expand -group {CPU Commons} /cpu_control_simulation_tb_2/rst
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_2/dut/program_storage/AddrIn
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_2/dut/program_storage/DataOut
add wave -noupdate -expand -group Fetch /cpu_control_simulation_tb_2/dut/decode/Instruction
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_2/dut/decode/RdOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_2/dut/decode/RsOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_2/dut/decode/DataImmediate
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_2/dut/decode/InstAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_2/dut/decode/InstOffsetOut
add wave -noupdate -expand -group {Decode Out} /cpu_control_simulation_tb_2/dut/decode/DataAddrOut
add wave -noupdate -expand -group {Decode Out} -radix decimal /cpu_control_simulation_tb_2/dut/decode/DataOffsetOut
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb_2/OpcodeIn
add wave -noupdate -expand -group {Control Logic In} -radix binary /cpu_control_simulation_tb_2/ConditionIn
add wave -noupdate -expand -group {Control Logic In} /cpu_control_simulation_tb_2/ConditionSign
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/PrStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/PCload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/PCldInBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/PCldOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/PCselOutBuf
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/IRload
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/RegFileLoad
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/AluOpSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/RegFIleDataSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/SPinc
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/SPdec
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/DataStrAddrSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/DataStrInSel
add wave -noupdate -expand -group Steuersignale /cpu_control_simulation_tb_2/DataStrLoad
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_2/dut/execute/ALUout
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_2/dut/execute/RegFileDataIn
add wave -noupdate -expand -group Execute /cpu_control_simulation_tb_2/dut/execute/register_file/Data
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_2/dut/data_storage/AddrIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_2/dut/data_storage/DataIn
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_2/dut/data_storage/DataOut
add wave -noupdate -expand -group Writeback /cpu_control_simulation_tb_2/dut/data_storage/ram
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
