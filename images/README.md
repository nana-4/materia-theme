Optimize PNG images using `zopflipng`:

```sh
find images/ -iname "*.png" -exec zopflipng -m -y '{}' '{}' \;
```
