### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ eb3cfc16-75ae-4083-a138-7a8f67a2a922
# import any necessary packages here
begin
	using JuMP,Clp # replace this with your code!
end

# ╔═╡ 75e50b76-0080-11ec-24a6-f197aba20a9b
# edit the code below to set your name and Cornell ID (i.e. email without @cornell.edu)

student = (name = "Vivienne Liu", cornell_id = "ml2589")

# ╔═╡ 6fb5940c-d9ee-4b4b-8bd4-aa20aff429a9
md"""
# Assignment 2

A new pesticide has been developed that is effective in controlling corn, soybean, and wheat pests. As a result of the field experiments, the following crop yields have been obtained:

| **Pesticide Application** (kg/ha) | **Soybean Yields** (kg/ha) | **Wheat Yields** (kg/ha) | **Corn Yields** (kg/ha) |
|:-------------:|:------------:|:-------------:|:---------:|
| 0 | 2900 | 3500 | 5900 |
| 1 | 3800 | 4100 | 6700 |
| 2 | 4400 | 4200 | 7900 |

Annual production costs, **excluding pesticide applications**, and selling prices for the crops are given in the table below.

| **Crop**  | **Annual Production Costs** (\$/ha-yr) | **Selling Prices** (\$/kg)
|:-------------:|:------------:|:-------------:|
| Soybeans | 350 | 0.36 |
| Wheat    | 280 | 0.27 |
| Corn 	   | 390 | 0.22 |

Moreover, pesticide application costs are \$70/ha-yr for any crops at all application rates greater than zero. The demand for each crop is 50,000 kg.

Recently, environmental authorities have expressed concern over the pesticide's ecological impacts and have ruled that a farmer's *average* application rate on corn, soybeans, and wheat cannot exceed 0.6 kg/ha, 0.8 kg/ha, and 0.7 g/ha, respectively.
"""

# ╔═╡ 296f66f0-c962-457f-a0e9-508aa5c0e43f
md"""
## Part 1: Problem Formulation

A farmer has *up to* 130 ha that can be planted with the three crops. Formulate a **linear programming model** to determine how many hectares should be planted with each crop and what the optimal pesticide application rates for each crop should be to maximize profit.

!!! warning
    Make sure that your objective function and all constraints are *linear*.

Your model should include the following 9 variables:
* ``S_j`` = hectares planted with soybeans with pesticide application rate ``j=0,1,2``;

* ``W_j`` = hectares planted with wheat with pesticide application rate ``j=0,1,2``;

* ``C_j`` = hectares planted with corn with pesticide application rate ``j=0,1,2``.
"""

# ╔═╡ 27607511-8cfa-41d4-8414-33653dd73234
md"""
Use this block to derive your problem formulation. This is best done with equations supported by some descriptions.
"""

# ╔═╡ 997dea76-1505-4cc1-bb1a-97e39ca8c9b4
md"""
Use this block to clearly state the objective function and constraints for your problem in standard form.
```math
\begin{alignat*}{2}
& &\max Z = 694S_0 + 948S_1 + 1164S_2+665W_0+757W_1+784W_2+908C_0+1041C_1+1278C_2\\
&\text{s.t.} & \\
& & 2900S_0 + 3800S_1 +4400S_2 \geq 50000\\
& & 3500W_0+4100W_1+4200W_2 \geq 50000 \\
& & 5900C_0+6700C_1+7900C_2 \geq 50000\\
& & 0.8S_0-0.2S_1-1.2S_2 \geq 0\\
& & 0.7W_0-0.3W_1-1.3W_2 \geq 0\\
& & 0.6C_0 - 0.4C_1-1.4C_2 \geq 0\\
& & S_0+S_1+S_2+W_0+W_1+W_2+C_0+C_1+C_2 \leq 130\\
& & S_{i,j},W_{i,j},C_{i,j} \geq 0\\
\end{alignat*}
```

"""

# ╔═╡ 56c8fc9d-473f-4baf-b622-828617bcab32
md"""
## Part 2: Model Implementation and Solution

Implement your model in JuMP, optimize, and query any relevant quantities. Feel free to add any cells as necessary. Name your model `pesticide_model`.

"""

# ╔═╡ 1a820e9c-afd0-49b9-9bfd-d10aa2aed9aa
# Use this cell to implement your model
begin
	pesticide_model = Model(Clp.Optimizer) # replace this with your code!
	@variables(pesticide_model, begin
		W[1:3] >= 0
		S[1:3] >= 0
		C[1:3] >= 0
	end)
	@objective(pesticide_model, Max, 694*S[1] + 948*S[2] + 1164*S[3] + 665*W[1] + 757*W[2] + 784*w[3] + 908*C[1] + 1041*C[2] + 1278*C[3] )
	@constraints(pesticide_model, begin
		2900*S[1]+3800*S[2]+4400*S[3] >= 50000 
		3500*W[1]+4100*W[2]+4200*W[3] >= 50000 
		5900*C[1]+6700*C[2]+7900*C[3] >= 50000 
		[0.8, -0.2,-1.2]*S >=0
		[0.7, -0.3,-1.3]*W >=0	
		[0.6, -0.4,-1.4]*C >=0	
		sum(W)+sum(C)+sum(S) <=130
	end)
