#!/usr/bin/env bash

set -euo pipefail

# TODO
set -x

GH_REPO="https://github.com/astral-sh/python-build-standalone"
TOOL_NAME="python"
TOOL_TEST="--version"

function fail() {
    echo -e "asdf-${TOOL_NAME}: ${*}"
    exit 1
}

# global vars
curl_opts=(-fsSL)

if [[ -n "${GITHUB_API_TOKEN:-}" ]]; then
    curl_opts+=(-H "Authorization: token ${GITHUB_API_TOKEN}")
fi

function sort_versions() {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' \
        | LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

function get_latest_name() {
    curl -sSfL https://api.github.com/repos/astral-sh/python-build-standalone/releases/latest \
        | jq '.name' | sed 's/"//g'
}

function list_latest_assets() {
    curl -sSfL https://api.github.com/repos/astral-sh/python-build-standalone/releases/latest \
        | jq '.assets.[] | select(.name | match("^cpython-.*.tar.zst$"; "im")) | .name'
}

function list_python_versions() {
    list_latest_assets | grep -oE 'cpython-[0-9]\.[0-9]+\.[0-9]+\+' | grep -oE '[0-9]\.[0-9]+\.[0-9]+' | uniq
}

function list_all_versions() {
    # currently all tags are valid releases, so this works
    list_python_versions
}

function get_platform() {
    local _platform platform _arch arch

    _platform="$(uname -s)"
    _arch="$(uname -m)"

    case "${_platform}" in
        "Linux")
            platform="unknown-linux-gnu"

            case "${_arch}" in
                "x86_64" | "amd64")
                    arch="x86_64_v2"
                    ;;
                "arm64" | "aarch64")
                    arch="aarch64"
                    ;;
                *)
                    fail "This arch is currently not supported"
                    ;;
            esac
            ;;

        "Darwin")
            platform="apple-darwin"

            case "${_arch}" in
                "x86_64" | "amd64")
                    arch="x86_64"
                    ;;
                "arm64" | "aarch64")
                    arch="aarch64"
                    ;;
                *)
                    fail "This arch is currently not supported"
                    ;;
            esac
            ;;
        *)
            fail "This platform is currently not supported"
            ;;
    esac

    echo -n "${arch}-${platform}"
}

function download_release() {
    local version download_path url platform release_tar

    version="${1}"
    download_path="${2}"
    platform="$(get_platform)"
    release_name="$(get_latest_name)"
    release_tar="cpython-${version}+${release_name}-${platform}-install_only_stripped.tar.gz"

    url="${GH_REPO}/releases/download/${release_name}/${release_tar}"

    mkdir -p "${download_path}"

    echo "* Downloading ${TOOL_NAME} ${version} from ${url}"
    if ! curl "${curl_opts[@]}" -o "${download_path}/${release_tar}" -C - "${url}"; then
        fail "Could not download ${url}"
    fi

    if ! tar -vxf -C "${download_path}" "${download_path}/${release_tar}"; then
        fail "Could not extract ${release_tar}"
    fi
    rm -f "${download_path}/${release_tar}"
}

function install_version() {
    local version install_path download_path

    version="${1}"
    install_path="${2%/bin}"
    download_path="${3}"

    mkdir -p "${install_path}"

    mv -f "${download_path}/python" "${install_path}"
    chmod +x "${install_path}"/bin/*

    if [[ ! -x "${install_path}/bin/${TOOL_NAME}" ]]; then
        rm -rf "${install_path}"
        fail "Expected ${install_path}/bin/${TOOL_NAME} to be executable"
    fi
    if ! "${install_path}/bin/${TOOL_NAME}" "${TOOL_TEST}" > /dev/null; then
        rm -rf "${install_path}"
        fail "Error with command: '${TOOL_NAME} ${TOOL_TEST}'"
    fi

    echo "${TOOL_NAME} ${version} installation was successful!"
}
