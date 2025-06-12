//-----------------------------------------------------------------------------
// Title       : Reset UVC Package
// Project     : FIFO Dual Clock
//-----------------------------------------------------------------------------
// File        : reset_pkg.sv
// Author      : User
// Created     : 2025-05-06
// Description : Package for Reset Universal Verification Component
//-----------------------------------------------------------------------------

package reset_pkg;

    // Import standard UVM packages
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Include files for the reset UVC components
    `include "reset_item.svh"
    `include "reset_sequencer.svh"
    `include "reset_driver.svh"
    `include "reset_monitor.svh"
    `include "reset_agent.svh"
    `include "reset_sequence.svh"
    
endpackage : reset_pkg

