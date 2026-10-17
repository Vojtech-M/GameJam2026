extends PathFollow2D

# Rychlost pohybu v pixelech za sekundu (nebo můžete měnit progress_ratio)
@export var speed: float = 350.0

func _process(delta: float) -> void:
	# Posouvá objekt vpřed podél cesty
	progress += speed * delta
	
	# Nepovinné: Pokud chcete, aby se cesta po dosažení konce opakovala
	# if progress_ratio >= 1.0:
	#     progress_ratio = 0.0
