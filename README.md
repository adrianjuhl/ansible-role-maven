# Ansible role: maven

Installs [maven](https://maven.apache.org).

## Requirements

* Ansible >= 2.10
* Ansible collection community.general >= 5.1.0

## Role Variables

**maven_version_major**

    adrianjuhl__maven__version_major: 3

The major version of maven to install. Used to determine the URL to the maven install file on apache.org.

**version**

    adrianjuhl__maven__version: 3.8.7

The version of maven to install.

**filename**

    adrianjuhl__maven__filename: "apache-maven-{{ adrianjuhl__maven__version }}-bin.tar.gz"

The name of the maven download file.

**install_director**

    adrianjuhl__maven__install_directory: /opt/maven

The directory to install maven into.

**source_directory**

    adrianjuhl__maven__source_directory: "http://archive.apache.org/dist/maven/maven-{{ adrianjuhl__maven__version_major }}/{{ adrianjuhl__maven__version }}/binaries"

The source location of the maven download file.

**download_directory**

    adrianjuhl__maven__download_directory: "{{ ansible_env.HOME + '/.ansible/tmp/downloads' }}"

The directory into which the maven download file is to be placed.

**file_checksum**

    adrianjuhl__maven__file_checksum: "{{ adrianjuhl__maven__file_checksums[adrianjuhl__maven__version] }}"

The checksum with which to check the downloaded file. The role contains the checksums for many of the releases of maven (in the adrianjuhl__maven__file_checksums dictionary).

**alternatives_priority**

    adrianjuhl__maven__alternatives_priority: 50

The priority to give the installed maven version.

**alternatives_state**

    adrianjuhl__maven__alternatives_state: selected

The state that the alternative is to be set to. Options include: present, selected, auto, absent. see: https://docs.ansible.com/ansible/latest/collections/community/general/alternatives_module.html

### Supported maven versions

The following version of maven are supported for install without any further configuration:

`3.9.0`,

`3.8.1`, `3.8.2`, `3.8.3`, `3.8.4`, `3.8.5`, `3.8.6`, `3.8.7`,

`3.6.0`, `3.6.1`, `3.6.2`, `3.6.3`,

`3.5.3`, `3.5.4`,

`3.3.9`,

`3.2.5`,

`3.1.1`,

`3.0.5`

For other versions, the variable `adrianjuhl__maven__file_checksum` needs to be set to either:
* the checksum of the maven file being downloaded, in the format `<algorithm>:<checksum>`, so as to check the validity of the download, or,
* `""` (the empty string), to skip the checksum check

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
