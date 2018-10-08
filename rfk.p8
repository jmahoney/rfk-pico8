pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--- robot finds kitten
function _init()
    success_message = "you found kittem! good robot!"

    descriptions = {
        "it's an empty box",
        "it's an broken crt monitor",
        "you found a dog",
        "a voucher $20 off hacksaws at joe's hardware",
        "one prophylactic, soiled",
        "he doesn't have time to discuss this with the committee",
        "she is not a committee",
        "a bag of oranges. you're allergic",
        "underwear. 2 pair.",
        "it's the 1977 greatest hits compilation\n'double platinum'\nby the rock band kiss"
    }

    item_glyphs = {"!","#","$","%","^","&","*","(",")"}

    robot_color = 9
    checked_item_color = 12
    background_color = 1

    max_x = 125
    max_y = 123
    robot_start_x = 64
    robot_start_y = 64

    robot = {}
    robot["x"] = robot_start_x
    robot["y"] = robot_start_y
    robot["glyph"] = "@"

    items = {}
    foreach(item_glyphs, create_item)
end

function pick_coords()
    local coords = {}
    coords["x"] = flr(rnd(max_x))+1
    coords["y"] = flr(rnd(max_y))+1

    if coords.x == robot_start_x and coords.y == robot_start_y then
        return pick_coords()
    end

    for i in all(items) do
        if i.x == coords.x and i.y == coords.y then
            return pick_coords()
        end
    end

    return coords
end

function draw_robot()
    print(robot.glyph, robot.x, robot.y, robot_color)
end

function draw_item(item)
    local color = item.color
    if item.checked then color = checked_item_color end
    print(item.glyph, item.x, item.y, color)
end

function create_item()
    local item = {}
    local coords = pick_coords()
    item["checked"] = false;
    item["x"] = coords.x
    item["y"] = coords.y
    item["glyph"] = item_glyphs[flr(rnd(#item_glyphs))+1]
    item["color"] = random_color()
    add(items, item)
end

function move_robot()
    if (btn(0)) then
        if (robot.x>1) then robot.x=robot.x-1 end
    end
    if (btn(1)) then
        if (robot.x<max_x) then robot.x=robot.x+1 end
    end
    if (btn(2)) then
        if (robot.y>1) then robot.y=robot.y-1 end
    end
    if (btn(3)) then
        if (robot.y<max_y) then robot.y=robot.y+1 end
    end
end

function random_color()
    local color = flr(rnd(15))+1
    if color != robot_color and color != checked_item_color and color != background_color then
        return color
    else
        return random_color()
    end
end

function _update()
    move_robot()
end

function _draw()
    rectfill(0,0,127,127,background_color)
    draw_robot()
    foreach(items, draw_item)
end

__gfx__
000000007777777777777777eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000799999977dddddd7e777777e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700799999977dddddd7e777777e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007777777777777777eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000799999977dddddd7e777777e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700799999977dddddd7e777777e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000799999977dddddd7e777777e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007777777777777777eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
