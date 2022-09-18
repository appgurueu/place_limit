# Place Limit(`place_limit`)
A mod limiting how fast players can place nodes.

> Let's kill 'em ! Got... where's he gone ? Wait... up there, on the tower... how could he build it so fast ?!

\- me, playing Minetest

Problem solved by this mod.

## About

Depends on [`modlib`](https://github.com/appgurueu/modlib) and [`hud_timers`](https://github.com/appgurueu/hud_timers).

**Please note that this mod may not work along well with other mods overriding registering on_placenodes and that it may be recommended to use the API.**

Licensed under the MIT License. Written by Lars Mueller alias LMD or appguru(eu).

## Configuration

<!--modlib:conf:2-->
### `cooldown`

#### `by_group`

Cooldown by node group. Will be multiplied with node group value.

#### `by_name`

Cooldown by node name.

#### `default`

Default cooldown value - only used if no `by_group` or `by_node` cooldown specified for given node.

* Type: number
* Default: `3`
* &gt;= `0`

<!--modlib:conf-->

In the end, the maximum cooldown value of all `by_group` cooldowns and the `by_name` cooldown is used.
