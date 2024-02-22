local g = import '../grafonnet.libsonnet';

{
  local stateTimeline = g.panel.stateTimeline,
  local fieldConfig = stateTimeline.fieldConfig,
  local standardOptions = stateTimeline.standardOptions,
  local options = stateTimeline.options,
  local step = standardOptions.threshold.step,

  base(title, targets, w=24, h=5):
    stateTimeline.new(title)
    + stateTimeline.queryOptions.withTargets(targets)
    + stateTimeline.queryOptions.withInterval('1m')
    + stateTimeline.queryOptions.withMaxDataPoints(10000)
    + stateTimeline.gridPos.withW(w)
    + stateTimeline.gridPos.withH(h)
    + stateTimeline.panelOptions.withGridPos(w=24)
    + options.withShowValue('never')
    + options.legend.withShowLegend(false)
    + standardOptions.color.withMode('thresholds')
    + standardOptions.withNoValue('-1')
    + standardOptions.withUnit('bool')
    + standardOptions.thresholds.withMode('absolute')
    + standardOptions.thresholds.withSteps([
        step.withValue(null)+step.withColor('#73BF69'),
        step.withValue(0)   +step.withColor('red'),
        step.withValue(1)   +step.withColor('#73BF69'),
      ])

}
