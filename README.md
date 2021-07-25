# PantherX Software Assets

Icons and screenshots for applications found in PX Software.

`https://assets.software.pantherx.org/blender/icons/28399ab8-36e7-456c-85d1-4b11dcbce1e7.svg`

## Overview

```
application
 - icons
   - e9a4d99c-724c-4fe5-a61f-99ea85da47a1.svg
 - screenshots
   - e3307dd2-3403-4f28-b137-55ee8b4ff120.jpg
   - 540179c6-35d6-4bae-af8f-3a351f4dd356.jpg
```

- Use [Version 4 UUID Generator](https://www.uuidgenerator.net/version4) to generate a UUID
- For new applications, use the binary name. For ex. `blender`
- For icons use `.svg` and store in `blender/icons`
- For screenshots use `.jpg` and store in `blender/screenshots`

Any screenshot should be taken at `1440x900px`. Use `xrandr -s 1440x900`.


## Add Software to DB

run as follow:
```bash
$ ./add_to_db.sh <package_name> <category>
```

Example:
```bash
$ ./add_to_db.sh telegram-desktop communication
```

* A `rec` file will be added in the `./packages/<package_name>.rec`.
* Add the above `rec` file to repo and commit, finally create a tag.

**Note:**
 * The `icon` and `screenshot` fields won't be filled by above script and you should add and fill them manually.
 * `Category` list: name: `development`, `finance`, `communication`, `education`, `entertainment`, `games`, `music`, `photography`, `utilities`, `browser`.
 * You can Add new Category, for this the `category.rec` file should be updated.
