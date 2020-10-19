dir="$(dirname "$0")"
root="$dir/root"
tarballs="$dir/tarballs"
b="$dir/../../build/"

function root_import() {
    rm -rf "$root"
    "$b/tools/fakefsify" "$tarballs/$1" "$root"
}

function root_export() {
    rm -f "$tarballs/$1"
    "$b/tools/unfakefsify" "$root" "$tarballs/$1"
    rm -rf "$root"
}

function script() {
    "$b/ish" -f "$root" /bin/sh -
}
