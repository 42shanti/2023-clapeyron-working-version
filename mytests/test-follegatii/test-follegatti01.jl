# Vapour-liquid envelope of 2-HEAF

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

# using Unitful
# import Unitful: kg, mol, L, bar

# First we generate the models:

model1 = sCPA(["2-HEAF"])

models = [model1]
# models = [model1,model2,model3]

# We can now obtain the VLE envelope of 2-HEAF
# We first need the critical point which can be obtained using `crit_pure`:
crit = crit_pure.(models);

# Subsequently, we can obtain the saturation curve using `saturation_pressure`:
T = []
p = []
v_l = []
v_v = []
for i ∈ 1:1
    append!(T,[range(290,crit[i][1],length=40)])
    sat = saturation_pressure.(models[i],T[i])
    append!(p,[[sat[i][1] for i ∈ 1:40]])
    append!(v_l,[[sat[i][2] for i ∈ 1:40]])
    # append!(v_v,[[sat[i][3] for i ∈ 1:40]])
end

# Collecting some data from https://doi.org/10.1016/j.molliq.2018.11.011
T_exp = [298.15,303.15,308.15,313.15,318.15,323.15]

ρ_l_exp = [11.244,11.228,11.195,11.172,11.149,11.125]

# ρ_v_exp = [0.27259,0.31179,0.35583,0.40525,0.46071,0.52289,0.59256,0.67055,0.75766,0.85465,0.96219,1.0809,1.2115,1.3555,1.5154,1.6969,1.9102,2.1742,2.5083,2.905,3.4293,4.1468,5.1706,8.6];

# Plotting:
plt.clf()
plt.plot(1e-3 ./v_l[1],T[1],label="sCPA-2-HEAF",linestyle=":",color="r")
# plt.plot(1e-3 ./v_v[1],T[1],label="",linestyle=":",color="r")
# plt.plot(1e-3 ./v_l[2],T[2],label="sCPA-EAN2B",linestyle="--",color="g")
# # plt.plot(1e-3 ./v_v[2],T[2],label="",linestyle="--",color="g")
# plt.plot(1e-3 ./v_l[3],T[3],label="sCPA-EAN4C",linestyle="-.",color="b")
# plt.plot(1e-3 ./v_v[3],T[3],label="",linestyle="-.",color="b")

plt.plot(ρ_l_exp,T_exp,label="Experimental",marker="o",linestyle="",color="k")
# plt.plot(ρ_v_exp[2:2:end],T_exp[2:2:end],label="",marker="o",linestyle="",color="k")

plt.legend(loc="upper right",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlim([11,11.5])
plt.ylim([295,325])
display(plt.gcf())

# display(T)
display(p)
# display(v_l)
# display(v_v)

display("---run finished---")