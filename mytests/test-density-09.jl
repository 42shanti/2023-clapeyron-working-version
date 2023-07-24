# Vapour-liquid envelope of methanol

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

# First we generate the models:
# model1 = ogSAFT(["methanol"])
# model2 = CKSAFT(["methanol"])
# model3 = sCKSAFT(["methanol"])
# model4 = softSAFT(["methanol"])
model5 = CPA(["methanol"])
# model6 = PCSAFT(["methanol"])
# model7 = SAFTVRMie(["methanol"])

models = [model5];

# We can now obtain the VLE envelope of methanol
# We first need the critical point which can be obtained using `crit_pure`:
crit = crit_pure.(models);

#Subsequently, we can obtain the saturation curve using `saturation_pressure`:
T = []
p = []
v_l = []
v_v = []
for i ∈ 1:1
    append!(T,[range(400,crit[i][1],length=100)])
    sat = saturation_pressure.(models[i],T[i])
    append!(p,[[sat[i][1] for i ∈ 1:100]])
    append!(v_l,[[sat[i][2] for i ∈ 1:100]])
    append!(v_v,[[sat[i][3] for i ∈ 1:100]])
end

display(p)

# Collecting some data from the NIST Chemistry Webbook:
T_exp = [400,405,410,415,420,425,430,435,440,445,450,455,460,465,470,475,480,485,490,495,500,505,510,512.6]

ρ_l_exp = [21.178,20.973,20.761,20.542,20.315,20.079,19.834,19.579,19.313,19.034,18.741,18.432,18.106,17.759,17.388,16.989,16.553,16.071,15.524,14.88,14.092,13.118,11.689,8.6]

ρ_v_exp = [0.27259,0.31179,0.35583,0.40525,0.46071,0.52289,0.59256,0.67055,0.75766,0.85465,0.96219,1.0809,1.2115,1.3555,1.5154,1.6969,1.9102,2.1742,2.5083,2.905,3.4293,4.1468,5.1706,8.6];

# Plotting:
plt.clf()
# plt.semilogx(1e-3 ./v_l[1],T[1],label="SAFT",linestyle=":",color="r")
# plt.semilogx(1e-3 ./v_v[1],T[1],label="",linestyle=":",color="r")
# plt.semilogx(1e-3 ./v_l[2],T[2],label="CK-SAFT",linestyle="--",color="g")
# plt.semilogx(1e-3 ./v_v[2],T[2],label="",linestyle="--",color="g")
# plt.semilogx(1e-3 ./v_l[3],T[3],label="sCK-SAFT",linestyle="-.",color="b")
# plt.semilogx(1e-3 ./v_v[3],T[3],label="",linestyle="-.",color="b")
# plt.semilogx(1e-3 ./v_l[4],T[4],label="soft-SAFT",linestyle=(0, (3, 1, 1, 1)),color="violet")
# plt.semilogx(1e-3 ./v_v[4],T[4],label="",linestyle=(0, (3, 1, 1, 1)),color="violet")
plt.semilogx(1e-3 ./v_l[1],T[1],label="CPA",linestyle=(0, (5, 1)),color="lightblue")
plt.semilogx(1e-3 ./v_v[1],T[1],label="",linestyle=(0, (5, 1)),color="lightblue")
# plt.semilogx(1e-3 ./v_l[6],T[6],label="PC-SAFT",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")
# plt.semilogx(1e-3 ./v_v[6],T[6],label="",linestyle=(0, (3, 1, 1, 1, 1, 1)),color="darkgreen")
# plt.semilogx(vcat(1e-3 ./v_l[7][1:end-4],1e-3 ./reverse(v_v[7][1:end-4])),vcat(T[7][1:end-4],reverse(T[7][1:end-4])),linestyle=(0, (1, 1)),label="SAFT-VR Mie",color="purple")

plt.semilogx(ρ_l_exp[2:2:end],T_exp[2:2:end],label="Experimental",marker="o",linestyle="",color="k")
plt.semilogx(ρ_v_exp[2:2:end],T_exp[2:2:end],label="",marker="o",linestyle="",color="k")

# plt.legend(loc="upper left",frameon=false,fontsize=12) 
# plt.xlabel("Density / (mol/L)",fontsize=16)
# plt.ylabel("Temperature / K",fontsize=16)
# plt.xticks(fontsize=12)
# plt.yticks(fontsize=12)
# plt.xlim([2e-1,3e1])
# plt.ylim([400,600])
# display(plt.gcf())

###
#ideal gas density
rgas = 8314.462
pressure = 778048.8381705275
temperature = 400
itr = 0
rho = []
temp = []
while temperature < 600
    global temperature = temperature + 1
    global itr += 1
    append!(temp,temperature)
    # display(temperature)
    density = (rgas .* temperature) ./ pressure
    # display(density)
    append!(rho,density)
end
plt.semilogx(rho,temp,label="ideal",linestyle=":",color="chocolate",linewidth=2.0)
# plt.semilogx(rho,temp,label="",linestyle=":",color="r")

plt.legend(loc="upper left",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlim([2e-1,3e1])
plt.ylim([400,600])
display(plt.gcf())
###

display("---run finished---")
