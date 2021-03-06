#! /bin/sh

url="$1"
protocol="${url%%:*}"
path="${url#$protocol://}"
server="${path%%/*}"
basepath="${path%/*}"
relpath="${path#$server}"

echo "URL: $url" >&2

curl -A 'text/html; text/xhtml; text/xml; */*' -L -k "$url" | sed -re 's/^/-/;s/[^a-zA-Z][hH][rR][eE][fF]=("([^"]*)"|'\''([^'\'']*)'\''|([^"'\'' <>&]+)[ <>&])/\n+\2\3\4\n-/g' | \
  sed -e '/^-/d; s/^[+]//; /^#/d;'"s/^\\//$protocol:\\/\\/$server\\//g" | \
  sed -re 's`^[^:]*$`'"$protocol://$basepath/&\`"
