# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_dummy(dut):    
    # Start the clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the design
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    
    await ClockCycles(dut.clk, 10)

# def start_clock(dut):
#     cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

# async def reset_dut(dut):
#     dut.ena.value    = 1
#     dut.ui_in.value  = 0
#     dut.uio_in.value = 0
#     dut.rst_n.value  = 0
#     await RisingEdge(dut.clk)
#     dut.rst_n.value  = 1

# async def press(dut):
#     # btn_up to 1
#     await FallingEdge(dut.clk)
#     dut.ui_in.value = dut.ui_in.value | 0x01
#     # Wait a cycle for 2-FF sync
#     await RisingEdge(dut.clk)

# async def release(dut):
#     # btn_up to 0
#     await FallingEdge(dut.clk)
#     dut.ui_in.value = dut.ui_in.value & ~0x01

#     await RisingEdge(dut.clk)
#     await RisingEdge(dut.clk)
#     await ReadOnly()

# async def trigger_tick(dut):
#     # Make a tick trigger
#     await FallingEdge(dut.clk)
#     dut.morse_code.chip_interface.counts.count.value = 24_999_998
#     await RisingEdge(dut.clk)  # count at 24_999_999
#     await RisingEdge(dut.clk)  # tick = 1

# async def do_ticks(dut, n):
#     for _ in range(n):
#         await trigger_tick(dut)
#         await RisingEdge(dut.clk)

# # Pushes button, holds, and releases
# async def press_and_release(dut, hold_ticks, expect_dah):
#     await press(dut)
#     await do_ticks(dut, hold_ticks)
#     await release(dut)

#     assert dut.morse_code.chip_interface.end_of_ditdah.value == 1, \
#         f"end_of_ditdah should be high on release, got {dut.morse_code.chip_interface.end_of_ditdah.value}"
#     assert dut.morse_code.chip_interface.dah.value == int(expect_dah), \
#         f"dah: expected {int(expect_dah)}, got {dut.morse_code.chip_interface.dah.value}"

#     # end_of_ditdah should go low the next cycle
#     await RisingEdge(dut.clk)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_ditdah.value == 0, \
#         f"end_of_ditdah should be LOW after pulse, got {dut.morse_code.chip_interface.end_of_ditdah.value}"


# @cocotb.test()
# # 1 tick press is a dit
# async def test_counting_dit_1_tick(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await press_and_release(dut, hold_ticks=1, expect_dah=False)

# @cocotb.test()
# # 2 tick press is a dit
# async def test_counting_dit_2_ticks(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await press_and_release(dut, hold_ticks=2, expect_dah=False)

# @cocotb.test()
# # 3 tick press is a dah
# async def test_counting_dah_3_ticks(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await press_and_release(dut, hold_ticks=3, expect_dah=True)

# @cocotb.test()
# # 5 tick press is a dah
# async def test_counting_dah_5_ticks(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await press_and_release(dut, hold_ticks=5, expect_dah=True)

# @cocotb.test()
# async def test_counting_end_of_letter(dut):
#     # End of letter should pulse for one clock cycle
#     start_clock(dut)
#     await reset_dut(dut)

#     await press_and_release(dut, hold_ticks=1, expect_dah=False)

#     # end_of_letter should be low for 3 ticks
#     for i in range(1, 4):
#         await trigger_tick(dut)
#         await ReadOnly()
#         assert dut.morse_code.chip_interface.end_of_letter.value == 0, \
#             f"end_of_letter should be low at tick {i}, got {dut.morse_code.chip_interface.end_of_letter.value}"
#         await RisingEdge(dut.clk) 

#     # end of letter goes high at tick 4
#     await trigger_tick(dut)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_letter.value == 1, \
#         f"end_of_letter should be high at tick 4, got {dut.morse_code.chip_interface.end_of_letter.value}"

#     await RisingEdge(dut.clk)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_letter.value == 0, \
#         f"end_of_letter should be low after pulse, got {dut.morse_code.chip_interface.end_of_letter.value}"

# @cocotb.test()
# async def test_counting_end_of_word(dut):
#     # end of word should pulse at tick 8

#     start_clock(dut)
#     await reset_dut(dut)

#     await press_and_release(dut, hold_ticks=1, expect_dah=False)

