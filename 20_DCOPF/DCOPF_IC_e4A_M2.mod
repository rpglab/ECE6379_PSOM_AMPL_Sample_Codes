# DCOPF example 
# by Xingpeng.Li
# run command: include fileName.mod; e.g. include DCOPF_IC_e4A_M2.mod;

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
param PTDF {BRANCH, BUS};

# Declare Variables
var G {GEN};
var pk {BRANCH};

# Define objective function
minimize obj: sum{g in GEN}gen_OpCost[g]*G[g];

# Define constraints
subject to branchLimits{k in BRANCH}: -branch_rate[k] <= pk[k] <= branch_rate[k];
subject to lineFlow {k in BRANCH}: pk[k] = sum{i in BUS}( PTDF[k,i] * (sum{g in GEN: gen_bus[g]==i}G[g] - busLoad[i]) );
subject to genLimits{g in GEN}: gen_min[g] <= G[g] <= gen_max[g];
subject to sysPowerBalance: sum{g in GEN}G[g] = sum{n in BUS}busLoad[n];

# load data
data DCOPF_IC_e4-e4A_M2_data.txt;

# Solver setting
option solver gurobi;
option gurobi_options('mipgap=0.0 timelim=90');
solve;

display G;
display pk;

display _total_solve_elapsed_time;
#option show_stats 1;


