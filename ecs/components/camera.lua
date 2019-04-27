local properties = {
    bounds       = nil,
    translation  = {0, 0},
    scale        = 1,
    scale_limits = nil,
    rotation     = 0,
    viewport     = {0, 0, love.graphics.getWidth(), love.graphics.getHeight()},
}

return {
    author   = "HuwT",
    name     = "camera",
    defaults = properties,
}