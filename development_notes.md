
## ansible-galaxy role import
```
$ ansible-galaxy role import --role-name=$(yq '.galaxy_info.role_name' meta/main.yml) adrianjuhl ansible-role-maven
```
## Notes by version

### v0.3.0

Initial implementation.

### v0.4.0

Exposed additional role parameters in the install script.
