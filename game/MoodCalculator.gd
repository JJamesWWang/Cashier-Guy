extends Node
# For the following functions:
# Vector3.x = mood_guy
# Vector3.y = mood_manager
# Vector3.z = mood_customer

const EFFICIENCY_PERFECT = 0
const EFFICIENCY_OKAY = 5
const EFFICIENCY_BAD = 10
const SPEED_PERFECT = 1
const SPEED_GOOD = 2
const ACCURACY_PERFECT = 0
const ACCURACY_GREAT = 25
const ACCURACY_GOOD = 50
const ACCURACY_OKAY = 100
const ACCURACY_BAD = 500
const ACCURACY_REALLY_BAD = 1000
const ACCURACY_EXTREMELY_BAD = 5000
const ACCURACY_UNBELIEVABLY_BAD = 10000


func calculate_mood(accuracy: int, efficiency: int, manager_present: bool) -> Vector3:
	var change_efficiency = check_efficiency(efficiency, manager_present)
	var change_accuracy = check_accuracy(accuracy, manager_present)
	return change_efficiency + change_accuracy


func check_efficiency(efficiency: int, manager_present: bool) -> Vector3:
	var change_efficiency := Vector3()
	if efficiency < EFFICIENCY_PERFECT:
		change_efficiency += Vector3(0, 0, 0)
	elif efficiency == EFFICIENCY_PERFECT:
		change_efficiency += Vector3(5, 10, 20)
	elif efficiency <= EFFICIENCY_OKAY:
		change_efficiency += Vector3(5, -10, -20)
	elif efficiency <= EFFICIENCY_BAD:
		change_efficiency += Vector3(10, -20, -40)
	else:
		change_efficiency += Vector3(20, -20, -60)
	if not manager_present:
		change_efficiency.y *= 0
	return change_efficiency


func check_accuracy(accuracy: int, manager_present: bool) -> Vector3:
	var change_accuracy := Vector3()
	if abs(accuracy) == ACCURACY_PERFECT:
		change_accuracy += Vector3(60, 40, 40)
	elif abs(accuracy) <= ACCURACY_GREAT:
		change_accuracy += Vector3(40, 20, 20)
	elif abs(accuracy) <= ACCURACY_GOOD:
		change_accuracy += Vector3(25, 10, 10)
	elif abs(accuracy) <= ACCURACY_OKAY:
		change_accuracy += Vector3(10, -20, -20)
	elif abs(accuracy) <= ACCURACY_BAD:
		change_accuracy += Vector3(-10, -40, -40)
	elif abs(accuracy) <= ACCURACY_REALLY_BAD:
		change_accuracy += Vector3(-20, -60, -60)
	elif abs(accuracy) <= ACCURACY_EXTREMELY_BAD:
		change_accuracy += Vector3(-40, -90, -90)
	elif abs(accuracy) <= ACCURACY_UNBELIEVABLY_BAD:
		change_accuracy += Vector3(-80, -130, -130)
	else:
		change_accuracy += Vector3(-120, -180, -180)

	if accuracy > 0 and change_accuracy.z < 0:
		change_accuracy.z *= -1
		change_accuracy.z /= 5
	elif accuracy < 0 and change_accuracy.y < 0:
		change_accuracy.y *= -1
		change_accuracy.y /= 5

	if not manager_present:
		change_accuracy.y *= 0
	return change_accuracy
