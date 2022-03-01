# Dynamic Programming SCUC Example
# by Xingpeng Li
# run command: model fileName.mod; e.g. model 08_DP_SCUC.mod;

reset;

param C1 = 10;
param SU1 = 800;
param Pgmin1 = 30;
param Pgmax1 = 80;

param C2 = 30;
param SU2 = 100;
param Pgmin2 = 50;
param Pgmax2 = 90;

var u11 binary;
var v11 binary;
var P11;
var u12 binary;
var v12 binary;
var P12;


var u21 binary;
var v21 binary;
var P21;
var u22 binary;
var v22 binary;
var P22;

minimize obj: (SU1*v11 + C1*P11 + SU1*v12 + C1*P12) + (SU2*v21 + C2*P21 + SU2*v22 + C2*P22);


subject to eq11:  Pgmin1*u11 <= P11;
subject to eq12:  Pgmin1*u12 <= P12;
subject to eq13:  P11 <= Pgmax1*u11;
subject to eq14:  P12 <= Pgmax1*u12;
subject to eq15:  v11 >= u11 - 0;
subject to eq16:  v12 >= u12 - u11;

subject to eq21:  Pgmin2*u21 <= P21;
subject to eq22:  Pgmin2*u22 <= P22;
subject to eq23:  P21 <= Pgmax2*u21;
subject to eq24:  P22 <= Pgmax2*u22;
subject to eq25:  v21 >= u21 - 0;
subject to eq26:  v22 >= u22 - u21;

subject to PowerBalance1: P11 + P21 = 90;
subject to PowerBalance2: P12 + P22 = 70;

option solver gurobi; # MINOS, cplex
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display u11, P11;
display u12, P12;

display u21, P21;
display u22, P22;