#     for i in range(1, 8):
#         await trigger_tick(dut)
#         await ReadOnly()
#         assert dut.morse_code.chip_interface.end_of_word.value == 0, \
#             f"end_of_word should be low at tick {i}, got {dut.morse_code.chip_interface.end_of_word.value}"
#         await RisingEdge(dut.clk)

#     await trigger_tick(dut)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_word.value == 1, \
#         f"end_of_word should be high at tick 8, got {dut.morse_code.chip_interface.end_of_word.value}"
#     assert dut.morse_code.chip_interface.end_of_letter.value == 0, \
#         f"end_of_letter should be low at tick 8, got {dut.morse_code.chip_interface.end_of_letter.value}"

#     await RisingEdge(dut.clk)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_word.value == 0, \
#         f"end_of_word should be low after pulse, got {dut.morse_code.chip_interface.end_of_word.value}"


# # Hold for one tick then release
# async def send_dit(dut):
#     await press(dut)
#     await trigger_tick(dut)
#     await RisingEdge(dut.clk) 
#     await release(dut)
#     await RisingEdge(dut.clk)

# # Hold for three ticks then release
# async def send_dah(dut):
#     await press(dut)
#     await trigger_tick(dut)
#     await RisingEdge(dut.clk)
#     await trigger_tick(dut)
#     await RisingEdge(dut.clk)
#     await trigger_tick(dut)
#     await RisingEdge(dut.clk)
#     await release(dut)
#     await RisingEdge(dut.clk)

# # Wait for 4 ticks to send EOL
# async def send_eol(dut):
#     for _ in range(3):
#         await trigger_tick(dut)
#         await RisingEdge(dut.clk)

#     await trigger_tick(dut)
#     await ReadOnly()
#     assert dut.morse_code.chip_interface.end_of_letter.value == 1, \
#         "send_eol: end_of_letter did not fire on tick 4"
#     await RisingEdge(dut.clk)

# # Look at letter 1 and see if it was translated as expected
# async def check_letter(dut, name, expected):
#     await RisingEdge(dut.clk)
#     await ReadOnly()
#     got = int(dut.uo_out.value & 0x7F)
#     assert got == expected, \
#         f"Letter '{name}': expected {expected:07b}, got {got:07b}"


# # Testing A .-
# @cocotb.test()
# async def test_translation_A(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dit(dut)
#     await send_dah(dut)
#     await send_eol(dut)
#     await check_letter(dut, "A", 0b1110111)

# # Testing B -..
# @cocotb.test()
# async def test_translation_B(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dah(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_eol(dut)
#     await check_letter(dut, "B", 0b0011111)

# # Testing S ...
# @cocotb.test()
# async def test_translation_S(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_eol(dut)
#     await check_letter(dut, "S", 0b1011011)

# # Testing O ---
# @cocotb.test()
# async def test_translation_O(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dah(dut)
#     await send_dah(dut)
#     await send_dah(dut)
#     await send_eol(dut)
#     await check_letter(dut, "O", 0b0011101)

# # Testing E .
# @cocotb.test()
# async def test_translation_E(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dit(dut)
#     await send_eol(dut)
#     await check_letter(dut, "E", 0b1001111)

# # Testing T -
# @cocotb.test()
# async def test_translation_T(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dah(dut)
#     await send_eol(dut)
#     await check_letter(dut, "T", 0b0001111)

# # Testing Y -.--
# @cocotb.test()
# async def test_translation_Y(dut):
#     start_clock(dut)
#     await reset_dut(dut)
#     await send_dah(dut)
#     await send_dit(dut)
#     await send_dah(dut)
#     await send_dah(dut)
#     await send_eol(dut)
#     await check_letter(dut, "Y", 0b0111011)

# # Sending a word SOS ...---...
# @cocotb.test()
# async def test_translation_SOS(dut):
#     start_clock(dut)
#     await reset_dut(dut)

#     await send_dit(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_eol(dut)
#     await check_letter(dut, "S", 0b1011011)

#     await send_dah(dut)
#     await send_dah(dut)
#     await send_dah(dut)
#     await send_eol(dut)
#     await check_letter(dut, "O", 0b0011101)

#     await send_dit(dut)
#     await send_dit(dut)
#     await send_dit(dut)
#     await send_eol(dut)
#     await check_letter(dut, "S", 0b1011011)