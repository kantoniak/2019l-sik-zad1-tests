# 2019l-sik-zad1-test

Uruchamianie:

```
./test.sh <ścieżka-do-testhttp>
```

Testy sprawdzają:
* Czy `stdout` jest dokładnie taki sam (strony z ciasteczkami typu id sesji nie działają)
* Czy program zwraca `0` czy kod błędu (dowolny niezerowy)
* Jeśli kod jest `0` to czy `stderr` jest pusty

## Dodawanie testów

1. Dopisz nazwę testu w `generate-outputs.sh`
2. Wpisz argumenty dla `xargs` w `tests/<test>.args`
3. `./generate-outputs.sh`
