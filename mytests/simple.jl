#ideal gas density

using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

rgas = 8314.462
pressure = 778048.8
temperature = 400
itr = 0
rho = []
temp = []
while temperature < 600
    global temperature = temperature + 1
    global itr += 1
    append!(temp,temperature)
    display(temperature)
    density = (rgas .* temperature) ./ pressure
    display(density)
    append!(rho,density)
end

display(temp)
display(rho)

plt.semilogx(rho,temp,label="ideal",linestyle=":",color="r")
plt.semilogx(rho,temp,label="",linestyle=":",color="r")

plt.legend(loc="upper left",frameon=false,fontsize=12) 
plt.xlabel("Density / (mol/L)",fontsize=16)
plt.ylabel("Temperature / K",fontsize=16)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.xlim([2e-1,3e1])
plt.ylim([400,600])
display(plt.gcf())

display("---run finished---")