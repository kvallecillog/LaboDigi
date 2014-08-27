/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_16144660126055455566_0317860448_init();
    work_m_16244706123820388422_1260173457_init();
    work_m_00250593118066231081_1201854419_init();
    work_m_13242391307574169155_0988927962_init();
    work_m_08685086987533638483_0936592367_init();
    work_m_17508204853425943509_0924759715_init();
    work_m_16541823861846354283_2073120511_init();


    xsi_register_tops("work_m_17508204853425943509_0924759715");
    xsi_register_tops("work_m_16541823861846354283_2073120511");


    return xsi_run_simulation(argc, argv);

}
