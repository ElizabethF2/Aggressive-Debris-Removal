function init()
  MAX_ITEMS = GetInt("savegame.mod.max_items")
	if MAX_ITEMS == 0 then MAX_ITEMS = 1000 end
  RADIUS = GetInt("savegame.mod.radius")
  if RADIUS == 0 then RADIUS = 10000 end
  
  PREVIOUS_MAX_ITEMS = MAX_ITEMS
  PREVIOUS_RADIUS = RADIUS
end

function draw()
	local done = false
  
  UiTranslate(UiCenter(), 100)
	UiAlign("center middle")

	UiFont("bold.ttf", 48)
	UiText("Aggressive Debris Removal")
	UiTranslate(0, 80)
	
  UiFont("regular.ttf", 30)
	UiText("Body Limit")
  UiFont("regular.ttf", 24)
  UiTranslate(0, 30)
  UiText("The limit for how many bodies can exist in the radius")
  UiTranslate(0, 30)
  UiText("Decrease for better performance, Increase for better visuals")
  MAX_ITEMS, done = slider(MAX_ITEMS, 0, 10000)
  if done and MAX_ITEMS ~= PREVIOUS_MAX_ITEMS then
    PREVIOUS_MAX_ITEMS = MAX_ITEMS
    SetInt("savegame.mod.max_items", MAX_ITEMS)
  end

  UiTranslate(0, 100)
  UiFont("regular.ttf", 30)
	UiText("Radius")
  UiFont("regular.ttf", 24)
  UiTranslate(0, 30)
  UiText("How wide of an area to check the body count")
  UiTranslate(0, 30)
  UiText("Set to the max value to check the entire level")
  RADIUS, done = slider(RADIUS, 0, 10000)
  if done and RADIUS ~= PREVIOUS_RADIUS then
    PREVIOUS_RADIUS = RADIUS
    SetInt("savegame.mod.radius", RADIUS)
  end
  
  UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
  UiTranslate(0, 100)
	if UiTextButton("Close", 200, 40) then
		Menu()
	end
end

function slider(val, min, max)
	local done = false
  local w = 500

  val = (((val - min) / (max - min)) * w) - (w/2)

  UiTranslate(0, 40)
  UiPush()
    UiColor(0,1,0)
    UiAlign("center middle")
    UiRect(w, 3)
    val, done = UiSlider("ui/common/dot.png", "x", val, -w/2, w/2)
    -- val = (val + (w/2)) * (max-min)
    UiTranslate(0, 20)
    val = math.floor((((val + (w/2)) / w) * (max - min)) + min)
    UiText(val)
  UiPop()
	return val, done
end
