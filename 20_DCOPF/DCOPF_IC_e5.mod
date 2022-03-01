# DCOPF example 
# by Xingpeng.Li
# run command: include fileName.mod; e.g. include DCOPF_IC_e5.mod;

# Use reset to clear memory for AMPL
reset;

# Declare parameters
param c1; let c1 := 50;
param Pgmin1; let Pgmin1 := 30;
param Pgmax1; let Pgmax1 := 80;
param Pg_ramp1; let Pg_ramp1 := 1; # 1 MW/min
param Pg1_init; let Pg1_init := 30;

param c3; let c3 := 10;
param Pgmin3; let Pgmin3 := 20;
param Pgmax3; let Pgmax3 := 90;
param Pg_ramp3; let Pg_ramp3 := 1; # 1 MW/min
param Pg3_init; let Pg3_init := 70;

#param Load2_init = 100;
param Load2 = 107;
param deltaT = 5; # 5 minutes

# param branchRate1; let branchRate1 := 10000;  # assume infinite capacity

# Declare Variables
var G1;
var G3;
var pk1;

# Define objective function
minimize obj: c1*G1 + c3*G3;

# Define constraints
subject to SysWidePowerBalance: G1 + G3 = Load2;
subject to genLimit_1: Pgmin1 <= G1 <= Pgmax1;
subject to genLimit_3: Pgmin3 <= G3 <= Pgmax3;

subject to genRampLimit_1: -Pg_ramp1*deltaT <= (G1 - Pg1_init) <= Pg_ramp1*deltaT;
subject to genRampLimit_3_1: Pg3_init - Pg_ramp3*deltaT <= G3;
subject to genRampLimit_3_2: G3 <= Pg3_init + Pg_ramp3*deltaT;

# Solver setting
option solver gurobi;
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display G1, G3;






