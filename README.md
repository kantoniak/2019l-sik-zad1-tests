# 2019l-sik-zad1-test

Uruchamianie:

```
./test.sh <ścieżka-do-testhttp>
```

Testy sprawdzają:
* Czy `stdout` jest dokładnie taki sam (strony z ciasteczkami typu id sesji nie działają)
* Czy program zwraca `0` czy kod błędu (dowolny niezerowy)
* Jeśli kod jest `0` to czy `stderr` jest pusty

## Błędy

Wyjścia `stdout` i `stderr` są zapisywane do folderu tymczasowego, podanego w konsoli. W przypadku błędu skrypt ich nie usuwa.

* `xargs exitcode: A, should be B`: Program `./testhttp` zwrócił inny kod zakończenia niż powinien. Narzędzie `xargs` zmienia kody błędów, np. `1` przechodzi na `123`. Zobacz [listę kodów](http://man7.org/linux/man-pages/man1/xargs.1.html#EXIT_STATUS).

## Dodawanie testów

1. Dopisz nazwę testu w `generate-outputs.sh`
2. Wpisz argumenty dla `xargs` w `tests/<test>.args`
3. `./generate-outputs.sh`
