extends CanvasLayer

var callback: Callable = Callable()

func set_message(message: String):
	$Panel/Label.text = message

func set_callback(cb: Callable):
	callback = cb

func _on_YesButton_pressed():
	if callback:
		callback.call(true)
	queue_free()

func _on_NoButton_pressed():
	if callback:
		callback.call(false)
	queue_free()
