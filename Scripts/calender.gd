extends Panel

@onready var MONTH_NAME = [
	"JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE",
	"JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"
]

@onready var MONTH_SHEET = $MonthSheet

var currentYear
var currentMonth

func convertWeekday(weekDay):
	if(weekDay == 0):
		return 7
	return weekDay

func dayCount(monthIndex,year):
	if((monthIndex == 1) or (monthIndex == 3) or (monthIndex == 5) or (monthIndex == 7) or (monthIndex == 8) or (monthIndex == 10) or (monthIndex == 11)):
		return 31
	elif(monthIndex == 2):
		if(((year%100) == 0) && ((year%400) == 0)):
			return 29
		elif((year%4) == 0):
			return 29
		return 28
	return 30

func _ready() -> void:
	var dateDict = Time.get_date_dict_from_system()
	currentMonth = dateDict.month
	currentYear = dateDict.year
	fillCalender(dateDict.month,dateDict.year)


func fillCalender(month,year,markCurrent = true):
	cleanCalender()
	
	get_node("YearHeader").get_node("YearLabel").text = str(year)
	get_node("MonthHeader").get_node("MonthLabel").text = MONTH_NAME[month-1]
	
	var dateTimeDict = Time.get_datetime_dict_from_system()
	var needToMarkCurrentDate = false
	var currDay = dateTimeDict.day
	print_debug("curr day ",dateTimeDict)
	if((year == dateTimeDict.year) and (month == dateTimeDict.month) and markCurrent):
		needToMarkCurrentDate = true		
		pass
	dateTimeDict.day = 1
	dateTimeDict.month = month
	dateTimeDict.year = year
	var dateTimeString = Time.get_datetime_string_from_datetime_dict(dateTimeDict,true)
	var weekDay = Time.get_datetime_dict_from_datetime_string(dateTimeString,true).weekday
	weekDay = convertWeekday(weekDay)
	print_debug("month ",dateTimeDict.month)
	var maxDays = dayCount(dateTimeDict.month,dateTimeDict.year)
	for i in range(1,maxDays+1):
		print_debug(i," ",weekDay)
		MONTH_SHEET.get_child(weekDay+6).text = str(i)
		MONTH_SHEET.get_child(weekDay+6).disabled = false
		if((needToMarkCurrentDate) and (currDay == i)):
			MONTH_SHEET.get_child(weekDay+6).get_node("color").color = Color(0.667, 0.337, 0.051, 0.718)
			print(MONTH_SHEET.get_child(weekDay+6).name)
			pass
		weekDay += 1
		
	#var currDateDict = Time.get_date_dict_from_system()
	

func cleanCalender():
	for i in range(7,MONTH_SHEET.get_child_count()):
		MONTH_SHEET.get_child(i).text = ""
		MONTH_SHEET.get_child(i).disabled = true
		MONTH_SHEET.get_child(i).get_node("color").color = Color.TRANSPARENT
	pass

func _on_prev_month_pressed() -> void:
	currentMonth -= 1
	currentMonth = (currentMonth-1 + 12) % 12
	currentMonth += 1
	fillCalender(currentMonth,currentYear)


func _on_next_month_pressed() -> void:
	currentMonth += 1
	currentMonth = (currentMonth-1 + 12) % 12
	currentMonth += 1
	fillCalender(currentMonth,currentYear)


func _on_prev_year_pressed() -> void:
	if(currentYear != 0):
		currentYear -= 1
		fillCalender(currentMonth,currentYear)


func _on_next_year_pressed() -> void:
	currentYear += 1
	fillCalender(currentMonth,currentYear)
