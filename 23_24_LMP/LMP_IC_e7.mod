# LMP example 
# by Xingpeng.Li
# run command: include fileName.mod; e.g. include LMP_IC_e7.mod;

# Use reset to clear memory for AMPL
reset;

# Declare parameters
param Pgmin1; let Pgmin1 := 30;
param Pgmax1; let Pgmax1 := 80;
param c1_1 = 5;
param c1_2 = 10;
param c1_3 = 15;
param G1_S1 = 30;
param G1_S2 = 60;
param G1_S3 = 80;

param Pgmin2; let Pgmin2 := 20;
param Pgmax2; let Pgmax2 := 90;
param c2_1 = 10;
param c2_2 = 20;
param c2_3 = 50;
param G2_S1 = 30;
param G2_S2 = 60;
param G2_S3 = 90;

param BaseMW = 100;
param Load2 = 100;
param x; let x := 0.1;
param branchRate1; let branchRate1 := 50;

# Declare Variables
var Pg1;      # this variable was denoted by G1 in example 2
var Pg1_1;
var Pg1_2;
var Pg1_3;

var Pg2;       # this variable was denoted by G2 in example 2
var Pg2_1;
var Pg2_2;
var Pg2_3;

var pk1;
var theta1;
var theta2;

# Define objective function
minimize obj: c1_1*Pg1_1 + c1_2*Pg1_2 + c1_3*Pg1_3 + c2_1*Pg2_1 + c2_2*Pg2_2 + c2_3*Pg2_3;

# Define constraints
subject to PowerBalance_1: Pg1 - pk1 = 0;
subject to PowerBalance_2: Pg2 + pk1 = Load2;
subject to branchLimit_1: -branchRate1 <= pk1 <= branchRate1;
subject to lineFlow_1: pk1/BaseMW = (theta1 - theta2)/x;
subject to genLimit_1: Pgmin1 <= Pg1 <= Pgmax1;
subject to genLimit_3: Pgmin2 <= Pg2 <= Pgmax2;

subject to gen_1_Segment_1: 0 <= Pg1_1 <= G1_S1;
subject to gen_1_Segment_2: 0 <= Pg1_2 <= (G1_S2 - G1_S1);
subject to gen_1_Segment_3: 0 <= Pg1_3 <= (G1_S3 - G1_S2);
subject to gen_1_sum: Pg1 = Pg1_1 + Pg1_2 + Pg1_3;

subject to gen_2_Segment_1: 0 <= Pg2_1 <= G2_S1;
subject to gen_2_Segment_2: 0 <= Pg2_2 <= (G2_S2 - G2_S1);
subject to gen_2_Segment_3: 0 <= Pg2_3 <= (G2_S3 - G2_S2);
subject to gen_2_sum: Pg2 = Pg2_1 + Pg2_2 + Pg2_3;

fix theta2 := 0;

# Solver setting
option solver gurobi;
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display Pg1, Pg1_1, Pg1_2, Pg1_3;
display Pg2, Pg2_1, Pg2_2, Pg2_3;
display pk1;
display PowerBalance_1.dual;
display PowerBalance_2.dual;


