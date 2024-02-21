local g = import '../grafonnet.libsonnet';

{
  local stat = g.panel.stat,
  local standardOptions = stat.standardOptions,
  local options = stat.options,
  local step = standardOptions.threshold.step,

  base(title, targets, w=4, h=4, x=0): 
    stat.new(title)
    + stat.queryOptions.withTargets(targets)
    + stat.queryOptions.withInterval('3m')
    + stat.queryOptions.withMaxDataPoints(10000)
    + stat.gridPos.withW(w)
    + stat.gridPos.withH(h)
    + stat.gridPos.withX(x)
    + options.withTextMode('value')
    + options.withGraphMode('none')
    + standardOptions.color.withMode('thresholds'),

  downtime_over_time(title, targets, w=4, h=4, x=0):
    self.base(title, targets, w=4, h=4, x=0)
    + standardOptions.withUnit('s')
    + standardOptions.withDecimals('auto')
    + standardOptions.thresholds.withMode('absolute')
    + standardOptions.thresholds.withSteps([
        step.withValue(null)+step.withColor('text'),
      ]),
    
  availability_over_time(title, targets, w=4, h=4, x=0):
    self.base(title, targets, w=4, h=4, x=0)
    + standardOptions.withUnit('percentunit')
    + standardOptions.withDecimals(4)
    + standardOptions.thresholds.withMode('absolute')
    + standardOptions.thresholds.withSteps([
        step.withValue(null)+step.withColor('red'),
        step.withValue(0.98)+step.withColor('#EAB839'),
        step.withValue(0.99)+step.withColor('green'),
      ]),
    
  failure_count_over_time(title, targets, w=4, h=4, x=0):
    self.base(title, targets, w=4, h=4, x=0)
    + standardOptions.thresholds.withSteps([
        step.withValue(null)+step.withColor('text'),
        step.withValue(0)+step.withColor('text'),
      ]),

  mttr_over_time(title, targets, w=4, h=4, x=0):
    self.base(title, targets, w=4, h=4, x=0)
    + standardOptions.withUnit('m')
    + standardOptions.thresholds.withSteps([
        step.withValue(null)+step.withColor('text'),
        step.withValue(0)+step.withColor('text'),
      ]),
    
}