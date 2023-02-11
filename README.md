# Ansible role: maven

Installs [maven](https://maven.apache.org).

## Requirements

* Ansible >= 2.10
* Ansible collection community.general >= 5.1.0

## Role Variables

**maven_version_major**

    adrianjuhl__maven__maven_version_major: 3

The major version of maven to install. Used to determine the URL to the maven install file on apache.org.

**maven_version**

    adrianjuhl__maven__maven_version: 3.8.7

The version of maven to install.

**maven_filename**

    adrianjuhl__maven__maven_filename: "apache-maven-{{ adrianjuhl__maven__maven_version }}-bin.tar.gz"

The name of the maven download file.

**maven_install_director**

    adrianjuhl__maven__maven_install_directory: /opt/maven

The directory to install maven into.

**maven_source_directory**

    adrianjuhl__maven__maven_source_directory: "http://archive.apache.org/dist/maven/maven-{{ adrianjuhl__maven__maven_version_major }}/{{ adrianjuhl__maven__maven_version }}/binaries"

The source location of the maven download file.

**maven_download_directory**

    adrianjuhl__maven__maven_download_directory: "{{ ansible_env.HOME + '/.ansible/tmp/downloads' }}"

The directory into which the maven download file is to be placed.

**maven_file_checksum**

    adrianjuhl__maven__maven_file_checksum: "{{ adrianjuhl__maven__maven_file_checksums[adrianjuhl__maven__maven_version] | default('sha256:9876543210') }}"

The checksum with which to check the downloaded file.

**alternatives_priority**

    adrianjuhl__maven__alternatives_priority: 50

The priority to give the installed maven version.

**alternatives_state**

    adrianjuhl__maven__alternatives_state: selected

The state that the alternative is to be set to. Options include: present, selected, auto, absent. see: https://docs.ansible.com/ansible/latest/collections/community/general/alternatives_module.html

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
