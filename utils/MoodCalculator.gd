extends Node

const EFFICIENCY_PERFECT = 0
const EFFICIENCY_GOOD = 15
const EFFICIENCY_OKAY = 150
const EFFICIENCY_BAD = 1500
const SLOT_PASSES_PERFECT = 0
const SLOT_PASSES_GOOD = 3
const SLOT_PASSES_OKAY = 6
const SLOT_PASSES_BAD = 9
const SLOT_PASSES_REALLY_BAD = 14
const ACCURACY_PERFECT = 0
const ACCURACY_GREAT = 100
const ACCURACY_GOOD = 500
const ACCURACY_OKAY = 1000
const ACCURACY_POOR = 2000
const ACCURACY_BAD = 5000
const ACCURACY_REALLY_BAD = 10000
const ACCURACY_EXTREMELY_BAD = 50000


func check_efficiency(inefficiency: int) -> Vector3:
	if inefficiency < EFFICIENCY_PERFECT:
		pass
	if inefficiency == EFFICIENCY_PERFECT:
		pass
	elif inefficiency < EFFICIENCY_GOOD:
		pass
	elif inefficiency < EFFICIENCY_OKAY:
		pass
	elif inefficiency < EFFICIENCY_BAD:
		pass
	else:
		pass
	return Vector3()


func check_speed(slot_passes: int) -> Vector3:
	if slot_passes == SLOT_PASSES_PERFECT:
		pass
	elif slot_passes < SLOT_PASSES_GOOD:
		pass
	elif slot_passes < SLOT_PASSES_OKAY:
		pass
	elif slot_passes < SLOT_PASSES_BAD:
		pass
	elif slot_passes < SLOT_PASSES_REALLY_BAD:
		pass
	else:
		pass
	return Vector3()


func check_accuracy(difference: int) -> Vector3:
	if difference == 0:
		pass
	elif abs(difference) < 100:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 500:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 1000:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 2000:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 5000:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 10000:
		if difference > 0:
			pass
		else:
			pass
	elif abs(difference) < 50000:
		if difference > 0:
			pass
		else:
			pass
	else:
		if difference > 0:
			pass
		else:
			pass
	return Vector3()
