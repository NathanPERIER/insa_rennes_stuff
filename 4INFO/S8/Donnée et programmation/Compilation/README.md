
# Compilation

## Analyseurs Syntaxiques Descendants

**Objectif** : A partir d'une grammaire sans récursivité à gauche, construire un analyseur syntaxique prédictif sans backtracking

Nous prendrons ici l'exemple de la grammaire suivante permettant de consturire des calculs arithmétiques en notation préfixe :

```
E  -> T E'
E' -> + T E' | - T E' | ε
T  -> F T'
T' -> * F T' | / F T' | ε
F  -> ( E ) | id
```

### Null

Soit `X ∈ V_n`, `Null(X)` est vrai ssi :
 - Il existe une production `X -> ε`
 - Il existe une production `X -> Y_1, ..., Y_n` où `∀i, Null(Y_i)`

Exemple :

| `X`       | `E` | `E'` | `T` | `T'` | `F` |
|-----------|-----|------|-----|------|-----|
| `Null(X)` | 0   | 1    | 0   | 1    | 0   |

### First

Soit `X ∈ V_n` :
 - `First(ε) = {}`
 - `First(aβ) = {a}`, `a ∈ V_t`
 - `First(X) = ∪ [X -> β] (First(β))`
 - `¬Null(X) => First(Xβ) = First(X)`
 - ` Null(X) => First(Xβ) = First(X) ∪ First(B)`

Exemple :

| `X`        | `E`                   | `E'`            | `T`       | `T'`            | `F`       |
|------------|-----------------------|-----------------|-----------|-----------------|-----------|
| `First(X)` | `{+, -, *, /, (, id}` | `{+, -, (, id}` | `{(, id}` | `{*, /, (, id}` | `{(, id}` |

### Follows

Soit `X ∈ V_n`, `Follows(X) = (∪ [Y -> αXβ] First(Y)) ∪ (∪ [Y -> αXβ, Null(β)] Follows(Y))`

Soit `S` l'axiome, `eof ∈ Follows(S)`

Exemple : 

Axiome : `S -> E eof`

| `X`          | `S`     | `E`        | `E'`       | `T`                     | `T'`                    | `F`                        |
|--------------|---------|------------|------------|------------------------ |-------------------------|----------------------------|
| `Follows(X)` | `{eof}` | `{), eof}` | `{), eof}` | `{+, -, (, id, ), eof}` | `{+, -, (, id, ), eof}` | `{*, /, (, id, +, -, eof}` |

