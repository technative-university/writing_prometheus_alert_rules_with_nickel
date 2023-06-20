let alert_rule = fun name problem_txt_short problem_txt_long duration sev expression => {
  alert = name,
  expr = expression,
  for = duration,
  labels = {
    team = "devops",
    platform = "aws"
  },
  annotations = {
    summary = "%{problem_txt_short}",
    description = "%{problem_txt_long}",
    severity = std.string.from_number sev,
    }
} in

{
  groups = [
    {
      name = "mycompany",
      rules = [
        alert_rule "documentdb_freeable_memory_low" "DocumentDB freeable memory low" "DocumentDB: the instance has less then 25% freeable memory." "10m" 2 m%"
          16 /
          (aws_docdb_freeable_memory_average{dbinstance_identifier="tf-created-AABBCCDD"} / (1024^3))
          * 100 < 25
        "%,

        alert_rule "documentdb_cpu_usage_too_high" "DocumentDB cpu usage too high" "DocumentDB: the instance are using more than 90% of the cpu assigned" "10m" 2 m%"
          aws_docdb_cpuutilization_average > 90
        "%
      ]
    }
  ]
}
