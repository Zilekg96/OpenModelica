import os
import numpy as np
import matplotlib.pyplot as plt
from OMPython import ModelicaSystem

model_file = "HeatingAndVentilationModel.mo"
model_name = "HeatingAndVentilationModel"

m_flow_values = np.linspace(0.05, 0.2, 20)
temperatures = []

mod = ModelicaSystem(model_file, model_name)
for i, m_flow in enumerate(m_flow_values):
    print(f"Run {i+1:02d}/20 -> Source.m_flow = {m_flow:.3f} kg/s")

    mod.setParameters({"Source.m_flow": m_flow})

    mod.setSimulationOptions({
        "stopTime": 14400.0,
        "tolerance": 1e-6,
        "stepSize": 60
    })
    
    mod.simulate()
    T_k = mod.getSolutions("Room.heatPort.T")[0][-1]
    T_c = T_k - 273.15
    temperatures.append(T_c)
    print(f"   → Final room temperature = {T_c:.2f} °C")

plt.figure(figsize=(10, 6))
valid = ~np.isnan(temperatures)
plt.plot(m_flow_values[valid], np.array(temperatures)[valid],
         'o-', linewidth=3, markersize=10, markerfacecolor='white', markeredgewidth=2)

plt.xlabel('Input mass flow rate [kg/s]', fontsize=13)
plt.ylabel('Room temperature [°C]', fontsize=13)
plt.grid(True, alpha=0.4)
plt.tight_layout()
plt.savefig("input_vs_temperature.png", dpi=300)
plt.show()