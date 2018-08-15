resource "aws_ecs_task_definition" "rr-web-td" {
    family                = "rr-web-td"
    container_definitions = "${file("../secrets/taskdefinition-web.json")}"
}
resource "aws_ecs_service" "rr-web-service" {
  	name            = "rr-web-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.rr-dmz-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.rr-web-td.family}:${aws_ecs_task_definition.rr-web-td.revision}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.rr-alb-dmz-tg.arn}"
    	container_port    = 80
    	container_name    = "reminder-web"
	}
}

output "rr-web-taskdef" {
	value = "${aws_ecs_task_definition.rr-web-td.family}:${aws_ecs_task_definition.rr-web-td.revision}"
}