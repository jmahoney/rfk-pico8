pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--- robot finds kitten
function _init()
    debug = true

    sfx_timer = 0

    success_message = "you found kittem! good robot!"

    non_kitten_items = {
        "it's an empty box",
        "it's an broken crt monitor",
        "you found a dog",
        "a voucher $20 off hacksaws at joe's hardware",
        "one prophylactic, soiled",
        "he doesn't have time to discuss this with the committee",
        "she is not a committee",
        "a bag of oranges. you're allergic",
        "underwear. 2 pair.",
        "it's the 1977 greatest hits compilation\n'double platinum'\nby the rock band kiss",
        "\"i pity the fool who mistakes me for kitten!\", sez mr. t.",
        "a macguffin",
        "the president of the united states",
        "the ambassador to the federated states of micronesia",
        "a topographical map of the south island of new zealand",
        "a discarded can of fizz",
        "seventeen goonies bubblegum cards",
        "a thing your aunt gave you which you don't know what it is",
    }

    item_glyphs = {"!","#","$","%","^","&","*","(",")"}

    robot_color = 9
    checked_item_color = 12
    background_color = 1

    found_non_kittem_item = false
    found_kitten = false

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

    kitten = create_kitten()
    add(items, kitten)
end

function _update()

    if (found_non_kittem_item) then

    elseif (found_kitten) then

    else
        move_robot()
        check_collision()
    end

    if sfx_timer>0 then
	    sfx_timer-=1
	end
end

function _draw()
    rectfill(0,0,127,127,background_color)
    foreach(items, draw_item)
    draw_robot()

    if (debug) then draw_debug() end
end

function check_collision()
    if robot.x == kitten.x and robot.y == kitten.y then
        found_kitten = true
        return
    end

    for i in all(items) do
        if i.x == robot.x and i.y == robot.y then
            found_non_kittem_item = true
            return
        end
    end
end

function create_item()
    local item = {}
    local coords = pick_coords()
    item["checked"] = false;
    item["is_kitten"] = false;
    item["x"] = coords.x
    item["y"] = coords.y
    item["glyph"] = item_glyphs[flr(rnd(#item_glyphs))+1]
    item["color"] = random_color()
    add(items, item)
end

function create_kitten()
    local kitten = {}
    local coords = pick_coords()
    kitten["is_kitten"] = true;
    kitten["x"] = coords.x
    kitten["y"] = coords.y
    kitten["glyph"] = item_glyphs[flr(rnd(#item_glyphs))+1]
    kitten["color"] = random_color()
    return kitten
end

function draw_debug()
    local msg = "rx:"..robot.x..",ry:"..robot.y..",kx:"..kitten.x..",ky:"..kitten.y
    print(msg, 2,2, 3);
end

function draw_item(item)
    local color = item.color
    if item.checked then color = checked_item_color end
    print(item.glyph, item.x, item.y, color)
end

function draw_robot()
    print(robot.glyph, robot.x, robot.y, robot_color)
end

function move_robot()

    if btn(0) or btn(1) or btn(2) or btn(3) then
        psfx(0)
        if sfx_timer <= 0 then
            sfx_timer = 20
        end
    end

    if btn(0) then
        if robot.x>1 then robot.x=robot.x-1 end
    end
    if btn(1) then
        if robot.x<max_x then robot.x=robot.x+1 end
    end
    if (btn(2)) then
        if robot.y>1 then robot.y=robot.y-1 end
    end
    if btn(3) then
        if robot.y<max_y then robot.y=robot.y+1 end
    end
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

function psfx(num)
    if sfx_timer <= 0 then
        sfx(num)
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


__sfx__
00100000127501575011750056001f5002550001700117002850026500315002c500225000c600136001760019600166002d50014600176001c60000000216000000000000000000000000000000000000000000
0010000034050360502100036000360002f000012000d20009100081000710006100142000710008100081000710007100061000810005000050000a100060000a1000a100060000a10007100091000110003100
