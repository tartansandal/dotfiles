# Big heading

## Medium heading

### Small heading

Plain paragraph with **bold**, *italic*, and `monospace` text.
A soft-wrapped line joins the one above it.

Escaping check: a literal [bracket] and a ~/dotfiles path should survive.
(Paired tildes are subscript syntax, so they are not a safe literal.)

- bullet one
- bullet two
  - nested bullet
    - deeper still
- bullet three

1. ordered one
2. ordered two
   1. nested ordered
3. ordered three

Mixed nesting:

- bullet parent
  1. ordered child
  2. ordered child two

A [labelled link](https://example.com) and a bare <https://example.com>.
An internal page reference: [Algorithm Team - Wiki](235602).

```python
def f(*args, **kwargs):
    # asterisks and underscores must survive verbatim
    return __name__
```

| Element | Markdown | cbX |
| --- | --- | --- |
| bold | `**x**` | `__x__` |
| italic | `*x*` | `''x''` |
| pipe | a \| b | escaped |

Term
: The definition of the term.

---

Fallbacks: ~~strikeout~~ and H~2~O have no cbX form.

> A block quote also has no direct equivalent.
