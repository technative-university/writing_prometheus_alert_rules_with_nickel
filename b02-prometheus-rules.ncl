{
  groups = [
    {
      name = "mycompany",
      rules = [
        {
          alert = "aws_documentdb_freeable_memory_low",
          expr = m%"
            16 /
            (aws_docdb_freeable_memory_average{dbinstance_identifier="tf-created-AABBCCDD"} / (1024^3))
            * 100 < 25
          "%,
          for = "10m",
          labels = {
            team = "devops",
            platform = "aws"
          },
          annotations = {
            description = "DocumentDB = the instance has less then 25% freeable freeable memory.",
            summary = "DocumentDB is has low freeable memory",
            jira_ticket = "aws-devops",
            severity = "2",
            }
          },
          {
            alert = "aws_documentdb_cpu_usage_too_high",
            expr = "aws_docdb_cpuutilization_average > 90",
            for = "10m",
            labels = {
              team = "devops",
              platform = "aws"
            },
            annotations = {
              summary = "DocumentDB is reaching its cpu limit",
              description = "DocumentDB = the instance are using more than 90% of the cpu assigned",
              jira_ticket = "aws-devops",
              severity = 2
            }
          }
        ]
      }
    ]
  }
