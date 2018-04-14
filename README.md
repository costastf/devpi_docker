### pip

Use a configuration similar to this in your `~/.pip/pip.conf`:

```ini
[global]
index-url = http://localhost:3141/root/pypi/+simple/
```

### setuptools

Use a configuration similar to this in your `~/.pydistutils.cfg`:

```ini
[easy_install]
index_url = http://localhost:3141/root/pypi/+simple/
```
