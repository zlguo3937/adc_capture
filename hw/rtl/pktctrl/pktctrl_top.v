// Copyright (c) 2024 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-05-06    zlguo         1.0         pktctrl_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module pktctrl_top
(

);

    wire    [9*96-1:0] data_in;

    package_ctrl
    u_package_ctrl
    (

    );

    mdio_adc_data_ctrl
    u_mdio_adc_data_ctrl
    (

    );

    package_gen
    u_package_gen
    (

    );

    memory_ctrl
    u_memory_ctrl
    (
    .data_in    (data_in    )
    );

    adc_data_sel
    u_adc_data_sel
    (
    .data_in    (data_in    )
    );

endmodule
