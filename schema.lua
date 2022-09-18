return {
    type = "table",
    entries = {
        cooldown = {
            type = "table",
            entries = {
                default = {
                    type = "number",
                    range = { min = 0 },
					default = 3,
					description = "Default cooldown value - only used if no `by_group` or `by_node` cooldown specified for given node."
                },
                by_name = {
                    type = "table",
                    keys = { type = "string" },
                    values = { type = "number", range = { min = 0 } },
					default = {},
					description = "Cooldown by node name."
                },
                by_group = {
                    type = "table",
                    keys = { type = "string" },
                    values = { type = "number", range = { min = 0 } },
					default = {},
					description = "Cooldown by node group. Will be multiplied with node group value."
                }
            }
        }
    }
}