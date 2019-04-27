local properties = {
    position = {0, 0, 0},
    velocity = {0, 0, 0},
    shape    = {"ellipse", 16, 16},
            -- {"ellipse",   rx, ry},
            -- {"rectangle", w, h},
            -- {"polyon",    x1 y1, x2, y2, ...},
    mass     = 0,
    volume   = 0,
}

return {
    author   = "HuwT",
    name     = "physical",
    defaults = properties,
}