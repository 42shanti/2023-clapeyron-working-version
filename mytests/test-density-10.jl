# Vapour-liquid envelope of IL: ethylammonium nitrate

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot


using Unitful
import Unitful: kg, mol, L, bar


# First we generate the models:
model1 = CPA(["ethylammonium nitrate"];userlocations=["C:/Users/bc_usp/Documents/coding/clapeyron01/Clapeyron.jl/mytests/CPA_like.csv","C:/Users/bc_usp/Documents/coding/clapeyron01/Clapeyron.jl/mytests/CPA_assoc.csv"])


model2 = sCPA(["ethylammonium nitrate"];userlocations=["C:/Users/bc_usp/Documents/coding/clapeyron01/Clapeyron.jl/mytests/CPA_like.csv","C:/Users/bc_usp/Documents/coding/clapeyron01/Clapeyron.jl/mytests/CPA_assoc.csv"])


models = [model1,model2];


# We can now obtain the VLE envelope of COMPONENT
# We first need the critical point which can be obtained using `crit_pure`:
# crit = crit_pure.(models);
Tc = 719.8
Pc = 46.24bar
acentric_factor = 0.541


#Subsequently, we can obtain the saturation curve using `saturation_pressure`:
T = []
p = []
v_l = []
for i ∈ 1:2
    append!(T,[range(290,crit[i][1],length=70)])
    sat = saturation_pressure.(models[i],T[i])
    append!(p,[[sat[i][1] for i ∈ 1:100]])
    append!(v_l,[[sat[i][2] for i ∈ 1:100]])
end

# Collecting some data from the NIST Chemistry Webbook:
T_exp = [293.15,298.15,303.15,308.15,313.15,318.15,323.15,328.15,333.15,338.15,343.15,348.15,353.15]

ρ_l_exp = [11255.6,11225.9,11197.2,11168.5,11139.8,11112.0,11084.3,11056.5,11029.6,11001.9,10975.0,10948.1,10921.3]

# Plotting:
plt.clf()
plt.semilogx(1e-3 ./v_l[1],T[1],label="CPA",linestyle=":",color="r")
plt.semilogx(1e-3 ./v_v[1],T[1],label="",linestyle=":",color="r")
plt.semilogx(1e-3 ./v_l[2],T[2],label="sCPA",linestyle="--",color="g")
plt.semilogx(1e-3 ./v_v[2],T[2],label="",linestyle="--",color="g")


plt.semilogx(ρ_l_exp[2:2:end],T_exp[2:2:end],label="Experimental",marker="o",linestyle="",color="k")


plt.legend(loc="upper left",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlim([10.9,11.3])
plt.ylim([290,360])
display(plt.gcf())