end

# ╔═╡ 54ff3c52-2ea2-4667-8d32-ef1e3be0169e
pesticide_model

# ╔═╡ 4850b81a-c1db-41c2-8085-08accd6a1de2
optimize!(pesticide_model)

# ╔═╡ bd633dcc-f888-47d8-9885-6ddacc7131ca
objective_value(pesticide_model)

# ╔═╡ 70c7f451-9e28-4a00-bbf8-bf10e85b78b4
value.(W)

# ╔═╡ 27b611e8-13fc-43df-91b1-ebb8a43353d5
value.(C)

# ╔═╡ a8b33d82-0161-43a1-abf8-ee6713d89ae4
value.(S)

# ╔═╡ 0f51eda7-c9f0-4b15-b895-279e5d718b31
md"""
## Part 3: Results and Conclusion

Briefly describe the results of your analysis, potentially includeing the final value of the objective function, and if a solution was found (and if so, what it was). What does this solution mean to the decision-maker? Be specific! Discuss what the optimal value(s) of the decision variable(s) mean about the system and recommended strategies.
"""

# ╔═╡ 7a71bbf4-27db-4b02-b09d-59209c743fbc


# ╔═╡ ecb5cb2f-89dd-4b6b-988b-269d3e23229c
md"""
### Part 4.1

Based on analyses of dual variables, how much would an extra 10 ha be worth to the farmer?
"""

# ╔═╡ 56af7f87-3593-4549-9a8b-33610e49d210


# ╔═╡ 12b47888-7d2c-4585-856d-f83604bd89b9
md"""
### Part 4.2

If we change the limitation on the farmer's average application on each crop so that the total mass of pesticide applied to all crops divided by the total cropped area must not exceed 0.8 kg/ha, how will the feasible region change?

!!! tip "Modifying and Deleting Constraints"
    Information on how to modify constraints in JuMP can be found [here](https://jump.dev/JuMP.jl/stable/manual/constraints/#Modify-a-constraint). To delete constraints, look at [this part of the documentation](https://jump.dev/JuMP.jl/stable/manual/constraints/#Deleting-constraints).
"""

# ╔═╡ 596c71da-8839-47ed-9ed5-02eae18f91eb


# ╔═╡ 58e80d70-242d-40b7-89f0-b3fb2778e744


# ╔═╡ 096f3293-b0a8-4f16-97d1-0cbda56c7961
md"""
Use this cell to discuss your results. Feel free to add new cells to query any quantities of interest from the model.
"""

# ╔═╡ c4bdb8d5-ffc9-4c21-b790-aed4f7fa24bf
md"""
## Citations

If you used any external resource in the process of solving this problem, provide a reference below. These could be other people, websites, datasets, or code examples.
"""

