{
  format_labels(filters):
    std.join(', ', [
      '%s="%s"' % [key, filters[key]]
      for key in std.objectFields(filters)
    ]),

  list_labels(filters):
    std.join(', ', ['%s' % key for key in std.objectFields(filters)]),

  liveness(steps):
    std.join(' or \n    ', [
      'up{service="%s"}' % [steps[i].filters.service]
      for i in std.range(0, std.length(steps) - 1)
    ]),

  errors(steps):
    std.join(' or \n    ', [
      'errors{%s} < bool %s'
      % [self.format_labels(steps[i].filters), steps[i].error_threshold]
      for i in std.range(0, std.length(steps) - 1)
    ]),

  latency(steps):
    std.join(' or \n    ', [
      'latency_z{%s} < bool 2.58'
      % [self.format_labels(steps[i].filters)]
      for i in std.range(0, std.length(steps) - 1)
    ]),

}