# Ansible role: maven

Installs [maven](https://maven.apache.org).

## Requirements

None.

## Role Variables

**maven_version_major**

    adrianjuhl__maven__maven_version_major: 3

The major version of maven to install. Used to determine the URL to the maven install file on apache.org.

**maven_version**

    adrianjuhl__maven__maven_version: 3.8.7

The version of maven to install.

**maven_install_dir**

    adrianjuhl__maven__maven_install_dir: /opt/maven

The directory to install maven into.

## Dependencies

None.

## Example Playbook
```
- hosts: servers
  roles:
    - { role: adrianjuhl.maven }

or

- hosts: servers
  tasks:
    - name: Install maven
      include_role:
        name: adrianjuhl.maven
```

## License

MIT

## Author Information

[Adrian Juhl](http://github.com/adrianjuhl)
