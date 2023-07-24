# Vapour-liquid envelope of EAN

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

# using Unitful
# import Unitful: kg, mol, L, bar

# First we generate the models:

model1 = CPA(["EAN1A"])
model2 = CPA(["EAN2B"])
model3 = CPA(["EAN4C"])
model4 = sCPA(["EAN1A"])
model5 = sCPA(["EAN2B"])
model6 = sCPA(["EAN4C"])

models = [model1,model2,model3,model4,model5,model6]

# We can now obtain the VLE envelope of EAN
# We first need the critical point which can be obtained using `crit_pure`:
crit = crit_pure.(models);

# Subsequently, we can obtain the saturation curve using `saturation_pressure`:
T = []
p = []
v_l = []
v_v = []
for i ∈ 1:6
    append!(T,[range(290,crit[i][1],length=70)])
    sat = saturation_pressure.(models[i],T[i])
    append!(p,[[sat[i][1] for i ∈ 1:70]])
    append!(v_l,[[sat[i][2] for i ∈ 1:70]])
    # append!(v_v,[[sat[i][3] for i ∈ 1:70]])
end

# Collecting some data from the NIST Chemistry Webbook:
T_exp = [293.15,298.15,303.15,308.15,313.15,318.15,323.15,328.15,333.15,338.15,343.15,348.15,353.15]

ρ_l_exp = [11.26,11.23,11.20,11.17,11.14,11.11,11.08,11.06,11.03,11.00,10.98,10.95,10.92]

# ρ_v_exp = [0.27259,0.31179,0.35583,0.40525,0.46071,0.52289,0.59256,0.67055,0.75766,0.85465,0.96219,1.0809,1.2115,1.3555,1.5154,1.6969,1.9102,2.1742,2.5083,2.905,3.4293,4.1468,5.1706,8.6];

# Plotting:
plt.clf()
plt.plot(1e-3 ./v_l[1],T[1],label="CPA-EAN1A",linestyle=":",color="r")
# plt.plot(1e-3 ./v_v[1],T[1],label="",linestyle=":",color="r")
plt.plot(1e-3 ./v_l[2],T[2],label="CPA-EAN2B",linestyle="--",color="g")
# plt.plot(1e-3 ./v_v[2],T[2],label="",linestyle="--",color="g")
plt.plot(1e-3 ./v_l[3],T[3],label="CPA-EAN4C",linestyle="-.",color="b")
# plt.plot(1e-3 ./v_v[3],T[3],label="",linestyle="-.",color="b")
plt.plot(1e-3 ./v_l[4],T[4],label="sCPA-EAN1A",linestyle=(0, (3, 1, 1, 1)),color="violet")
# plt.semilogx(1e-3 ./v_v[4],T[4],label="",linestyle=(0, (3, 1, 1, 1)),color="violet")
plt.plot(1e-3 ./v_l[5],T[5],label="sCPA-EAN2B",linestyle=(0, (5, 1)),color="lightblue")
# plt.semilogx(1e-3 ./v_v[5],T[5],label="",linestyle=(0, (5, 1)),color="lightblue")
plt.plot(1e-3 ./v_l[6],T[6],label="sCPA-EAN4C",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")
# plt.semilogx(1e-3 ./v_v[6],T[6],label="",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")

plt.plot(ρ_l_exp[2:2:end],T_exp[2:2:end],label="Experimental",marker="o",linestyle="",color="k")
# plt.semilogx(ρ_v_exp[2:2:end],T_exp[2:2:end],label="",marker="o",linestyle="",color="k")

plt.legend(loc="lower left",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlim([10.9,11.3])
plt.ylim([290,360])
display(plt.gcf())

# display(T)
# display(p)
# display(v_l)
# display(v_v)

display("---run finished---")