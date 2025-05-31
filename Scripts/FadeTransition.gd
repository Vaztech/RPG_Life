extends CanvasLayer

@onready var fade_rect = $FadeRect
@onready var animator = $AnimationPlayer

signal fade_completed

func _ready():
    fade_rect.visible = false

func fade_to_scene(scene_path: String):
    fade_rect.visible = true
    animator.play("fade_out")
    await animator.animation_finished
    get_tree().change_scene_to_file(scene_path)
    animator.play("fade_in")
    await animator.animation_finished
    fade_rect.visible = false
    emit_signal("fade_completed")