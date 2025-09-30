# ESP32-S3-Touch-LCD-2.8

## Summary

This project is to build the ESP32-S3-Touch-LCD-2.8 demo source code.

## Get source code

```
scripts/get-source.sh
```

## Prepare devcontainer

```
devcontainer build --workspace-folder . --config .devcontainer/devcontainer.json
devcontainer up --workspace-folder . --config .devcontainer/devcontainer.json --remove-existing-container
devcontainer exec --workspace-folder . --config .devcontainer/devcontainer.json bash
```

## Build

```
cd src
idf.py set-target esp32s3
idf.py build
```

## for LSP

```
cd src
rm -rf build
idf.py reconfigure
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

## Build and flash using v5.2 builder container

```
DEV=/dev/ttyACM0;docker run --rm -it -v ${PWD}:/mnt/work -w /mnt/work --device=${DEV} --group-add $(stat -c '%g' ${DEV}) ghcr.io/wurly200a/builder-esp32/esp-idf-v5.3:latest
```

```
docker run --rm -it -v ${PWD}:/mnt/work -w /mnt/work ghcr.io/wurly200a/builder-esp32/esp-idf-v5.3:latest
```

```
idf.py set-target esp32s3
idf.py reconfigure -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
idf.py build
idf.py -p /dev/ttyACM0 flash monitor
```
