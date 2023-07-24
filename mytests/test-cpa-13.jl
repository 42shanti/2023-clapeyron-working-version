# 'p-xy' diagram of carbon dioxide + water

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

# First we generate the models:
model1 = sCPA(["carbon dioxide","water"]) #use SRK reference model
model2 = sCPA(["carbon dioxide","water"];cubicmodel=PR)
model3 = PCSAFT(["carbon dioxide","water"])
model4 = SAFTVRMie(["carbon dioxide","water"];idealmodel=ReidIdeal)

models = [model1,model2,model3,model4];

#Generating the 'p-xy' envelope using the `bubble_pressure` function:
T = 323.15
x = range(1e-8,0.037,length=200)
X = Clapeyron.FractionVector.(x)

y = []
p = []
for i ∈ 1:4
    bub = []
    v0 =[]
    for j ∈ 1:200
        if j==1
            append!(bub, [bubble_pressure(models[i],T,X[j])])
            v0 = [log10(bub[j][2]),log10(bub[j][3]),bub[j][4][1],bub[j][4][2]]
        else
            append!(bub, [bubble_pressure(models[i],T,X[j];v0=v0)])
            v0 = [log10(bub[j][2]),log10(bub[j][3]),bub[j][4][1],bub[j][4][2]]
        end
    end
    append!(y,[append!([bub[i][4][1] for i ∈ 1:200],reverse(x))])
    append!(p,[append!([bub[i][1] for i ∈ 1:200],[bub[i][1] for i ∈ 200:-1:1])])
end

# Collecting some data from https://doi.org/10.1016/S0896-8446(99)00054-6 (2000bamberger):
#pressure/MPa
p_exp = [4.05,5.06,6.06,7.08,8.08,9.09,10.09,11.10,12.10,14.11]
#vapor mole fraction
x_exp = [0.0109,0.0137,0.0161,0.0176,0.019,0.02,0.0205,0.021,0.0214,0.0217]
#liquid mole fraction
y_exp = [0.9954,0.9964,0.9963,0.9966,0.9966,0.9959,0.9955,0.995,0.9945,0.9939]

# Plotting:
plt.clf()
f,(ax,ax2) = plt.subplots(1,2,sharey=true, facecolor="w")

# plot the same data on both axes
ax.plot(y[1],p[1]./1e6,label="sCPA{SRK}",linestyle=":")
ax.plot(y[2],p[2]./1e6,label="sCPA{PR}",linestyle="--")
ax.plot(y[3],p[3]./1e6,label="PC-SAFT",linestyle="-.")
ax.plot(y[4],p[4]./1e6,label="SAFT-VR Mie",linestyle=(0, (3, 1, 1, 1)))
ax.plot(x_exp,p_exp,label="experimental",linestyle="",marker="o")

ax2.plot(y[1],p[1]./1e6,label="",linestyle=":")
ax2.plot(y[2],p[2]./1e6,label="",linestyle="--")
ax2.plot(y[3],p[3]./1e6,label="",linestyle="-.")
ax2.plot(y[4],p[4]./1e6,label="",linestyle=(0, (3, 1, 1, 1)))
ax2.plot(y_exp,p_exp,label="experimental",linestyle="",marker="o")

ax.set_xlim(0,0.029)
ax.set_ylim(0,18.)
ax2.set_xlim(0.986,1.)
ax2.set_ylim(0,18.)

# hide the spines between ax and ax2
ax.spines["right"].set_visible(false)
ax2.spines["left"].set_visible(false)
ax.yaxis.tick_left()
ax2.yaxis.tick_right()

d = 0.015 # how big to make the diagonal lines in axes coordinates
# arguments to pass plot, just so we do not keep repeating them
ax.plot((1-d,1+d), (-d,+d), transform=ax.transAxes, color="k", clip_on=false)
ax.plot((1-d,1+d),(1-d,1+d), transform=ax.transAxes, color="k", clip_on=false)

ax2.plot((-d,+d), (1-d,1+d), transform=ax2.transAxes, color="k", clip_on=false)
ax2.plot((-d,+d), (-d,+d), transform=ax2.transAxes, color="k", clip_on=false)

ax.legend(loc="upper left",frameon=false,fontsize=10.5) 
ax.set_xlabel("composition of 1",fontsize=16)
ax.xaxis.set_label_coords(1.1, -0.08)
ax.set_ylabel("Pressure / MPa",fontsize=16)
plt.setp(ax.get_xticklabels(), fontsize=12)
plt.setp(ax2.get_xticklabels(), fontsize=12)

plt.setp(ax.get_yticklabels(), fontsize=12);
display(plt.gcf())

display("---run finished---")