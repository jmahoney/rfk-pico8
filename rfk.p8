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

 glyphs = {"@","!","#","$","%","^","&","*","(",")"}

 robot = {}
 robot["x"] = 64
 robot["y"] = 64
 robot["glyph"] = "@"

 game_objs = {}

end

function draw_robot()
    print(robot.glyph, robot.x, robot.y, 8)
end

-- function create_item(location)
--     local item =
-- end

function move_robot()
    if (btn(0)) then
        if (robot.x>1) then robot.x=robot.x-1 end
    end
    if (btn(1)) then
        if (robot.x<125) then robot.x=robot.x+1 end
    end
    if (btn(2)) then
        if (robot.y>1) then robot.y=robot.y-1 end
    end
    if (btn(3)) then
        if (robot.y<123) then robot.y=robot.y+1 end
    end
end

function random_color(num)
    return flr(rnd(num))+1
end

function _update()
    move_robot()
end

function _draw()
    rectfill(0,0,127,127,1)
    -- print(descriptions[10],0,0,random_color(16))
    draw_robot();
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
