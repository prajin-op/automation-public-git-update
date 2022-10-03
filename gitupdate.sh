#!/bin/sh

GIT_MIRROR_TMP="$(pwd)/tmp/mirror"

git_mirror_cleanup() {
    rm -rf "$GIT_MIRROR_TMP"
}

git_mirror() {
    git_mirror_cleanup
    mkdir -p "$GIT_MIRROR_TMP"
    cd "$GIT_MIRROR_TMP"

    local FROM_REPOSITORY=github.tools.sap/I572426/automation-public-git-updates.git
    local FROM_USER=i572426
    local FROM_PASSWORD=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
    local TO_REPOSITORY=github.com/prajin-op/automation-public-git-update.git
    local TO_USER=prajin-op
    local TO_PASSWORD=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

    #trap 'git_mirror_cleanup' TERM INT EXIT

    if [ "$FROM_USER" != "" ]; then
        FROM_CREDENTIALS="$FROM_USER:$FROM_PASSWORD@"
    fi

    if [ "$TO_USER" != "" ]; then
        TO_CREDENTIALS="$TO_USER:$TO_PASSWORD@"
    fi

    local FROM_REPO_NAME="$(basename $FROM_REPOSITORY)"

    echo "[INFO] Mirroring https://$FROM_REPOSITORY => https://$TO_REPOSITORY"

    echo "https://${FROM_CREDENTIALS}${FROM_REPOSITORY}"
    echo "https://${TO_CREDENTIALS}${TO_REPOSITORY}"
    git clone --bare "https://${FROM_CREDENTIALS}${FROM_REPOSITORY}" "$FROM_REPO_NAME"
    cd "$FROM_REPO_NAME"
    git push --mirror "https://${TO_CREDENTIALS}${TO_REPOSITORY}"

}

git_mirror
