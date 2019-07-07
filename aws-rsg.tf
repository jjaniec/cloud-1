resource "aws_resourcegroups_group" "front" {
  name = "${var.naming.name}-front"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["${aws_launch_template.front.tags["Name"]}"]
    }
  ]
}
JSON
  }
}
