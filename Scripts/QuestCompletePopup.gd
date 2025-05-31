extends CanvasLayer

@onready var label = $Popup/Label
@onready var animation_player = $AnimationPlayer

func show_popup(text: String = "Quest Completed!") -> void:
	label.text = text
	visible = true
	$Popup.modulate.a = 0.0  # reset alpha for fade-in
	animation_player.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		await get_tree().create_timer(2.0).timeout
		animation_player.play("fade_out")
	elif anim_name == "fade_out":
		visible = false
