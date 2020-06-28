# shellbro/clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/clojure)](https://hub.docker.com/r/shellbro/clojure/)

Container image for everyday Clojure.

## Why this image?

This is stock Clojure container image with minor tweaks and opinions:
1. It targets OpenJDK 11 and is based on Debian 10 (Buster).
2. Contains `tools.deps` as a tool of choice for dependency managment.
3. Uses non-root user by default. `UID` and `GID` can be both customized with
   Docker build args if you wish but Docker Hub hook sets it to sensible
   defaults (`1000:1000`). Thanks to this it is easy to share host directory
   `$HOME/.m2` with container and download dependencies only once without
   permission issues.
4. Implements `rlwrap` workaround in such a way that you can call `clj` or
   `clojure` commands passing any arguments. For example, to start a REPL with
   `clojure.java-time` dependency available use `-Sdeps` argument accordingly:

   ```
   $ sudo docker run --rm -it --detach-keys=ctrl-@\
                     -v "$HOME/.m2:/home/app-user/.m2"\
                     shellbro/clojure clj -Sdeps\
                     '{:deps {clojure.java-time {:mvn/version "0.3.2"}}}'
   ```
5. It is strictly versioned. Every image tag has a Unix time suffix indicating
   its release time.

## Ad hoc containerized Clojure REPL

To have your Clojure REPL always at hand add the following function to your
`.bashrc` file. This function takes your `EDN` deps as an argument and makes
sure you didn't forget important `docker run` options for REPL to be fully
working (like `--detach-keys` without which `docker` will intercept `readline`
keybiding `Ctrl-p`).


```
function repl {
  sudo docker run --rm -it --detach-keys=ctrl-@\
                  -v "$HOME/.m2:/home/app-user/.m2"\
                  shellbro/clojure clj -Sdeps "{:deps ${1:-{}}}"
}
```

This time, to quickly spawn your Clojure REPL with `clojure.java-time`
dependency just run:

```
$ repl '{clojure.java-time {:mvn/version "0.3.2"}}'
user=> (require '[java-time :as t])
nil
user=> (t/as (t/local-date) :year)
2020
```

Note that when using `repl` function `:deps` level is already in place for user
convenience.
