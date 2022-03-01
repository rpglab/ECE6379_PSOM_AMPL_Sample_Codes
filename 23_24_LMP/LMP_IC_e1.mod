# LMP example 
# by Xingpeng.Li
# run command: include fileName.mod; e.g. include LMP_IC_e1.mod;

# Use reset to clear memory for AMPL
reset;

# Declare parameters
param c1; let c1 := 50;
param Pgmin1; let Pgmin1 := 30;
param Pgmax1; let Pgmax1 := 80;

param c2; let c2 := 10;
param Pgmin2; let Pgmin2 := 20;
param Pgmax2; let Pgmax2 := 90;

param Load2 = 100;
param x; let x := 0.1;
param BaseMW = 100;

# Declare Variables
var G1;
var G2;
var pk1;
var theta1;
var theta2;

# Define objective function
minimize obj: c1*G1 + c2*G2;

# Define constraints
subject to PowerBalance_1: G1 - pk1 = 0;
subject to PowerBalance_2: G2 + pk1 = Load2;
subject to lineFlow_1: pk1/BaseMW = (theta1 - theta2)/x;
subject to genLimit_1: Pgmin1 <= G1 <= Pgmax1;
subject to genLimit_3: Pgmin2 <= G2 <= Pgmax2;

fix theta2 := 0;

# Solver setting
option solver gurobi;
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display G1, G2;
display pk1;
display PowerBalance_1.dual;
display PowerBalance_2.dual;


