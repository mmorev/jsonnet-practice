{
  local g = import '../grafonnet.libsonnet',
  local sli = import 'sli_parts.libsonnet',

  avail_expr(steps):
    'min(%(up)s) +\nmin(%(errors)s) +\nmin(%(latency)s) == bool 3' %
    {
      'up':      sli.part_up(steps),
      'errors':  sli.part_errors(steps),
      'latency': sli.part_latency(steps),
    },

  avail (datasource, steps):
    g.query.prometheus.new(datasource, self.avail_expr(steps))
    + g.query.prometheus.withLegendFormat('Available'),

  downtime_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      'sum_over_time((\n%s\n)[${__range_s}s:$__rate_interval]) * $__rate_interval' % [self.avail_expr(steps)]
    ),

  availability_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      '($__range_s - sum_over_time((\n%s\n)[${__range_s}s:$__rate_interval]) * $__rate_interval)/$__range_s' % [self.avail_expr(steps)]
    ),

  failure_count_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      'resets((%s)==0)[${__range_s}s:$__rate_interval]' % [self.avail_expr(steps)]
    ),

  mttr_over_time (datasource, steps):
    g.query.prometheus.new(datasource,
      '(sum_over_time((%s)[${__range_s}s:$__rate_interval])*$__rate_interval) / resets((%s)[${__range_s}s:$__rate_interval])' %
      [self.avail_expr(steps), self.avail_expr(steps)]
    ),

}
