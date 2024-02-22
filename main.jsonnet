local g = import 'grafonnet.libsonnet';
local panels = import 'panels/main.libsonnet';
local queries = import 'queries/main.libsonnet';

local values = std.extVar('values');
local datasource = values.datasource;

  g.dashboard.new(values.name)
+ g.dashboard.withPanels(
    g.util.grid.makeGrid([
      g.panel.row.new('SLI') + g.panel.row.withCollapsed(false),
      panels.stateTimeline.base('Resulting Availability', queries.sla.avail(datasource, values.steps)),
    ], panelWidth=24, panelHeight=5)

  + g.util.grid.makeGrid([
      panels.stat.downtime_over_time('Downtime 30 days',          queries.sla.downtime_over_time(datasource, values.steps),      x=0),
      panels.stat.availability_over_time('Availability 30 days',  queries.sla.availability_over_time(datasource, values.steps),  x=4),
      panels.stat.failure_count_over_time('Failure count 30d',    queries.sla.failure_count_over_time(datasource, values.steps), x=12),
      panels.stat.mttr_over_time('MTTR 30 days',                  queries.sla.mttr_over_time(datasource, values.steps),          x=16),
    ], panelWidth=6, panelHeight=4, startY=5)

  + g.util.grid.makeGrid([
      g.panel.row.new('SLI Sources') + g.panel.row.withCollapsed(false),
        panels.stateTimeline.base('Service Liveness',             g.query.prometheus.new(datasource, queries.base.liveness(values.steps))),
        panels.timeSeries.base('Error Rate, %',                   g.query.prometheus.new(datasource, queries.base.errors(values.steps))),
        panels.timeSeries.base('Duration, z-score',               g.query.prometheus.new(datasource, queries.base.latency(values.steps))),
    ], panelWidth=8, panelHeight=6, startY=9)
)
