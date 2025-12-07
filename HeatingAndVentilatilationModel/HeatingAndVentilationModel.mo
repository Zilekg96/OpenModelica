model HeatingAndVentilationModel
	replaceable package Medium =
  Buildings.Media.Air(extraPropertiesNames={"CO2"},
                      C_nominal={1e-3}) "Medium with CO2 trace substance";
  Modelica.Fluid.Vessels.ClosedVolume Room(redeclare package Medium = Medium, p_start (displayUnit = "bar")= 1e5, T_start = 295.15, X_start = {1, 0}, use_portsData = false, use_HeatTransfer = true, redeclare model HeatTransfer = Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer, V = 44.8, nPorts = 3, final C_start= {0}) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Heater(Q_flow = 1000) annotation(
    Placement(transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveDiscrete Door(allowFlowReversal = true, dp_nominal (displayUnit = "Pa")= 300, m_flow_nominal = 0.3, redeclare package Medium = Medium, opening_min = 0, m_flow(start = 0.1), dp(displayUnit = "Pa"), m_flow_start = 0.1) annotation(
    Placement(transformation(origin = {34, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary sink(nPorts = 1, redeclare package Medium = Medium, p = 1e5, T = 288.15, X = {1, 0}, C = {0}) annotation(
    Placement(transformation(origin = {28, -80}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Fluid.System system(p_ambient = 1e5, T_ambient = 293.15, g = 9.81, allowFlowReversal = false) annotation(
    Placement(transformation(origin = {-74, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanStep DoorOpened(startValue = false) annotation(
    Placement(transformation(origin = {60, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveLinear Valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "Pa") = 300, m_flow_nominal = 0.1, allowFlowReversal = false, dp(displayUnit = "Pa")) annotation(
    Placement(transformation(origin = {-28, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step ValveOpening(height = 1)  annotation(
    Placement(transformation(origin = {-66, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveLinear Valve2(redeclare package Medium = Medium, dp_nominal(displayUnit = "Pa") = 300, m_flow_nominal = 0.001, allowFlowReversal = false, m_flow(start = 0.001), dp(start = 3e7, displayUnit = "Pa")) annotation(
    Placement(transformation(origin = {26, 36}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Sources.Step ValveOpening2(height = 1) annotation(
    Placement(transformation(origin = {64, 66}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Fluid.Sources.MassFlowSource_T Leakage(redeclare package Medium = Medium, use_m_flow_in = false, use_T_in = false, use_X_in = false, use_C_in = false, m_flow = 0.001, T = 288.15, X = {1, 0}, C = {1}, nPorts = 1)  annotation(
    Placement(transformation(origin = {-22, 76}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Fluid.Sources.MassFlowSource_T Source(nPorts = 1, redeclare package Medium = Medium, m_flow = 0.01, X = {1, 0}, T = 288.15)  annotation(
    Placement(transformation(origin = {-68, -76}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(Heater.port, Room.heatPort) annotation(
    Line(points = {{-34, 0}, {-10, 0}}, color = {191, 0, 0}));
  connect(Door.port_b, sink.ports[1]) annotation(
    Line(points = {{44, -44}, {49, -44}, {49, -80}, {38, -80}}, color = {0, 127, 255}));
  connect(Room.ports[1], Door.port_a) annotation(
    Line(points = {{0, -10}, {24, -10}, {24, -44}}, color = {0, 127, 255}));
  connect(Door.open, DoorOpened.y) annotation(
    Line(points = {{34, -36}, {71, -36}, {71, -10}}, color = {255, 0, 255}));
  connect(Valve.port_b, Room.ports[2]) annotation(
    Line(points = {{-18, -52}, {0, -52}, {0, -10}}, color = {0, 127, 255}));
  connect(ValveOpening.y, Valve.opening) annotation(
    Line(points = {{-54, -36}, {-28, -36}, {-28, -44}}, color = {0, 0, 127}));
  connect(Room.ports[3], Valve2.port_b) annotation(
    Line(points = {{0, -10}, {36, -10}, {36, 36}}, color = {0, 127, 255}));
  connect(ValveOpening2.y, Valve2.opening) annotation(
    Line(points = {{76, 66}, {26, 66}, {26, 44}}, color = {0, 0, 127}));
  connect(Leakage.ports[1], Valve2.port_a) annotation(
    Line(points = {{-12, 76}, {16, 76}, {16, 36}}, color = {0, 127, 255}));
 connect(Source.ports[1], Valve.port_a) annotation(
    Line(points = {{-58, -76}, {-38, -76}, {-38, -52}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "4.0.0"), Buildings(version = "12.1.0")),
    experiment(StartTime = 0, StopTime = 14400, Tolerance = 1e-06, Interval = 0.1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_INIT,LOG_NLS,LOG_STATS", s = "dassl", variableFilter = ".*"));
end HeatingAndVentilationModel;
