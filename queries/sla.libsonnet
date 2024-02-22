{
  local g = import '../grafonnet.libsonnet',
  local base = import 'base.libsonnet',

  avail_expr(steps):
    'min(%(up)s) +\nmin(%(errors)s) +\nmin(%(latency)s) == bool 3' %
    {
      'up':      base.liveness(steps),
      'errors':  base.errors(steps),
      'latency': base.latency(steps),
    },

  avail (datasource, steps):
    g.query.prometheus.new(datasource, self.avail_expr(steps))
    + g.query.prometheus.withLegendFormat('Available'),

  downtime_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      'sum_over_time((\n%s\n)[${__range_s}s:$__rate_interval]) * $__interval_ms' % [self.avail_expr(steps)]
    ),

  availability_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      '($__range_s - sum_over_time((\n%s\n)[${__range_s}s:$__rate_interval]) * $__interval_ms)/$__range_s' % [self.avail_expr(steps)]
    ),

  failure_count_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      'resets(((\n%s\n)==0)[${__range_s}s:$__rate_interval])' % [self.avail_expr(steps)]
    ),

  mttr_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      '(sum_over_time((%s)[${__range_s}s:$__rate_interval]) * $__interval_ms) / resets((%s)[${__range_s}s:$__rate_interval])' %
      [self.avail_expr(steps), self.avail_expr(steps)]
    ),

}
