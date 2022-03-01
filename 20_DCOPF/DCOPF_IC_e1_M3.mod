# DCOPF example 
# by Xingpeng.Li
# run command: include fileName.mod; e.g. include DCOPF_IC_e1_M3.mod;

# Use reset to clear memory for AMPL
reset;


# Declare parameters 
set BUS;      # an index list for buses
set BRANCH;   # an index list for branches
set GEN;      # an index list for generator

# Bus data
param busLoad {BUS};

# Generator data
param gen_bus {GEN};
param gen_min {GEN};
param gen_max {GEN};
param gen_OpCost {GEN};

# Branch data
param branch_frmbus {BRANCH};
param branch_tobus {BRANCH};
param branch_x {BRANCH};
param branch_rate {BRANCH};

param BaseMW = 100;
param refBus = 3;

# Declare Variables
var G {GEN};
var pk {BRANCH};
var theta {BUS};

# Define objective function
minimize obj: sum{g in GEN}gen_OpCost[g]*G[g]*BaseMW;

# Define constraints
subject to branchLimits{k in BRANCH}: -branch_rate[k] <= pk[k] <= branch_rate[k];
subject to lineFlowEqs{k in BRANCH}: pk[k] = (theta[branch_frmbus[k]] - theta[branch_tobus[k]])/branch_x[k];
subject to genLimits{g in GEN}: gen_min[g] <= G[g] <= gen_max[g];
subject to NodalPowerBalance{n in BUS}:        
	 sum{g in GEN: gen_bus[g] == n}G[g] 
	 + sum{k in BRANCH: branch_tobus[k] == n}pk[k]
	 - sum{k in BRANCH: branch_frmbus[k] == n}pk[k]
	 = busLoad[n];

# load data
data DCOPF_IC_e1_M2M3_data.txt;
fix theta[refBus] := 0;

# preprocess input raw data
for {n in BUS} {
let busLoad[n] := busLoad[n]/BaseMW;
}

for {g in GEN} {
let gen_min[g] := gen_min[g]/BaseMW;
let gen_max[g] := gen_max[g]/BaseMW;
}

#for {k in BRANCH} {
#let branch_rate[k] := branch_rate[k]/BaseMW;
#}
let {k in BRANCH} branch_rate[k] := branch_rate[k]/BaseMW;

# Solver setting
option solver gurobi;
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display G;
display pk;
display theta;

display _total_solve_elapsed_time;
option show_stats 1;


