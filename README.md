# PostgreSQL Ansible Automation Project

A comprehensive Ansible project for automated PostgreSQL database installation, configuration, and management across multiple environments.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Playbooks](#playbooks)
- [Roles](#roles)
- [Inventory Management](#inventory-management)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This Ansible project provides a complete automation solution for PostgreSQL database management. It supports multiple environments (production, test) and includes roles for installation, configuration, and ongoing management of PostgreSQL clusters.

## ✨ Features

- **Multi-Environment Support**: Separate configurations for production and test environments
- **Automated PostgreSQL Installation**: Supports both Debian and RedHat-based systems
- **Configuration Management**: Automated pg_hba.conf and postgresql.conf configuration
- **Database & User Management**: Create and manage databases and users
- **Security Hardening**: Implements PostgreSQL security best practices
- **SSH Key Management**: Automated SSH key deployment and management
- **Health Checks**: Built-in PostgreSQL health and status checks
- **Idempotent Operations**: Safe to run multiple times without side effects

## 📁 Project Structure

```
pg_ansible/
├── ansible.cfg                 # Ansible configuration
├── .gitignore                 # Git ignore rules (includes SSH keys/certificates)
├── files/
│   └── abc/                   # SSH keys and certificates
│       ├── abc                # Private SSH key
│       └── abc.pub            # Public SSH key
├── inventory/
│   └── root_project/
│       ├── hosts              # Inventory file
│       ├── group_vars/        # Group variables
│       │   ├── all.yml
│       │   ├── prod.yml
│       │   └── test.yml
│       └── host_vars/         # Host-specific variables
│           └── pgabct01.yml
├── playbooks/
│   ├── install.yml            # PostgreSQL installation playbook
│   ├── pg_check.yml           # Health check playbook
│   └── ssh.yml                # SSH configuration playbook
├── roles/
│   ├── pg_install/            # PostgreSQL installation role
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── meta/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   └── pg_manage/             # PostgreSQL management role
│       ├── defaults/
│       ├── handlers/
│       ├── meta/
│       ├── tasks/
│       ├── templates/
│       └── vars/
├── create-project.sh          # Project creation script
└── reinit.sh                  # Project reinitialization script
```

## 🔧 Prerequisites

### System Requirements
- **Ansible**: Version 2.9 or higher
- **Python**: Version 3.6 or higher
- **SSH Access**: Passwordless SSH access to target hosts
- **Sudo Privileges**: Root or sudo access on target systems

### Target System Requirements
- **Operating System**: 
  - Ubuntu 18.04/20.04/22.04
  - CentOS 7/8
  - RHEL 7/8/9
  - Debian 9/10/11
- **Memory**: Minimum 2GB RAM (4GB+ recommended)
- **Storage**: Minimum 20GB available space

## 🚀 Installation

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd pg_ansible
   ```

2. **Install Ansible** (if not already installed)
   ```bash
   # On Ubuntu/Debian
   sudo apt update
   sudo apt install ansible
   
   # On CentOS/RHEL
   sudo yum install epel-release
   sudo yum install ansible
   
   # Using pip
   pip3 install ansible
   ```

3. **Verify Installation**
   ```bash
   ansible --version
   ansible-playbook --version
   ```

## ⚙️ Configuration

### 1. Inventory Setup

Edit the inventory file to match your environment:

```bash
vim inventory/root_project/hosts
```

Example configuration:
```yaml
prod:
  hosts:
    pgabcp01:
      ansible_host: 172.32.2.21
      ansible_port: 22
    pgabcp02:
      ansible_host: 172.32.2.21
      ansible_port: 23

test:
  hosts:
    pgabct01:
      ansible_host: 172.32.2.23
      ansible_port: 22
```

### 2. Group Variables

Configure environment-specific variables in `inventory/root_project/group_vars/`:

- `all.yml`: Common variables for all hosts
- `prod.yml`: Production environment variables
- `test.yml`: Test environment variables

### 3. Host Variables

Set host-specific configurations in `inventory/root_project/host_vars/`:

```yaml
# Example: pgabct01.yml
postgresql_version: "14"
postgresql_port: 5432
postgresql_listen_addresses: "*"
```

### 4. SSH Keys

Place your SSH keys in the `files/abc/` directory:
- `abc`: Private SSH key
- `abc.pub`: Public SSH key

**Note**: These files are automatically ignored by Git for security.

## 🎮 Usage

### Basic Commands

1. **Test Connectivity**
   ```bash
   ansible all -i inventory/root_project/hosts -m ping
   ```

2. **Install PostgreSQL**
   ```bash
   ansible-playbook -i inventory/root_project/hosts playbooks/install.yml
   ```

3. **Run Health Checks**
   ```bash
   ansible-playbook -i inventory/root_project/hosts playbooks/pg_check.yml
   ```

4. **Configure SSH**
   ```bash
   ansible-playbook -i inventory/root_project/hosts playbooks/ssh.yml
   ```

### Environment-Specific Deployment

1. **Production Environment**
   ```bash
   ansible-playbook -i inventory/root_project/hosts playbooks/install.yml --limit prod
   ```

2. **Test Environment**
   ```bash
   ansible-playbook -i inventory/root_project/hosts playbooks/install.yml --limit test
   ```

## 📚 Playbooks

### install.yml
- **Purpose**: Complete PostgreSQL installation and initial configuration
- **Roles**: pg_install
- **Target**: All hosts
- **Features**: 
  - OS detection and package installation
  - Service configuration and startup
  - Initial security setup

### pg_check.yml
- **Purpose**: PostgreSQL health and status verification
- **Features**:
  - Service status checks
  - Connection testing
  - Performance monitoring
  - Log analysis

### ssh.yml
- **Purpose**: SSH key deployment and configuration
- **Features**:
  - SSH key distribution
  - SSH daemon configuration
  - Security hardening

## 🎭 Roles

### pg_install Role

**Purpose**: PostgreSQL installation and basic configuration

**Tasks**:
- `main.yml`: Orchestrates the installation process
- `node.yml`: Node-specific configuration
- `initialize.yml`: Database initialization

**Templates**:
- `pg_hba.conf.j2`: Client authentication configuration

**Key Features**:
- Multi-OS support (Debian/RedHat families)
- Version-specific installation
- Security hardening
- Service management

### pg_manage Role

**Purpose**: Advanced PostgreSQL management and maintenance

**Tasks**:
- `main.yml`: Main management tasks
- `configure.yml`: Advanced configuration
- `databases.yml`: Database management
- `users.yml`: User and role management
- `install-Debian.yml`: Debian-specific installation
- `install-RedHat.yml`: RedHat-specific installation
- `initialize.yml`: Initialization tasks
- `variables.yml`: Dynamic variable setup

**Templates**:
- `pg_hba.conf.j2`: Authentication configuration template

**Key Features**:
- Database creation and management
- User and role administration
- Performance tuning
- Backup configuration
- Monitoring setup

## 📊 Inventory Management

### Host Groups

- **postgresql**: Parent group for all PostgreSQL servers
  - **prod**: Production environment hosts
  - **test**: Test environment hosts

### Variable Hierarchy

1. **Global Variables** (`group_vars/all.yml`)
2. **Environment Variables** (`group_vars/prod.yml`, `group_vars/test.yml`)
3. **Host Variables** (`host_vars/<hostname>.yml`)

### Example Variable Structure

```yaml
# group_vars/all.yml
postgresql_version: "14"
postgresql_port: 5432
postgresql_max_connections: 100

# group_vars/prod.yml
postgresql_shared_buffers: "256MB"
postgresql_max_connections: 200

# host_vars/pgabcp01.yml
postgresql_port: 5433
postgresql_listen_addresses: "10.0.1.100"
```

## 🔒 Security

### Security Features

1. **SSH Key Management**: Automated distribution and rotation
2. **PostgreSQL Security**: 
   - Strong authentication configuration
   - Network access controls
   - Role-based permissions
3. **File Protection**: Sensitive files excluded from version control
4. **Connection Security**: SSL/TLS configuration support

### Security Best Practices

1. **SSH Keys**: Use strong SSH key pairs (RSA 4096-bit or Ed25519)
2. **Passwords**: Use Ansible Vault for password storage
3. **Network**: Implement firewall rules and network segmentation
4. **Updates**: Regularly update PostgreSQL and system packages
5. **Monitoring**: Implement logging and monitoring solutions

### Protected Files

The following file types are automatically excluded from Git:
- SSH private/public keys (*.key, *.pub, id_*)
- SSL/TLS certificates (*.pem, *.crt, *.p12)
- Ansible Vault files (*.vault)
- Environment files (.env*)

## 🚀 Quick Start Guide

1. **Setup Environment**
   ```bash
   # Clone and enter project
   git clone <repo-url>
   cd pg_ansible
   
   # Configure inventory
   cp inventory/root_project/hosts.example inventory/root_project/hosts
   vim inventory/root_project/hosts
   ```

2. **Test Connection**
   ```bash
   ansible all -m ping
   ```

3. **Deploy PostgreSQL**
   ```bash
   # Test environment first
   ansible-playbook playbooks/install.yml --limit test
   
   # Then production
   ansible-playbook playbooks/install.yml --limit prod
   ```

4. **Verify Installation**
   ```bash
   ansible-playbook playbooks/pg_check.yml
   ```

## 🔧 Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   ```bash
   # Check SSH connectivity
   ssh -i files/abc/abc user@target-host
   
   # Verify SSH key permissions
   chmod 600 files/abc/abc
   chmod 644 files/abc/abc.pub
   ```

2. **Remote Temp Directory Warning**
   ```bash
   # Prepare environment (creates temp directories with correct permissions)
   ansible-playbook playbooks/prepare-env.yml
   
   # Or manually create on target hosts
   ansible all -m file -a "path=~/.ansible/tmp state=directory mode=0755"
   ```

3. **PostgreSQL Service Failed**
   ```bash
   # Check logs on target host
   sudo journalctl -u postgresql
   sudo tail -f /var/log/postgresql/postgresql-*.log
   ```

3. **Permission Denied**
   ```bash
   # Verify sudo access
   ansible all -m shell -a "sudo whoami" --ask-become-pass
   ```

### Debug Mode

Run playbooks with verbose output:
```bash
ansible-playbook playbooks/install.yml -vvv
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Ansible best practices
- Use meaningful variable names
- Add comments for complex tasks
- Test on multiple OS versions
- Update documentation for new features

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review Ansible documentation

## 🔄 Version History

- **v1.0.0**: Initial release with basic PostgreSQL installation
- **v1.1.0**: Added multi-environment support
- **v1.2.0**: Enhanced security features and SSH management

---

**Made with ❤️ for PostgreSQL automation**
