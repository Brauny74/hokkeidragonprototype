extends TextureProgressBar
class_name ConnectedProgressBar

func init(max: float, curr: float = -1.0):
	min_value = 0.0
	max_value = max
	if curr < 0.0:
		value = max
	else:
		value = curr

func update(new_value: float):
	value = new_value
