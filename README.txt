pts-tcc64: tiny, self-contained C compiler for Linux amd64 using TCC + glibc

This is similar to pts-tcc (https://github.com/pts/pts-tcc), with the
following differences:

* The target of the compiler is Linux amd64 (rather than Linux i386).
* TCC (TinyCC) version is newer (0.9.27).
* The compiler generates dynamically linked Linux executables linked against
  glibc (rather than statically linked with built in uClibc).

__END__
