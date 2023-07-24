# ethylammonium nitrate EANO3
using Pkg
Pkg.activate("..")
using Clapeyron, PyCall
import PyPlot; const plt = PyPlot

using Unitful
import Unitful: kg, mol, L, bar

# parameters
EANO3_like = ParamTable(:like,(
    species = ["EANO3"],
    Mw = [0.108kg*mol^-1],
    b = [0.0825L*mol^-1],
    a = [28.7948L^2*bar*mol^-2],
    c1 = [1.0800],
    n_H = [2],
    n_e = [1],
))

EANO3_assoc = ParamTable(:assoc,(
    species1 = ["EANO3"],
    site1 = ["e"],
    species2 = ["EANO3"],
    site2 = ["H"],
    epsilon_assoc = [407.0850bar*L*mol^-1],
    bondvol = [0.0084],
))

#model
model = CPA(["EANO3"]);userlocations=([
    EANO3_like,
    EANO3_assoc
])

#
# T = []
# p = []
# v_l = []
# for i ∈ 1:2
#     append!(T,[range(290,crit[i][1],length=70)])
#     sat = saturation_pressure.(models[i],T[i])
#     append!(p,[[sat[i][1] for i ∈ 1:100]])
#     append!(v_l,[[sat[i][2] for i ∈ 1:100]])
# end