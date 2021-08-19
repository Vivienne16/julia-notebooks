#!/usr/bin/julia
using JuMP,Gurobi
pesticide_model = Model(Gurobi.Optimizer) # replace this with your code!
	@variables(pesticide_model, begin
		W[1:3] >= 0
		S[1:3] >= 0
		C[1:3] >= 0
	end)
	@objective(pesticide_model, Max, 694S[1] + 948S[2] + 1164S[3] + 665W[1] + 757W[2] + 784W[3] + 908C[1] + 1041C[2] + 1278C[3])
	@constraints(pesticide_model, begin
		2900S[1]+3800S[2]+4400S[3] >= 50000 
		3500W[1]+4100W[2]+4200W[3] >= 50000 
		5900C[1]+6700C[2]+7900C[3] >= 50000 
		0.8S[1] - 0.2S[2] -1.2S[3]>=0
		0.7W[1] -0.3W[2] -1.3W[3] >=0	
		0.6C[1] -0.4C[2]-1.4C[3] >=0	
		sum(W)+sum(C)+sum(S) <=130
	end)
optimize!(pesticide_model)
objective_value(pesticide_model)