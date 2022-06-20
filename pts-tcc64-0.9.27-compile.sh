#! /bin/sh --
# by pts@fazekas.hu at Mon Jun 20 13:45:57 CEST 2022
#
# * Compile it on a Linux amd64 system with gcc installed, preferably
#   Ubuntu 14.04 amd64.
# * The crt*.o files are from Ubuntu 14.04 amd64.
#

set -ex
test -f libcdata.tbz2
test -f pts-tcc64-0.9.27.patch
test -f tcc-0.9.27.tar.bz2
rm -rf pts-tcc64.build
tar xjvf tcc-0.9.27.tar.bz2
mv tcc-0.9.27 pts-tcc64.build
(cd pts-tcc64.build && patch -p1) <pts-tcc64-0.9.27.patch || exit "$?"
(cd pts-tcc64.build && tar -xjv) <libcdata.tbz2 || exit "$?"
(cd pts-tcc64.build && ./configure) || exit "$?"
(cd pts-tcc64.build && for F in libtcc1.a crt1.o crti.o crtn.o; do
  G="${F##*/}"
  NAME="data_${G%.*}"
  echo ".globl $NAME"; echo ".section .data"; echo "$NAME:"
  if test "${F%.a}" != "$F"; then
    echo ".incbin \"$F\""; echo ".string \"\\\\001\""
  else
    echo ".incbin \"libcdata/$F\""
  fi
done >libcdata.s) || exit "$?"
(cd pts-tcc64.build && make tcc.o libtcc.a) || exit "$?"
: >pts-tcc64.build/libtcc1.a  # Temporary.
(cd pts-tcc64.build && gcc -s -o tcc tcc.o libtcc.a libcdata.s) || exit "$?"
rm -f pts-tcc64.build/libtcc1.a
(cd pts-tcc64.build && make libtcc1.a) || exit "$?"  # Needs tcc.
rm -f pts-tcc64.build/tcc
(cd pts-tcc64.build && gcc -s -o pts-tcc64 tcc.o libtcc.a libcdata.s) || exit "$?"
ls -ld pts-tcc64.build/pts-tcc64

: "$0" OK.
