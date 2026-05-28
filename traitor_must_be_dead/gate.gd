extends CollisionShape2D


func get_a() -> Vector2:
	return (shape as SegmentShape2D).a
	

func get_b() -> Vector2:
	return (shape as SegmentShape2D).b
