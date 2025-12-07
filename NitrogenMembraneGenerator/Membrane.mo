model Membrane
  import Modelica.Units.SI.*;
  replaceable package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir;
  parameter Area A = 1.0 "Membrane area (m2)";
  parameter Real perm_O2 = 5e-8 "Permeance for O2 (kg/(s·m2·Pa))";
  parameter Real perm_N2 = 5e-9 "Permeance for N2 (kg/(s·m2·Pa))";

  constant Real M_O2 = 32e-3 "Molar mass O2 (kg/mol)";
  constant Real M_N2 = 28e-3 "Molar mass N2 (kg/mol)";

  Real xF_O2;
  Real xR_O2;
  Real xP_O2;  
  Real yF_O2 "molar fraction O2 feed";
  Real yP_O2 "molar fraction O2 permeate";

  Real J_O2 "O2 permeation (kg/s)";
  Real J_N2 "N2 permeation (kg/s)";

  Real mF "mass flow feed (kg/s)";
  Real mR "mass flow retentate (kg/s)";
  Real mP "mass flow permeate (kg/s)";

  Real pF;
  Real pR;
  Real pP;
  Real T_F;
  Real T_R;
  Real T_P;
  
  Medium.ThermodynamicState state_F;
  Modelica.Fluid.Interfaces.FluidPort_a Feed(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Retentate(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-26, 14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-26, 14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Permeate(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-28, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-28, -10}, extent = {{-10, -10}, {10, 10}}))); 
	equation
  pF = Feed.p;
  pR = Retentate.p;
  pP = Permeate.p;
  
  state_F = Medium.setState_phX(Feed.p, inStream(Feed.h_outflow), inStream(Feed.Xi_outflow));
  T_F = Medium.temperature(state_F);
  T_R = T_F;
  T_P = T_F;

  mF = Feed.m_flow;
  mR = -Retentate.m_flow;
  mP = -Permeate.m_flow;

  xF_O2 = inStream(Feed.Xi_outflow[2]);

  yF_O2 = (xF_O2 / M_O2) / (xF_O2 / M_O2 + (1 - xF_O2) / M_N2);
  yP_O2 = (xP_O2 / M_O2) / (xP_O2 / M_O2 + (1 - xP_O2) / M_N2);

  J_O2 = A * perm_O2 * noEvent(max(0, yF_O2*pF - yP_O2*pP));
  J_N2 = A * perm_N2 * noEvent(max(0, (1-yF_O2)*pF - (1-yP_O2)*pP));

  mF = mR + mP;
  mF * xF_O2 = mR * xR_O2 + J_O2;
  mF * (1 - xF_O2) = mR * (1 - xR_O2) + J_N2;
  
  pF = pR;
  xP_O2 * (J_O2 + J_N2) = J_O2;
  
  Feed.Xi_outflow = {1 - xF_O2, xF_O2};
  Feed.h_outflow = Medium.specificEnthalpy_pTX(pF, T_F, {1 - xF_O2, xF_O2});

  Retentate.Xi_outflow  = {max(0, min(1, 1-xR_O2)), max(0, min(1, xR_O2))};
  Permeate.Xi_outflow   = {max(0, min(1, 1-xP_O2)), max(0, min(1, xP_O2))};

  Retentate.h_outflow = Medium.specificEnthalpy_pTX(pR, T_R, {1 - xR_O2, xR_O2});
  Permeate.h_outflow  = Medium.specificEnthalpy_pTX(pP, T_P, {1 - xP_O2, xP_O2});

annotation(
    uses(Modelica(version = "4.0.0")));
end Membrane;
