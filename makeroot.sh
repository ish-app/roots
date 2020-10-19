#!/bin/sh
output="$1"
input="$2"
script="$3"

dir="$(dirname "$0")"
root="$dir/root"
b="$dir/../../build/"

function script() {
    "$b/ish" -f "$root" /bin/sh -
}

rm -rf "$root"
rm -f "$output"
"$b/tools/fakefsify" "$input" "$root"
source "$script"
"$b/tools/unfakefsify" "$root" "$output"
rm -rf "$root"