# ╔═╡ 60877329-dcd6-49e1-8d32-de0723ab4caf
md"""
List external resources here.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Clp = "e2554f3b-3117-50c0-817c-e040a3ddf72d"
JuMP = "4076af6c-e467-56ae-b986-b466b2749572"

[compat]
Clp = "~0.8.4"
JuMP = "~0.21.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Artifacts]]
deps = ["Pkg"]
git-tree-sha1 = "c30985d8821e0cd73870b17b0ed0ce6dc44cb744"
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.3.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "aa3aba5ed8f882ed01b71e09ca2ba0f77f44a99e"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.3"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f759de2b2666a8ae52f370f12bf77e984188144d"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.7+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "bdc0937269321858ab2a4f288486cb258b9a0af7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.3.0"

[[Clp]]
deps = ["BinaryProvider", "CEnum", "Clp_jll", "Libdl", "MathOptInterface", "SparseArrays"]
git-tree-sha1 = "3df260c4a5764858f312ec2a17f5925624099f3a"
uuid = "e2554f3b-3117-50c0-817c-e040a3ddf72d"
version = "0.8.4"

[[Clp_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "MUMPS_seq_jll", "OpenBLAS32_jll", "Osi_jll", "Pkg"]
git-tree-sha1 = "5e4f9a825408dc6356e6bf1015e75d2b16250ec8"
uuid = "06985876-5285-5a41-9fcb-8948a742cc53"
version = "100.1700.600+0"

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[CoinUtils_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "9b4a8b1087376c56189d02c3c1a48a0bba098ec2"
uuid = "be027038-0da8-5614-b30d-e42594cb92df"
version = "2.11.4+2"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "79b9563ef3f2cc5fc6d3046a5ee1a57c9de52495"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.33.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "8e695f735fca77e9708e795eda62afdb869cbb70"
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.3.4+0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JSONSchema]]
deps = ["HTTP", "JSON", "ZipFile"]
git-tree-sha1 = "b84ab8139afde82c7c65ba2b792fe12e01dd7307"
uuid = "7d188eb4-7ad8-530c-ae41-71a32a6d4692"
version = "0.3.3"

[[JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "Printf", "Random", "SparseArrays", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "4f0a771949bbe24bf70c89e8032c107ebe03f6ba"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "0.21.9"

[[LibGit2]]
deps = ["Printf"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "3d682c07e6dd250ed082f883dc88aee7996bf2cc"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2dc1a9fc87e57e32b1fc186db78811157b30c118"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.0+5"

[[MUMPS_seq_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "a1d469a2a0acbfe219ef9bdfedae97daacac5a0e"
uuid = "d7ed1dd3-d0ae-5e8e-bfb4-87a502085b8d"
version = "5.4.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "JSONSchema", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "575644e3c05b258250bb599e57cf73bbf1062901"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.9.22"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0eef589dd1c26a3ac9d753fe1a8bcad63f956fa6"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.16.8+1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "3927848ccebcc165952dc0d9ac9aa274a87bfe01"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.20"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
git-tree-sha1 = "ed3157f48a05543cce9b241e1f2815f7e843d96e"
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS32_jll]]
deps = ["CompilerSupportLibraries_jll", "Libdl", "Pkg"]
git-tree-sha1 = "793b33911239d2651c356c823492b58d6490d36a"
uuid = "656ef2d0-ae68-5445-9ca0-591084a874a2"
version = "0.3.9+4"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9db77584158d0ab52307f8c04f8e7c08ca76b5b3"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.3+4"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Osi_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "6a9967c4394858f38b7fc49787b983ba3847e73d"
uuid = "7da25872-d9ce-5375-a4d3-7a845f58efdd"
version = "0.108.6+2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "477bf42b4d1496b454c10cce46645bb5b8a0cf2c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.2"

[[Pkg]]
deps = ["Dates", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "UUIDs"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
git-tree-sha1 = "44aaac2d2aec4a850302f9aa69127c74f0c3787e"
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Test]]
deps = ["Distributed", "InteractiveUtils", "Logging", "Random"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "c3a5637e27e914a7a445b8d0ad063d701931e9f7"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.3"

[[Zlib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "320228915c8debb12cb434c59057290f0834dbf6"
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.11+18"
"""

# ╔═╡ Cell order:
# ╠═75e50b76-0080-11ec-24a6-f197aba20a9b
# ╟─6fb5940c-d9ee-4b4b-8bd4-aa20aff429a9
# ╟─296f66f0-c962-457f-a0e9-508aa5c0e43f
# ╠═27607511-8cfa-41d4-8414-33653dd73234
# ╟─997dea76-1505-4cc1-bb1a-97e39ca8c9b4
# ╟─56c8fc9d-473f-4baf-b622-828617bcab32
# ╠═eb3cfc16-75ae-4083-a138-7a8f67a2a922
# ╠═1a820e9c-afd0-49b9-9bfd-d10aa2aed9aa
# ╠═54ff3c52-2ea2-4667-8d32-ef1e3be0169e
# ╠═4850b81a-c1db-41c2-8085-08accd6a1de2
# ╠═bd633dcc-f888-47d8-9885-6ddacc7131ca
# ╠═70c7f451-9e28-4a00-bbf8-bf10e85b78b4
# ╠═27b611e8-13fc-43df-91b1-ebb8a43353d5
# ╠═a8b33d82-0161-43a1-abf8-ee6713d89ae4
# ╟─0f51eda7-c9f0-4b15-b895-279e5d718b31
# ╠═7a71bbf4-27db-4b02-b09d-59209c743fbc
# ╟─ecb5cb2f-89dd-4b6b-988b-269d3e23229c
# ╠═56af7f87-3593-4549-9a8b-33610e49d210
# ╟─12b47888-7d2c-4585-856d-f83604bd89b9
# ╠═596c71da-8839-47ed-9ed5-02eae18f91eb
# ╠═58e80d70-242d-40b7-89f0-b3fb2778e744
# ╠═096f3293-b0a8-4f16-97d1-0cbda56c7961
# ╠═c4bdb8d5-ffc9-4c21-b790-aed4f7fa24bf
# ╠═60877329-dcd6-49e1-8d32-de0723ab4caf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
