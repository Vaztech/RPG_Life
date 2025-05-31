class_name MovementHandler
extends Node

func move(entity: Node2D, direction: Vector2, speed: float) -> void:
    entity.position += direction.normalized() * speed * get_process_delta_time()