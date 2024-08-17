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
					"amount": 10,
					"delay": 0
				}
			},
			1: {
				0: {
					"type": 1,
					"amount": 3,
					"delay": 1.0
				}
			},
			2: {
				0: {
					"type": 2,
					"amount": 3,
					"delay": 2.0
				}
			},
			3: {
				0: {
					"type": 3,
					"amount": 1,
					"delay": 3.0
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
					"delay": 1.0
				}
			},
			1: {
				0: {
					"type": 1,
					"amount": 5,
					"delay": 3.0
				},
				1: {
					"type": 2,
					"amount": 3,
					"delay": 4.0
				}
			},
			2: {
				0: {
					"type": 2,
					"amount": 5,
					"delay": 6.0
				},
				1: {
					"type": 3,
					"amount": 1,
					"delay": 7.0
				}
			},
			3: {
				0: {
					"type": 3,
					"amount": 3,
					"delay": 9.0
				}
			}
		},
		
		# wave 3
		2: {
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
					"delay": 1.0
				},
				2: {
					"type": 2,
					"amount": 3,
					"delay": 2.0
				}
			},
			1: {
				0: {
					"type": 1,
					"amount": 5,
					"delay": 4.0
				},
				1: {
					"type": 2,
					"amount": 3,
					"delay": 5.0
				},
				2: {
					"type": 3,
					"amount": 1,
					"delay": 6.0
				}
			},
			2: {
				0: {
					"type": 2,
					"amount": 5,
					"delay": 8.0
				},
				1: {
					"type": 3,
					"amount": 1,
					"delay": 9.0
				}
			},
			3: {
				0: {
					"type": 3,
					"amount": 3,
					"delay": 11.0
				}
			},
			4: {
				0: {
					"type": 0,
					"amount": 15,
					"delay": 15.0
				},
				1: {
					"type": 1,
					"amount": 7,
					"delay": 16.0
				},
				2: {
					"type": 2,
					"amount": 5,
					"delay": 17.0
				},
				3: {
					"type": 3,
					"amount": 3,
					"delay": 18.0
				}
			},
			
		}
	}
}


static func get_wave_data(level: int, wave: int) -> Dictionary:
	if has_next_wave(level, wave):
		return wave_data[level][wave]
	return {}


static func has_next_wave(level: int, wave: int) -> bool:
	return wave_data.size() >= level + 1 and wave_data[level].size() >= wave + 1

