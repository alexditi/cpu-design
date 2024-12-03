onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CPU Commons} /cpu_embedded_tb/clk
add wave -noupdate -expand -group {CPU Commons} /cpu_embedded_tb/rst
add wave -noupdate -expand -group Fetch /cpu_embedded_tb/dut/cpu/fetch/AddrInputBuffer
add wave -noupdate -expand -group Fetch /cpu_embedded_tb/dut/cpu/fetch/input_buffer/dataOut
add wave -noupdate -expand -group Fetch /cpu_embedded_tb/dut/cpu/fetch/PrStrAddrIn
add wave -noupdate -expand -group Fetch /cpu_embedded_tb/dut/cpu/fetch/PrStrDataOut
add wave -noupdate -expand -group Fetch /cpu_embedded_tb/dut/cpu/fetch/PCout
add wave -noupdate -expand -group Decode /cpu_embedded_tb/dut/cpu/decode/Instruction
add wave -noupdate -expand -group Decode -radix binary /cpu_embedded_tb/dut/cpu/decode/Opcode
add wave -noupdate -expand -group Decode -radix unsigned /cpu_embedded_tb/dut/cpu/decode/RdOut
add wave -noupdate -expand -group Decode -radix unsigned /cpu_embedded_tb/dut/cpu/decode/RsOut
add wave -noupdate -expand -group Decode /cpu_embedded_tb/dut/cpu/decode/DataImmediate
add wave -noupdate -expand -group Decode /cpu_embedded_tb/dut/cpu/decode/InstAddrOut
add wave -noupdate -expand -group Decode -radix decimal /cpu_embedded_tb/dut/cpu/decode/InstOffsetOut
add wave -noupdate -expand -group Decode /cpu_embedded_tb/dut/cpu/decode/DataAddrOut
add wave -noupdate -expand -group Decode -radix decimal /cpu_embedded_tb/dut/cpu/decode/DataOffsetOut
add wave -noupdate -expand -group {Control Logic} -radix binary /cpu_embedded_tb/dut/cpu/control_logic/OpcodeIn
add wave -noupdate -expand -group {Control Logic} -radix binary /cpu_embedded_tb/dut/cpu/control_logic/ConditionIn
add wave -noupdate -expand -group {Control Logic} /cpu_embedded_tb/dut/cpu/control_logic/ConditionSign
add wave -noupdate -expand -group {Control Logic} /cpu_embedded_tb/dut/cpu/control_logic/SCRout
add wave -noupdate -expand -group {Control Logic} /cpu_embedded_tb/dut/cpu/control_logic/Cycle2active
add wave -noupdate -expand -group {Control Logic} /cpu_embedded_tb/dut/cpu/control_logic/takeBranch
add wave -noupdate -expand -group {Internal Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/set2ndCycle
add wave -noupdate -expand -group {Internal Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/SFRldFlags
add wave -noupdate -expand -group {Internal Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/SFRldCB
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/PrStrAddrSel
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/PCload
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/PCldInBuf
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/PCldOutBuf
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/PCselOutBuf
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/IRload
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/RegFileLoad
add wave -noupdate -expand -group {Control Signals} -radix binary /cpu_embedded_tb/dut/cpu/control_logic/AluOpSel
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/RegFIleDataSel
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/SPdec
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/SPinc
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/DataStrAddrSel
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/DataStrInSel
add wave -noupdate -expand -group {Control Signals} /cpu_embedded_tb/dut/cpu/control_logic/DataStrLoad
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/ALUout
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/alu/carryOut
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/alu/overflow
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/alu/negative
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/alu/sign
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/alu/zero
add wave -noupdate -expand -group Execute /cpu_embedded_tb/dut/cpu/execute/RegFileDataIn
add wave -noupdate -expand -group Execute -expand /cpu_embedded_tb/dut/cpu/execute/register_file/Data
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/cpu/writeback/DataStrAddressIn
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/cpu/writeback/DataStrIn
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/cpu/writeback/DataStrOut
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/cpu/writeback/stackpointer/SP
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(0)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(1)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(2)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(3)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(5)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(6)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(252)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(253)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(254)
add wave -noupdate -expand -group Writeback /cpu_embedded_tb/dut/data_storage/ram(255)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
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
WaveRestoreZoom {0 ns} {1085 ns}
