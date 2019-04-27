local blueprint = {}

blueprint.author = "HuwT"
blueprint.name   = "person"

blueprint.components = {
    creature = {
        mouth        = 3,
        sight        = 2,
        movement     = 4,
        manipulation = 4,
        sentience    = 3,
    },
    renderable = {},
    physical = {
        position = {0, 0, 0},
        shape = {}
    },
}

return blueprint
