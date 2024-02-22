local g = import '../grafonnet.libsonnet';

{
  local timeSeries = g.panel.timeSeries,
  local standardOptions = timeSeries.standardOptions,
  local fieldOverride = timeSeries.fieldOverride,
  local custom = timeSeries.fieldConfig.defaults.custom,
  local options = timeSeries.options,
  local step = standardOptions.threshold.step,

  base(title, targets, unit='short', w=8, h=7, x=0, y=10):
    timeSeries.new(title)
    + timeSeries.queryOptions.withTargets(targets)
    + timeSeries.queryOptions.withInterval('1m')
    + standardOptions.withNoValue(0)
    + standardOptions.withUnit(unit)
    + timeSeries.gridPos.withW(w)
    + timeSeries.gridPos.withH(h)
    + timeSeries.gridPos.withX(x)
    + timeSeries.gridPos.withY(y)
    + options.legend.withDisplayMode('table')
    + options.legend.withCalcs([
      'lastNotNull',
      'max',
    ])
    + custom.withFillOpacity(10)
    + custom.withShowPoints('never'),
}