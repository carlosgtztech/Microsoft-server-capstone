# Active Directory & Security Testing Career Experience Capstone

![License](https://img.shields.io/badge/License-MIT-green)

## Table of Contents
1. [Project Overview](#project-overview)  
2. [Key Technologies Used](#key-technologies-used)  
3. [Network Architecture](#network-architecture)  
4. [Active Directory Infrastructure](#active-directory-infrastructure)  
   - [Domain Setup](#domain-setup)  
   - [Organizational Unit Creation](#organizational-unit-creation)  
   - [User Management with PowerShell](#user-management-with-powershell)  
   - [PowerShell Reporting Script](#powershell-reporting-script)  
5. [Group Policy Implementation](#group-policy-implementation)  
   - [Security Baseline GPO](#security-baseline-gpo)  
   - [Department-Specific GPOs](#department-specific-gpos)  
   - [Policy Validation](#policy-validation)  
6. [File Server and Permissions](#file-server-and-permissions)  
   - [Share Creation](#share-creation)  
   - [NTFS Permission Configuration](#ntfs-permission-configuration)  
7. [IIS Website and SSL Configuration](#iis-website-and-ssl-configuration)  
   - [IIS Installation](#iis-installation)  
   - [Website Creation](#website-creation)  
   - [SSL Certificate Setup](#ssl-certificate-setup)  
8. [Security Testing and Validation](#security-testing-and-validation)  
   - [Reconnaissance with Nmap](#reconnaissance-with-nmap)  
   - [Password Spraying with Hydra](#password-spraying-with-hydra)  
   - [Account Lockout Validation](#account-lockout-validation)  
9. [Conclusion](#conclusion)  
10. [Author](#author)  
11. [Disclaimer](#disclaimer)  

---

# Project Overview

This capstone project simulates a realistic enterprise IT infrastructure using virtualization technologies and Windows Server environments. The lab was designed to demonstrate the deployment, administration, automation, and security validation of a corporate network environment.

The infrastructure includes:

- Multiple Windows Servers
- Active Directory Domain Services (AD DS)
- Group Policy Objects (GPOs)
- PowerShell automation
- File server management
- IIS web services with SSL/TLS
- Security testing using Kali Linux

The primary objective of this project was to implement enterprise cybersecurity best practices including:

- Centralized authentication
- Least privilege access control
- Secure configuration management
- Network segmentation
- Redundancy and resiliency
- Security policy enforcement
- Vulnerability testing and validation

This environment replicates the responsibilities of a system administrator and cybersecurity analyst in a real-world enterprise network.

---

# Key Technologies Used

| Technology | Purpose |
|---|---|
| Active Directory Domain Services (AD DS) | Centralized authentication and domain management |
| Group Policy Objects (GPOs) | Security baseline enforcement and workstation management |
| PowerShell | Automation of administrative tasks and reporting |
| NTFS & Share Permissions | Role-based access control (RBAC) |
| IIS Web Server | Internal web hosting |
| SSL/TLS Certificates | Encrypted internal web traffic |
| Kali Linux | Penetration testing and security validation |
| Nmap | Network reconnaissance and service enumeration |
| Hydra | Password spraying and credential testing |
| vSphere | Virtualized lab environment |

---

# Network Architecture

## Virtual Environment Layout

| Hostname | IP Address | Role |
|---|---|---|
| CA-DC1 | 10.240.92.221 | Primary Domain Controller / DNS |
| CA-DC2 | 10.240.92.224 | Secondary Domain Controller |
| CA-FS1 | 10.240.92.223 | File Server |
| CA-APP1 | 10.240.92.222 | IIS Application Server |
| CA-Client1 | 10.240.92.118 | Windows 11 Client |
| KALI | 10.240.92.28 | Security Testing Machine |

## Architecture Summary

The environment was built using a multi-server architecture to simulate a medium-sized enterprise network.

### Infrastructure Components
- Two domain controllers for redundancy and fault tolerance
- Dedicated file server for departmental storage
- Application server hosting IIS web services
- Windows 11 client workstation for GPO testing
- Kali Linux machine for penetration testing and security validation

### Network Design Goals
- Centralized identity management
- High availability through redundant domain controllers
- Segregated services
- Security policy enforcement
- Controlled access to shared resources

---

# Active Directory Infrastructure

## Domain Setup

### Domain Information
- **Domain Name:** `calmendares.local`

## Domain Controller Configuration

### CA-DC1 (Primary Domain Controller)
1. Installed Windows Server
2. Configured static IP address
3. Installed Active Directory Domain Services role
4. Promoted server to Domain Controller
5. Created new forest: `calmendares.local`
6. Configured DNS services
7. Configured DSRM password

### CA-DC2 (Secondary Domain Controller)
1. Installed Windows Server
2. Joined existing domain
3. Installed AD DS role
4. Promoted to additional domain controller
5. Enabled replication and redundancy

### Replication Validation
```powershell
repadmin /replsum
```

Successful replication confirmed redundancy and synchronization between domain controllers.

---

## Organizational Unit Creation

Organizational Units (OUs) were created to logically separate departments and simplify policy administration.

## OU Structure
```text
calmendares.local
│
├── Accounting_OU
├── Developers_OU
├── Executive_OU
├── HR_OU
├── InfoTech_OU
├── Manufacturing_OU
├── Marketing_OU
├── Networking_OU
├── Sales_OU
└── SysAdmin_OU
```

## OU Creation Using PowerShell

```powershell
New-ADOrganizationalUnit -Name "Accounting" -Path "DC=calmendares,DC=local"

New-ADOrganizationalUnit -Name "HR" -Path "DC=calmendares,DC=local"

New-ADOrganizationalUnit -Name "Developers" -Path "DC=calmendares,DC=local"

New-ADOrganizationalUnit -Name "SysAdmin" -Path "DC=calmendares,DC=local"
```

## Verify OU Creation

```powershell
Get-ADOrganizationalUnit -Filter * |
Select-Object Name, DistinguishedName
```

---

## User Management with PowerShell

To simulate enterprise onboarding procedures, user accounts were bulk-created using PowerShell and CSV imports.

## CSV User Import Process

### Steps
1. Create or download  [`users.csv`](users.csv)
2. Store the file in a local directory
3. Execute PowerShell provisioning script
4. Automatically create users in designated OUs

## Example PowerShell User Creation Script

   ![image alt](https://github.com/carlosgtztech/Microsoft-server-capstone/blob/main/images/Screenshot-7.png?raw=true)

### Installation
1. **Download the script** – Save [`addusers.ps1`](addusers.ps1) to your computer.
2. **(Optional) Review the script** – Open it in a text editor to understand what it does.
3. **Place it in a convenient folder** – e.g., `C:\Scripts` or your Desktop.

```

This process automated user onboarding and significantly reduced manual administrative effort.

---

## PowerShell Reporting Script

PowerShell scripts were also used to generate reports for auditing and administrative review.

## Example AD Reporting Script
```

### Installation
1. **Download the script** – Save [`Report.ps1`](Report.ps1) to your computer.
2. **(Optional) Review the script** – Open it in a text editor to understand what it does.
3. **Place it in a convenient folder** – e.g., `C:\Scripts` or your Desktop.


### Reporting Benefits
- Automated auditing
- Administrative visibility
- User inventory management
- Compliance reporting

---

# Group Policy Implementation

Group Policy Objects (GPOs) were deployed to enforce organizational security standards and workstation restrictions.

---

## Security Baseline GPO

### Password Policy

| Setting | Value |
|---|---|
| Minimum Password Length | 12 Characters |
| Password Complexity | Enabled |
| Maximum Password Age | 90 Days |
| Minimum Password Age | 30 Days |
| Password History | 5 Passwords |

---

## Account Lockout Policy

| Setting | Value |
|---|---|
| Lockout Threshold | 5 Attempts |
| Lockout Duration | 15 Minutes |
| Reset Counter After | 15 Minutes |

These policies help defend against brute-force and password spraying attacks.

---

## Department-Specific GPOs

| Department | Policy Applied |
|---|---|
| Accounting | Disabled Command Prompt |
| HR | Restricted Defender Settings |
| Developers | PowerShell Access Enabled |
| SysAdmin | Administrative Tools Access |
| Marketing | Desktop Restrictions |
| Sales | USB Restrictions |

Department-based GPOs allowed customized security controls based on business function.

---

## Policy Validation

Policies were validated using the following commands:

```powershell
gpupdate /force
```

```powershell
gpresult /r
```

Validation confirmed that policies successfully applied to target users and systems.

---

# File Server and Permissions

## Share Creation

Departmental file shares were created on `CA-FS1`.

### Example Shares
- Accounting Share
- HR Share
- Developers Share
- Marketing Share

Shared folders allowed centralized storage and controlled collaboration.

---

## NTFS Permission Configuration

NTFS permissions were configured using the principle of least privilege.

### Permission Strategy
- Department users only access their assigned folders
- Administrative groups maintain full control
- Unauthorized access restricted

### Security Benefits
- Role-Based Access Control (RBAC)
- Reduced risk of unauthorized access
- Improved data confidentiality

---

# IIS Website and SSL Configuration

## IIS Installation

IIS was installed on `CA-APP1` using Server Manager.

### IIS Components Installed
- Web Server
- IIS Management Console
- Static Content
- Default Document
- HTTP Logging
- SSL Support

---

## Website Creation

An internal corporate website was deployed:

```text
https://marketing.calmendares.local
```

The website simulated internal enterprise applications and departmental portals.

---

## SSL Certificate Setup

A self-signed SSL certificate was generated and bound to the IIS website.

### Security Benefits
- Encrypted HTTP traffic
- Secure internal communications
- TLS implementation practice

---

# Security Testing and Validation

Security testing was conducted from the Kali Linux system to validate defensive configurations and identify vulnerabilities.

---

## Reconnaissance with Nmap

### TCP SYN Scan

```bash
nmap -sS -sV 10.240.92.0/24
```
Example below:

![image alt](https://github.com/carlosgtztech/Microsoft-server-capstone/blob/main/images/Screenshot-7.png?raw=true)

### Objectives
- Discover live hosts
- Identify open ports
- Enumerate exposed services
- Validate firewall configurations

### Results
The scan confirmed that only essential services were exposed and unnecessary ports were restricted.

---

## Password Spraying with Hydra

### Hydra SMB Attack Simulation

```bash
hydra -L users.txt -P passwords.txt smb://10.240.92.223
```

### Objectives
- Validate password policy strength
- Test account lockout enforcement
- Simulate credential attacks

### Results
The account lockout policy successfully mitigated repeated authentication attempts.

---

## Account Lockout Validation

The configured lockout thresholds successfully:
- Prevented repeated login attempts
- Mitigated password spraying attacks
- Reduced brute-force attack exposure

This validated the effectiveness of the implemented Group Policy security baseline.

---

# Conclusion

This capstone project successfully demonstrated the deployment and administration of a secure enterprise network infrastructure using modern Windows Server technologies and cybersecurity practices.

## Key Accomplishments

### Active Directory Administration
- Multi-domain controller deployment
- Centralized authentication
- Organizational Unit structure implementation

### Automation
- PowerShell-based user provisioning
- Automated reporting and auditing

### Security Enforcement
- Group Policy baseline hardening
- Password and lockout policy implementation
- Department-specific restrictions

### Access Control
- RBAC through NTFS and share permissions
- Least privilege security model

### Web Security
- IIS deployment with SSL/TLS encryption

### Security Validation
- Network reconnaissance testing
- Password spraying simulations
- Validation of defensive controls

This project strengthened practical skills in:
- Windows Server Administration
- Active Directory Management
- PowerShell Automation
- Security Hardening
- Penetration Testing
- Enterprise Infrastructure Design

---

# Author

**Carlos Almendares**  
<sub>Cybersecurity student & Tech Enthusiast</sub>

[![GitHub](https://img.shields.io/badge/GitHub-carlosgtztech-181717?style=for-the-badge&logo=github)](https://github.com/carlosgtztech)
[![Email](https://img.shields.io/badge/Email-carlosgutierrez.it@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:carlosgutierrez.it@gmail.com)

---

# Disclaimer

⚠️ **Educational Purpose Only**

This project was developed in a controlled virtual lab environment for educational and training purposes only.

The techniques, configurations, and testing procedures demonstrated in this repository should not be applied directly to production systems without:

- Proper testing
- Security review
- Organizational approval
- Compliance verification
- Risk assessment

The password spraying and network scanning demonstrations were performed only against systems owned and authorized for testing.

Always obtain explicit written permission before performing security testing against any system or network.
