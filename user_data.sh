#!/bin/bash
echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config
echo ECS_CLUSTER="${ecs_cluster_name}" >> /etc/ecs/ecs.config
