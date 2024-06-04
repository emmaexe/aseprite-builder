#!/bin/bash

WORK_DIR=$(dirname -- "$(readlink -f -- "$0")")

# Install script dependencies
install_script_dependencies() {
    echo "$ apt update" && sudo -k apt update && echo -e -n "\n"
    echo "$ apt install curl unzip git" && sudo -k apt install -y curl unzip git && echo -e -n "\n"
}

# Find or temp-install gum
find_install_gum() {
    GUM=$(whereis -b gum | awk '{print $2}')
    if [ -z "$GUM" ]; then
        echo "Gum not found, installing temporarly"
        GUM_TMP_DIR="$(mktemp -d)"
        GUM="${GUM_TMP_DIR}/gum"
        curl -fsSL "https://bina.egoist.dev/charmbracelet/gum?dir=${GUM_TMP_DIR}" | bash
    else
        echo "Gum found: $GUM"
    fi
}

# Find latest release URLs
find_latest_release_url() {
    ASEPRITE_LATEST_URL=$(curl -s https://api.github.com/repos/aseprite/aseprite/releases/latest | jq --raw-output '.assets[0] | .browser_download_url')
    SKIA_LATEST_URL=$(curl -s https://api.github.com/repos/aseprite/skia/releases/latest | jq --raw-output '.assets[] | select(.name == "Skia-Linux-Release-x64-libstdc++.zip") | .browser_download_url')
}

# Download and unzip project
download_project() {
    $GUM spin --title="Downloading skia" --show-error -- curl -Lo "$WORK_DIR/skia.zip" "$SKIA_LATEST_URL" && echo "Downloaded skia."
    $GUM spin --title="Extracting skia" --show-error -- unzip "$WORK_DIR/skia.zip" -d "$WORK_DIR/skia/" && echo "Extracted skia."
    rm "$WORK_DIR/skia.zip"
    SKIA_DIR="$WORK_DIR/skia"

    $GUM spin --title="Downloading aseprite" --show-error -- curl -Lo "$WORK_DIR/aseprite.zip" "$ASEPRITE_LATEST_URL" && echo "Downloaded aseprite."
    $GUM spin --title="Extracting aseprite" --show-error -- unzip "$WORK_DIR/aseprite.zip" -d "$WORK_DIR/aseprite/" && echo "Extracted aseprite."
    rm "$WORK_DIR/aseprite.zip"
    ASEPRITE_DIR="$WORK_DIR/aseprite"
}

# Install build dependencies
install_build_dependencies() {
    echo "$ apt install -y g++ clang libc++-dev libc++abi-dev cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev" && sudo -k apt install -y g++ clang libc++-dev libc++abi-dev cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev && echo -e -n "\n"
}

# Build project
build_project() {
    mkdir "$ASEPRITE_DIR/build" && cd "$ASEPRITE_DIR/build"
    $GUM spin --title="Preparing to build (cmake)" --show-error -- cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLAF_BACKEND=skia -DSKIA_DIR=$SKIA_DIR ..
    $GUM spin --title="Building aseprite" --show-error --show-output -- ninja aseprite
    BUILT_DIR="$ASEPRITE_DIR/build/bin"
}

# Install project
install_project() {
    clear
    echo -e 'Aseprite was built.\nPlease select an install directory.\nIn the directory you select a new directory will be created and the program will be installed there.'
    while true; do
        PARENT_PATH=$($GUM file "$WORK_DIR" --directory)
        if [ -d "$PARENT_PATH" ]; then
            break
        else
            clear
            echo -e 'Aseprite was built.\nPlease select an install directory.\nIn the directory you select a new "aseprite" directory will be created and the program will be installed there.'
            echo -e '\033[0;31mPlease select a valid directory!\033[0m'
        fi
    done

    clear
    while true; do
        INSTALL_NAME=$($GUM input --placeholder="aseprite" --header="Pick a name for your new directory:" --value="aseprite")
        INSTALL_PATH="$PARENT_PATH/$INSTALL_NAME"
        if [ ! -e "$INSTALL_PATH" ]; then
            mkdir "$INSTALL_PATH"
            clear
            echo "Installing aseprite to $INSTALL_PATH"
            break
        else
            clear
            echo -e '\033[0;31mA file or directory already exists with that name!\033[0m'
        fi
    done

    cp -r $BUILT_DIR/* $INSTALL_PATH/
}

# End
end() {
    $GUM style --foreground 121 --border double --align center --width 50 --margin "1 2" --padding "2 4" 'Aseprite was installed.' 'It is now safe to delete aseprite-build.'
}

# Exit on error
set -e
install_script_dependencies
find_install_gum
find_latest_release_url
download_project
install_build_dependencies
build_project
install_project
end
