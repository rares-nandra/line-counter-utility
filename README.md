# Simple bash script for counting lines in all files of a directory (including subdirectories) or specific files

## Usage

### Flags

* -d List of all directories (and all thei subdirectories) to search

  ```
  -d ./Components ./src ./node_modules ~/Desktop ../../Project
  ```
* -f List of all the file to search

  ```
  -f App.js app.json main.cpp
  ```

### Example

```
./line_counter.sh -d ./Project -f Project.config.json

```
