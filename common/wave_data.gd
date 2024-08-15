extends Node
class_name WaveData


const wave_data = {
	# level 1
	0: {
		# wave 1
		0: {
			# groups
			0: {
				# enemies
				0: {
					"type": 0,
					"amount": 12,
					"delay": 0
				}
			},
			1: {
				0: {
					"type": 1,
					"amount": 3,
					"delay": 2.0
				}
			},
			2: {
				0: {
					"type": 2,
					"amount": 3,
					"delay": 5.0
				}
			},
			3: {
				0: {
					"type": 3,
					"amount": 1,
					"delay": 8.0
				}
			}
		},
		
		# wave 2
		1: {
			# groups
			0: {
				# enemies
				0: {
					"type": 0,
					"amount": 15,
					"delay": 0
				},
				1: {
					"type": 1,
					"amount": 3,
					"delay": 2.0
				}
			},
			1: {
				0: {
					"type": 0,
					"amount": 12,
					"delay": 7.5
				},
				1: {
					"type": 1,
					"amount": 3,
					"delay": 10.0
				},
				2: {
					"type": 2,
					"amount": 3,
					"delay": 12.5
				}
			},
			2: {
				0: {
					"type": 2,
					"amount": 7,
					"delay": 20.0
				},
				1: {
					"type": 1,
					"amount": 10,
					"delay": 22.5
				}
			},
			3: {
				0: {
					"type": 0,
					"amount": 10,
					"delay": 35.0
				},
				1: {
					"type": 3,
					"amount": 1,
					"delay": 30.0
				},
				2: {
					"type": 1,
					"amount": 5,
					"delay": 33.0
				}
			}
		}
	}
}


static func get_wave_data(level, wave: int) -> Dictionary:
	if wave_data.size() >= level + 1 and wave_data[level].size() >= wave + 1:
		return wave_data[level][wave]
	return {}

