extends CanvasLayer

@onready var fade_rect = $ColorRect
var fade_time := 0.5

func fade_in(callback: Callable = Callable()):
    fade_rect.modulate.a = 1.0
    fade_rect.create_tween().tween_property(fade_rect, "modulate:a", 0.0, fade_time).finished.connect(callback)

func fade_out(callback: Callable = Callable()):
    fade_rect.modulate.a = 0.0
    fade_rect.create_tween().tween_property(fade_rect, "modulate:a", 1.0, fade_time).finished.connect(callback)
