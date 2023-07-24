# Vapour-liquid envelope of EAN

# using Pkg
# Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot
np = pyimport("numpy")

# using Unitful
# import Unitful: kg, mol, L, bar

# First we generate the models:
# model1 = ogSAFT(["methanol"])
# model2 = CKSAFT(["methanol"])
# model3 = sCKSAFT(["methanol"])
# model4 = softSAFT(["methanol"])

# model5 = CPA(["methanol"])
model5 = CPA(["EAN1A"])

# model6 = PCSAFT(["methanol"])
# model7 = SAFTVRMie(["methanol"])

# models = [model1,model2,model3,model4,model5,model6,model7];
models = [model5];

# We can now obtain the VLE envelope of EAN
# We first need the critical point which can be obtained using `crit_pure`:
crit = crit_pure.(models);

# Subsequently, we can obtain the saturation curve using `saturation_pressure`:
T = []
p = []
v_l = []
v_v = []
for i ∈ 1:1
    # append!(T,[range(400,crit[i][1],length=100)])
    append!(T,[range(290,crit[i][1],length=70)])
    sat = saturation_pressure.(models[i],T[i])
    append!(p,[[sat[i][1] for i ∈ 1:70]])
    append!(v_l,[[sat[i][2] for i ∈ 1:70]])
    append!(v_v,[[sat[i][3] for i ∈ 1:70]])
    # append!(p,[[sat[i][1] for i ∈ 1:100]])
    # append!(v_l,[[sat[i][2] for i ∈ 1:100]])
    # append!(v_v,[[sat[i][3] for i ∈ 1:100]])
end

# Collecting some data from the NIST Chemistry Webbook:
T_exp = [293.15,298.15,303.15,308.15,313.15,318.15,323.15,328.15,333.15,338.15,343.15,348.15,353.15]

ρ_l_exp = [11.26,11.23,11.20,11.17,11.14,11.11,11.08,11.06,11.03,11.00,10.98,10.95,10.92]

# ρ_v_exp = [0.27259,0.31179,0.35583,0.40525,0.46071,0.52289,0.59256,0.67055,0.75766,0.85465,0.96219,1.0809,1.2115,1.3555,1.5154,1.6969,1.9102,2.1742,2.5083,2.905,3.4293,4.1468,5.1706,8.6];

# Plotting:
# plt.clf()
# plt.semilogx(1e-3 ./v_l[1],T[1],label="SAFT",linestyle=":",color="r")
# plt.semilogx(1e-3 ./v_v[1],T[1],label="",linestyle=":",color="r")
# plt.semilogx(1e-3 ./v_l[2],T[2],label="CK-SAFT",linestyle="--",color="g")
# plt.semilogx(1e-3 ./v_v[2],T[2],label="",linestyle="--",color="g")
# plt.semilogx(1e-3 ./v_l[3],T[3],label="sCK-SAFT",linestyle="-.",color="b")
# plt.semilogx(1e-3 ./v_v[3],T[3],label="",linestyle="-.",color="b")
# plt.semilogx(1e-3 ./v_l[4],T[4],label="soft-SAFT",linestyle=(0, (3, 1, 1, 1)),color="violet")
# plt.semilogx(1e-3 ./v_v[4],T[4],label="",linestyle=(0, (3, 1, 1, 1)),color="violet")
# plt.semilogx(1e-3 ./v_l[5],T[5],label="CPA",linestyle=(0, (5, 1)),color="lightblue")
# plt.semilogx(1e-3 ./v_v[5],T[5],label="",linestyle=(0, (5, 1)),color="lightblue")
# plt.semilogx(1e-3 ./v_l[6],T[6],label="PC-SAFT",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")
# plt.semilogx(1e-3 ./v_v[6],T[6],label="",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")
# plt.semilogx(vcat(1e-3 ./v_l[7][1:end-4],1e-3 ./reverse(v_v[7][1:end-4])),vcat(T[7][1:end-4],reverse(T[7][1:end-4])),linestyle=(0, (1, 1)),label="SAFT-VR Mie",color="purple")

plt.clf()
plt.plot(1e-3 ./v_l[1],T[1],label="CPA-EAN2B",linestyle="-",color="r")
# plt.semilogx(1e-3 ./v_v[1],T[1],label="",linestyle="-",color="r")

plt.plot(ρ_l_exp[2:2:end],T_exp[2:2:end],label="Experimental",marker="o",linestyle="",color="k")
# plt.semilogx(ρ_v_exp[2:2:end],T_exp[2:2:end],label="",marker="o",linestyle="",color="k")

plt.legend(loc="lower left",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12,np.arange(10.9,11.3,0.1))
plt.yticks(fontsize=12)
plt.xlim([10.9,11.3])
plt.ylim([290,360])
display(plt.gcf())

display(T)
display(p)
display(v_l)
display(v_v)

display("---run finished---")