pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--- robot finds kitten
--- a cheerschopper thing
function _init()
    debug = false

    sfx_timer = 0

    kitten_found = false
    non_kitten_item_found = false
    current_non_kitten_item = nil

    background_color = 1
    checked_item_color = 12

    max_x = 125
    max_y = 123

    robot_can_move = true
    robot_color = 9
    robot_start_x = 64
    robot_start_y = 64

    robot = {}
    robot["x"] = robot_start_x
    robot["y"] = robot_start_y
    robot["glyph"] = "@"

    item_glyphs = {"!","#","$","%","^","&","*","(",")"}

    items = {}

    for nki in all(_non_kitten_items()) do
        add(items, create_item(nki))
    end

    kitten = create_item({"kitten"})
    kitten.is_kitten = true

    add(items, kitten)
end

function _non_kitten_items()
    local non_kitten_items = {
        {"it's an empty box"},
        {"it's an broken crt monitor"},
        {"you found a dog"},
        {"a voucher $20", "off hacksaws", "at joe's hardware"},
        {"one prophylactic, soiled"},
        {"he doesn't have time to", "discuss this with", "the committee"},
        {"she is not a committee"},
        {"a bag of oranges.","you're allergic"},
        {"underwear. 2 pair."},
        {"it's the 1977", "greatest hits","compilation", "'double platinum'","by the rock band", "kiss"},
        {"a macguffin"},
        {"the president", "of the", "united states"},
        {"the ambassador to the", "federated states","of micronesia"},
        {"a topographical", "map of the", "south island","of", "new zealand"},
        {"a discarded can of fizz"},
        {"seventeen goonies", "bubblegum cards"},
        {"a thing your aunt","gave you","which you don't", "know what","it is"},
        {"a wetsuit"},
        {"$10,000 in unmarked bills"},
        {"a grumpy cat"},
        {"a very enthusiastic dog"},
        {"your common sense"},
        {"a really good recipe", "for lasagne"},
        {"two hundred angry bees"},
        {"a patch of evil babies"},
        {"only forward","by ","michael marshall smith"},
        {"someone has printed out","ten years of","alt.startrek.creative"},
        {"That's just an old tin can."},
        {"\"I pity the fool who mistakes", "me for kitten!\",", "sez Mr. T."},
        {"That's just an old tin can."},
        {"It's an altar to the horse god."},
        {"A box of dancing","mechanical pencils.","They dance! They sing!"},
        {"It's an old Duke Ellington record."},
        {"A box of fumigation pellets."},
        {"A digital clock.","It's stuck at 2:17 PM."},
        {"That's just a charred human corpse."},
        {"An empty shopping bag.","Paper or plastic?"},
        {"A coat hanger hovers in thin air.","Odd."},
        {"A freshly-baked pumpkin pie."},
        {"Leonard Richardson is here,","asking people to lick him."},
        {"It's another robot,","more advanced in design than you","but strangely immobile."},
        {"An automated robot-hater.","It frowns disapprovingly", "at you."},
        {"An automated robot-liker.","It smiles at you."}
    }

    return random_n_from_seq(non_kitten_items, 15)
end

function _update()
    if kitten_found then
        if btn(4) or btn(5) then
            _init()
        end
    elseif non_kitten_item_found then
        if btn(4) or btn(5) then
            non_kitten_item_found = false
        end
    else
        move_robot()
        check_collision()
        if sfx_timer>0 then
	        sfx_timer-=1
        end
    end
end

function _draw()
    rectfill(0,0,127,127,background_color)
    foreach(items, draw_item)
    draw_robot()

    if kitten_found then
        draw_message_box({"you found kitten","way to go robot!"},"press a button to play again")
    elseif non_kitten_item_found then
        draw_message_box(current_non_kitten_item.description,"press a button to continue")
    end

    if (debug) then draw_debug() end
end

function check_collision()
    if overlaps(robot.x, kitten.x) and overlaps(robot.y, kitten.y) then
        sfx(2)
        kitten_found = true
        return
    end

    for i in all(items) do
        if i.checked == false and overlaps(robot.x, i.x) and overlaps(robot.y, i.y) then
            sfx(1)
            non_kitten_item_found = true
            current_non_kitten_item = i
            i.checked = true
            return
        end
    end
end

function overlaps(src, dst)
    if src > dst then
        if src - dst < 3 then
            return true
        end
    else
        if dst - src < 3 then
            return true
        end
    end

    return false
end

function create_item(description)
    local item = {}
    local coords = pick_coords()
    item["checked"] = false;
    item["is_kitten"] = false;
    item["x"] = coords.x
    item["y"] = coords.y
    item["glyph"] = item_glyphs[random_number(#item_glyphs)]
    item["color"] = random_color()
    item["description"] = description
    return item
end

function draw_debug()
    local msg = "rx:"..robot.x..",ry:"..robot.y..",kx:"..kitten.x..",ky:"..kitten.y
    print(msg, 0,0, 3);
end

function draw_item(item)
    local color = item.color
    if item.checked then color = checked_item_color end
    print(item.glyph, item.x, item.y, color)
end

function draw_message_box(messages,continue_message)
    local line_count = #messages
    local box_height = (line_count * 6) + 44 --includes padding 42 + 2 for border
    local box_width = (#continue_message * 4) + 8
    for m in all(messages) do
        local line_width = (#m * 4) + 8
        if (line_width > box_width) then
            box_width = line_width
        end
    end

    local top = (128-box_height)/2
    local left = (128-box_width)/2

    rect(left,top,left+box_width,top+box_height,7)
    rectfill(left+1,top+1,left+box_width-1,(top+box_height-1),0)

    line_top = top + 1 + 12
    for m in all(messages) do
        print(m, (128-(#m*4))/2, line_top, 9)
        line_top += 6
    end
    print(continue_message, left+4, line_top+18, 9)
end

function draw_robot()
    print(robot.glyph, robot.x, robot.y, robot_color)
end

function move_robot()
    if btn(0) or btn(1) or btn(2) or btn(3) then
        play_sfx(0)
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
    coords["x"] = random_number(max_x)
    coords["y"] = random_number(max_y)

    if overlaps(coords.x, robot_start_x) and overlaps(coords.y, robot_start_y) then
        return pick_coords()
    end

    for i in all(items) do
        if overlaps(coords.x, i.x) and overlaps(coords.y, i.y) then
            return pick_coords()
        end
    end

    return coords
end

function play_sfx(num)
    if sfx_timer <= 0 then
        sfx(num)
    end
end

function random_color()
    local color = random_number(15)
    if color != robot_color and color != checked_item_color and color != background_color then
        return color
    else
        return random_color()
    end
end

function random_n_from_seq(seq, n)
    local randomised_seq = {}
    local i = 0
    local s = n

    if n > #seq then s = #seq end

    while i < s do
        local pick = seq[random_number(#seq)]
        add(randomised_seq, pick)
        del(seq, pick)
        i += 1
    end
    return randomised_seq
end

function random_number(number_of_items)
    return flr(rnd(number_of_items)) + 1
end

__sfx__
00100000127501575011750056001f5002550001700117002850026500315002c500225000c600136001760019600166002d50014600176001c60000000216000000000000000000000000000000000000000000
0010000034050360502100036000360002f000012000d20009100081000710006100142000710008100081000710007100061000810005000050000a100060000a1000a100060000a10007100091000110003100
001000002d0502c0502d0503205037000300002d0000e0000c0000b00012000100000f0000e0000e0000d0000f000100001200013000000000000000000000000000000000000000000000000000000000000000
