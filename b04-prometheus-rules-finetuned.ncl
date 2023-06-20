let normalize_string = fun instring => std.string.replace_regex "[%,.]+" "" (std.string.replace " " "_" (std.string.lowercase instring)) in

let alert_rule = fun service_name problem_txt_short problem_txt_long duration sev expression => {

  alert = "%{normalize_string service_name}_%{normalize_string problem_txt_short}",
  expr = expression,
  for = duration,
  labels = {
    team = "devops",
    platform = "aws"
  },
  annotations = {
    summary = "%{service_name} is unhealty. %{problem_txt_short}",
    description = "%{service_name} is unhealty. %{problem_txt_long} For at least %{duration}.",
    severity = std.string.from_number sev,
    }
} in

{
  groups = [
    {
      name = "mycompany",
      rules = [
        alert_rule "DocumentDB" "freeable memory low" "The instance has less then 25% freeable memory." "10m" 2 m%"
          16 /
          (aws_docdb_freeable_memory_average{dbinstance_identifier="tf-created-AABBCCDD"} / (1024^3))
          * 100 < 25
        "%,

        alert_rule "DocumentDB" "cpu usage too high" "The instance are using more than 90% of the cpu assigned." "10m" 2 m%"
          aws_docdb_cpuutilization_average > 90
        "%
      ]
    }
  ]
}
