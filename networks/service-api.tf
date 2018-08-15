
resource "aws_ecs_task_definition" "rr-api-td" {
    family                = "rr-api-td"
    container_definitions = "${file("../secrets/taskdefinition-api.json")}"
}

resource "aws_ecs_service" "rr-api-service" {
  	name            = "rr-api-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.rr-secure-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.rr-api-td.family}:${aws_ecs_task_definition.rr-api-td.revision}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.rr-alb-secure-tg.arn}"
    	container_port    = 80
    	container_name    = "reminder-api"
	}
}
output "rr-api-taskdef" {
	value = "${aws_ecs_task_definition.rr-api-td.family}:${aws_ecs_task_definition.rr-api-td.revision}"
}