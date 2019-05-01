# Place Limit - Configuration

## Locations

JSON Configuration : `<worldpath>/config/place_limit.json`

Text Logs : `<worldpath>/logs/place_limit/<date>.json`

Explaining document(this, Markdown) : `<modpath/gamepath>/place_limit/config_help.md`

Readme : `<modpath/gamepath>/place_limit/Readme.md`

## Default Configuration
Located under `<modpath/gamepath>/place_limit/default_config.json`
```json
{
  "cooldown": {
    "default": 3.0,
    "by_name": {},
    "by_group": {}
  }
}
```

## Usage

### `cooldown`

#### `default`
Default cooldown value - only used if no `by_group` or `by_node` cooldown specified for given node.

#### `by_name`
Cooldown by node name.

#### `by_group`
Cooldown by node group. Will be multiplied with node group value.

*In the end, maximum cooldown value of all `by_group` and the `by_name` cooldown is used*