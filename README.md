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

    adrianjuhl__maven__maven_download_directory: "{{ default(ansible_env.HOME + '/.ansible/tmp/downloads') }}"

The directory into which the maven download file is to be placed.

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
