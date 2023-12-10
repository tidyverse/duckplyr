duckplyr 0.3.0

## R CMD check results

- [x] Checked locally, R 4.3.2
- [x] Checked on CI system, R 4.3.2
- [x] Checked on win-builder, R devel

## Current CRAN check results

- [x] Checked on 2023-12-10, problems found: https://cran.r-project.org/web/checks/check_results_duckplyr.html
- [ ] other_issue: NA
See: <https://www.stats.ox.ac.uk/pub/bdr/gcc12/duckplyr.out>
- [ ] other_issue: NA
See: <https://www.stats.ox.ac.uk/pub/bdr/gcc12/duckplyr.out>
- [ ] WARN: r-devel-linux-x86_64-debian-gcc
     Found the following significant warnings:
     relational.c:35:27: warning: format ‘%p’ expects argument of type ‘void *’, but argument 2 has type ‘SEXP’ {aka ‘struct SEXPREC *’} [-Wformat=]
     See ‘/home/hornik/tmp/R.check/r-devel-gcc/Work/PKGS/duckplyr.Rcheck/00install.out’ for details.
     * used C compiler: ‘gcc-13 (Debian 13.2.0-7) 13.2.0’
- [ ] WARN: r-devel-linux-x86_64-fedora-gcc
     Found the following significant warnings:
     relational.c:35:27: warning: format '%p' expects argument of type 'void *', but argument 2 has type 'SEXP' {aka 'struct SEXPREC *'} [-Wformat=]
     See ‘/data/gannet/ripley/R/packages/tests-devel/duckplyr.Rcheck/00install.out’ for details.
     * used C compiler: ‘gcc-13 (GCC) 13.2.0’
- [ ] WARN: r-devel-windows-x86_64
     Found the following significant warnings:
     relational.c:35:27: warning: format '%p' expects argument of type 'void *', but argument 2 has type 'SEXP' {aka 'struct SEXPREC *'} [-Wformat=]
     See 'd:/Rcompile/CRANpkg/local/4.4/duckplyr.Rcheck/00install.out' for details.
     * used C compiler: 'gcc.exe (GCC) 12.3.0'

Check results at: https://cran.r-project.org/web/checks/check_results_duckplyr.html
