// SYNOPSYS CONFIDENTIAL -- This is an unpublished, proprietary work
// of Synopsys, Inc., and is fully protected under copyright and trade
// secret laws. You may not view, use, disclose, copy, or distribute
// this file or any information contained herein except pursuant to a
// valid written license from Synopsys.

//=====================================================================
// Copyright (C) 1997-1999 Synopsys Inc. All Rights Reserved.
// ====================================================================

import "DPI-C" function int  vc_uvmOnewayHash ( string string_in, int  seed );
import "DPI-C" function int vc_uvmCreateRandomSeed (string string_in, int  seed);
import "DPI-C" function void vc_uvmReseed ();
