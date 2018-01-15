--Lib : Advanced Nodeboxes[adv_boxes]
--© Lars Müller @appguru.eu, licensed under CC-BY-SA 3.0
--Rotates nodeboxes around the y-axis

--Defaults--
CONNECTIONS={2, 3, 1, 0}
RECTANGLE={0,1,1,0,1,1,0,0}
STEPS=4 --Accuracy of rotated nodeboxes

function rotate_point(x, y, degrees)
    local deg = math.deg(math.atan2(y, x))
    local distance = math.sqrt(x * x + y * y)
    if (deg < 0) then
        deg = deg+360
    end
    deg = deg+degrees;
    if (deg > 360) then
        deg = deg-360
    end
    if (deg < 0) then
        deg = deg+360
    end
    deg = math.rad(deg);
    return {distance * math.cos(deg), distance * math.sin(deg)};
end

function rotateNodeboxYAxis(nodebox, degrees)
    local rect={nodebox[1], nodebox[3], nodebox[4], nodebox[6]}
    local corners={}
    for value = 1,8,2 do
        local x=rect[1+RECTANGLE[value]]
        local y=rect[3+RECTANGLE[value+1]]
        local rotated_point=rotate_point(x,y,degrees)
        corners[value]=rotated_point[0]
        corners[value+1]=rotated_point[1]
    end
    local index=1
    local rectangles={}
    for value = 1,8,2 do
        local x = corners[value]
        local y = corners[value+1]
        local dif_x = corners[CONNECTIONS[value]*2] - x
        local dif_y = corners[CONNECTIONS[value]*2+1] - y
        local width = dif_x / STEPS
        local height = dif_y / STEPS
        for i = 1,STEPS,1 do
            rectangles[index]={x,y,x+width,y+height}
            x = x+width
            y = y+height
            index=index+1
        end
    end
    local nodeboxes={}
    index=1
    for rectangle in pairs(rectangles) do
        nodeboxes[index]={math.min(rectangle[1], rectangle[3]),nodebox[2],math.min(rectangle[2], rectangle[4]),math.max(rectangle[1], rectangle[3]),nodebox[5],math.max(rectangle[2], rectangle[4])}
        index=index+1
    end
    return nodeboxes
end

function rotateMultipleNodeboxesYAxis(nodeboxes, degrees)
    local result={}
    for nodebox in pairs(nodeboxes) do
        result=table.concat(result, rotateNodeboxYAxis(nodebox,degrees))
    end
    return result
end

minetest.chat_send_all(rotateNodeboxYAxis({-0.5,-0.5,-0.5,0.5,0.5,0.5},45))