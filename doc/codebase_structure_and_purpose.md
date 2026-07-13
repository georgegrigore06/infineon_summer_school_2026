# Code Base Structure and Purpose

This document lists the workspace folders and files that are relevant to the verification training, excluding `.dvt/` and everything under `source/v/rtl/` as requested.

## Workspace Root

- `ifx_summer_school_2026/` - Root training workspace containing documentation, simulation scripts, and verification sources.
- `READ.md` - Top-level quick-start guide for running the simulation flows in this workspace.

## `doc/`

Documentation and training material for the lab.

- `IFRO_SS_DESIGN.pdf` - Design reference document that describes the training DUT and project context.
- `codebase_structure_and_purpose.md` - Inventory of the workspace structure and the role of each non-RTL file and folder.
- `ver_handbook.pdf` - Verification handbook with the original course guidance and day-by-day exercises.

## `simulation/`

Launch scripts and command files for simulation.

### `simulation/rtl_sim/`

RTL-oriented simulation flow used for the design-side environment.

- `Makefile` - Helper target for cleaning generated simulation artifacts.
- `run.args` - Xcelium arguments for compiling the RTL testbench layout.
- `run.sh` - Shell wrapper that prepares the environment and launches the RTL simulation.

### `simulation/sv_sim/`

SystemVerilog/UVM verification simulation flow.

- `run.args` - Xcelium arguments for compiling the UVM testbench, environment, and top module.
- `run.py` - Python wrapper that prepares the environment and launches UVM simulation or IMC.

## `source/`

Source tree for verification assets and Verilog-side project layout.

### `source/sv/`

SystemVerilog verification sources.

#### `source/sv/timer_tb/`

Timer/counter verification environment.

- `include/` - Shared includes for the environment, tests, register model, and reusable UVC blocks.
- `tb/` - Top-level testbench files that connect the DUT, interfaces, and UVM components.

##### `source/sv/timer_tb/tb/`

Top-level testbench entry points.

- `ifx_dig_interface.sv` - DUT-facing interface that exposes the clock, reset, bus, inputs, and output to the testbench.
- `ifx_dig_top.sv` - UVM top module that instantiates the DUT and connects the verification interfaces.

##### `source/sv/timer_tb/include/`

Shared include files used by the verification environment.

- `addons/` - Reusable verification components added to the environment.
- `env/` - Core environment, golden model, scoreboard, register model, and shared definitions.
- `tests/` - Base test infrastructure, helper sequences, and concrete mode tests.

###### `source/sv/timer_tb/include/addons/`

Reusable verification add-ons.

- `ifx_dig_data_bus_uvc/` - Data bus UVC used to drive register transactions into the DUT.

####### `source/sv/timer_tb/include/addons/ifx_dig_data_bus_uvc/`

Data bus UVC implementation.

- `ifx_dig_data_bus_uvc_agent.svh` - UVC agent that combines sequencer, driver, and monitor.
- `ifx_dig_data_bus_uvc_config.svh` - Configuration object for the data bus UVC.
- `ifx_dig_data_bus_uvc_driver.svh` - Driver that converts sequence items into bus activity.
- `ifx_dig_data_bus_uvc_monitor.svh` - Monitor that observes bus activity and publishes transactions.
- `ifx_dig_data_bus_uvc_pkg_and_if/` - Package and interface wrapper for the UVC.
- `ifx_dig_data_bus_uvc_seq_item.svh` - Transaction object used by the UVC sequences.
- `ifx_dig_data_bus_uvc_sequence_lib.svh` - Library of write, read, and composed sequences for bus access.
- `ifx_dig_data_bus_uvc_sequencer.svh` - Sequencer that launches and arbitrates UVC transactions.
- `ifx_dig_data_bus_uvc_typedef.svh` - Shared UVC type definitions and constants.

######## `source/sv/timer_tb/include/addons/ifx_dig_data_bus_uvc/ifx_dig_data_bus_uvc_pkg_and_if/`

Package and interface wrapper for the data bus UVC.

- `ifx_dig_data_bus_uvc_interface.sv` - Interface that connects the UVC to the DUT communication signals.
- `ifx_dig_data_bus_uvc_pkg.sv` - Package that collects the UVC classes and interface dependencies.

###### `source/sv/timer_tb/include/env/`

Core verification environment, golden model, and register abstraction.

- `ifx_dig_checkers.svh` - Checker routines used by the scoreboard to validate observed behavior.
- `ifx_dig_config.svh` - Environment configuration object that carries virtual interfaces and test settings.
- `ifx_dig_coverage.svh` - Functional coverage definitions for the verification goals.
- `ifx_dig_defines.svh` - Global macros for bus widths, addresses, and shared constants.
- `ifx_dig_env.svh` - UVM environment class that builds and connects the scoreboard and data bus UVC agent.
- `ifx_dig_golden_model.svh` - Golden model that mirrors configuration, predicts behavior, and drives expected events.
- `ifx_dig_pin_toggle.svh` - Sequence item that stores a pin index, toggle count, and half-period for pulse generation.
- `ifx_dig_pkg.sv` - Main environment package that imports and includes the verification support files.
- `ifx_dig_scoreboard.svh` - Scoreboard that receives bus transactions and compares them against the model.
- `ifx_dig_types.svh` - Shared enums and types used throughout the testbench.
- `registers/` - Register model classes used by the scoreboard and helper tasks.

####### `source/sv/timer_tb/include/env/registers/`

Register abstraction layer for the DUT register map.

- `ifx_dig_field.svh` - Field abstraction used to represent bit fields inside a register.
- `ifx_dig_regblock.svh` - Register-block container that owns all modeled registers and helper access functions.
- `ifx_dig_regblock_pkg.sv` - Package that exposes the register-block classes.
- `ifx_dig_registers.svh` - Individual register classes that define the modeled register map.

###### `source/sv/timer_tb/include/tests/`

Reusable testbase, helper sequences, and concrete verification tests.

- `ifx_dig_counter_mode_test.svh` - Directed test that configures and exercises counter mode.
- `ifx_dig_sequences.svh` - Scaffold for a pin-toggle sequence that will generate counting-input stimulus.
- `ifx_dig_test_pkg.sv` - Package that imports and exposes the available test classes.
- `ifx_dig_testbase.svh` - Common UVM test base with helper tasks for reset, input pulses, and register access.

### `source/v/`

Verilog-side project area kept for the design-time testbench layout.

- `tb/` - Empty placeholder for future Verilog-side testbench material.
- `rtl/` - Excluded from this document as requested.
