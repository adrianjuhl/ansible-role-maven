# Ansible role: maven

Installs [maven](https://maven.apache.org).

The `mvn` command is incorporated into the alternatives system.

## Requirements

* Ansible >= 2.10
* Ansible collection community.general >= 5.1.0

## Role Variables

**version**

    adrianjuhl__maven__version: "3.9.6"

The version of maven to install.

**version_major**

    adrianjuhl__maven__version_major: "{{ adrianjuhl__maven__version.split('.')[0] }}"

The major version of maven to install. Used to determine the URL to the maven install file on apache.org.

**archive_filename**

    adrianjuhl__maven__archive_filename: "apache-maven-{{ adrianjuhl__maven__version }}-bin.tar.gz"

The name of the maven download file.

**install_directory**

    adrianjuhl__maven__install_directory: "/opt/maven"

The directory in which to install maven.

**source_directory**

    adrianjuhl__maven__source_directory: "http://archive.apache.org/dist/maven/maven-{{ adrianjuhl__maven__version_major }}/{{ adrianjuhl__maven__version }}/binaries"

The source location of the maven download file.

**download_directory**

    adrianjuhl__maven__download_directory: "{{ ansible_env.HOME }}/.ansible/tmp/downloads/maven/maven-{{ adrianjuhl__maven__version_major }}/{{ adrianjuhl__maven__version }}"

The directory into which the maven download file is to be placed.

**archive_file_checksum**

    adrianjuhl__maven__archive_file_checksum: "{{ adrianjuhl__maven__archive_file_checksums[adrianjuhl__maven__version].algorithm }}:{{ adrianjuhl__maven__archive_file_checksums[adrianjuhl__maven__version].checksum }}"

The checksum with which to check the downloaded archive file. The role contains the checksums for many of the releases of maven (in the adrianjuhl__maven__archive_file_checksums dictionary).

**alternatives_priority**

    adrianjuhl__maven__alternatives_priority: 50

The priority to give the installed maven version.

**alternatives_state**

    adrianjuhl__maven__alternatives_state: "selected"

The state that the alternative is to be set to. Options include: present, selected, auto, absent. see: https://docs.ansible.com/ansible/latest/collections/community/general/alternatives_module.html

### Supported maven versions

The following versions of maven are supported for install without any further configuration:

`3.9.6` (default)

`3.9.0`

`3.8.7` `3.8.6` `3.8.5` `3.8.4` `3.8.3` `3.8.2` `3.8.1`

`3.6.3` `3.6.2` `3.6.1` `3.6.0`

`3.5.4` `3.5.3`

`3.3.9`

`3.2.5`

`3.1.1`

`3.0.5`

For other versions, the variable `adrianjuhl__maven__archive_file_checksum` needs to be set in one of two ways depending on whether checksum validation is desired:
* if checksum validation of the download file is desired, set the value of `adrianjuhl__maven__archive_file_checksum` to the checksum for the version of the maven file being downloaded, in the format `<algorithm>:<checksum>`, for example: `adrianjuhl__maven__archive_file_checksum: "sha1:c8f257dce3381d9d8c420168a6df0fa25664337c"`
* if checksum validation is not required, set the value of this variable to the empty string `""`, for example: `adrianjuhl__maven__archive_file_checksum: ""`

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

To specify that become is needed:

```
- hosts: servers
  tasks:
    - name: Install maven
      include_role:
        name: adrianjuhl.maven
        apply:
          become: true
```

To install a particular version:

```
- hosts: servers
  tasks:
    - name: Install maven 3.8.7
      include_role:
        name: adrianjuhl.maven
      vars:
        adrianjuhl__maven__version: 3.8.7
```

To install a particular version (that this role does not support without addition configuration) such that the download is validated with a given checksum, in addition to setting its alternatives priority and state:

```
- hosts: servers
  tasks:
    - name: Install maven 3.2.1
      include_role:
        name: adrianjuhl.maven
      vars:
        adrianjuhl__maven__version: 3.2.1
        adrianjuhl__maven__archive_file_checksum: "sha1:40e1bf0775fd3ebcac1dbeb61153b871b86b894f"
        adrianjuhl__maven__alternatives_priority: 100
        adrianjuhl__maven__alternatives_state: auto
```

## License

MIT

## Author Information

[Adrian Juhl](http://github.com/adrianjuhl)
