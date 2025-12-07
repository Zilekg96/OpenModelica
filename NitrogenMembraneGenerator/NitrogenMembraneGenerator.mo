model NitrogenMembraneGenerator
  Modelica.Fluid.Sources.MassFlowSource_T Source(redeclare package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir, m_flow = 0.0005, T = 291.15, X = {0.767, 0.233},  // Correct mass fractions for {N2, O2}
  nPorts = 1) annotation(
    Placement(transformation(origin = {-54, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT Sink(redeclare package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir, p = 1e5, T = 291.15, nPorts = 2, X = {0.767, 0.233}) annotation(
    Placement(transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Fluid.System system(allowFlowReversal = false, p_ambient = 1e5);
  Modelica.Fluid.Valves.ValveDiscrete valveDiscrete(redeclare package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir, dp_nominal (displayUnit = "Pa")= 300, m_flow_nominal = 0.0005) annotation(
    Placement(transformation(origin = {20, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startValue = true) annotation(
    Placement(transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir, nPorts = 2,  // Fixed: Needs 2 ports for connections
  use_portsData = false, V = 0.01, use_HeatTransfer = false, X_start = {1, 0}) annotation(
    Placement(transformation(origin = {-16, 36}, extent = {{-10, -10}, {10, 10}})));
  Membrane membrane(redeclare package Medium = Modelica.Media.IdealGases.MixtureGases.CombustionAir, perm_O2 = 5e-8, perm_N2 = 5e-9, A = 0.01) annotation(
    Placement(transformation(origin = {-12, -2}, extent = {{-10, -10}, {10, 10}})));
initial equation
  volume.medium.X = {1, 0};
equation
  connect(valveDiscrete.port_b, Sink.ports[2]);
  connect(booleanStep.y, valveDiscrete.open);
  connect(Source.ports[1], membrane.Feed) annotation(
    Line(points = {{-44, 2}, {-18, 2}, {-18, -2}}, color = {0, 127, 255}));
  connect(booleanStep.y, valveDiscrete.open) annotation(
    Line(points = {{2, 70}, {20, 70}, {20, 34}}, color = {255, 0, 255}));
  connect(membrane.Permeate, Sink.ports[1]) annotation(
    Line(points = {{-14, -2}, {52, -2}, {52, 2}}, color = {0, 127, 255}));
  connect(volume.ports[1], valveDiscrete.port_a) annotation(
    Line(points = {{-16, 26}, {10, 26}}, color = {0, 127, 255}));
  connect(membrane.Retentate, volume.ports[2]) annotation(
    Line(points = {{-14, 0}, {-16, 0}, {-16, 26}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "4.0.0")),
    Diagram(graphics = {Line(points = {{30, 26}, {52, 26}, {52, 2}}, color = {0, 127, 255})}),
  experiment(StartTime = 0, StopTime = 900, Tolerance = 1e-06, Interval = 1),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end NitrogenMembraneGenerator;
