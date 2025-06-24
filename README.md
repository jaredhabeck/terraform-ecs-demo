# terraform-ecs-demo
This is a full load balanced, multi-AZ AWS ECS based terraform configuration for a web application.

* Based in PHP, but ECS and ECR can be modified to host other web languages
* Stack: PostgreSQL, Redis (elasticache), Nginx
* Includes fully configured private/public AWS VPC with WAF and load balancing
* AWS IAM setup configured with policies

It has been run as an application previously but is slightly out of date.

Buyer beware: this is an expensive stack, spin up at your own risk - multi-AZ options are commented out for this reason also.
