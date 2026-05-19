# Enterprise Network Simulation: Active Directory & Security Testing

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
9. [Conclusion & Lessons Learned](#conclusion--lessons-learned)
10. [Future Improvements](#future-improvements)
11. [Author](#author)
12. [Repository Contents](#repository-contents)
13. [Disclaimer](#disclaimer)

---

## Project Overview

This project simulates a realistic enterprise IT environment using virtualization. The infrastructure includes multiple Windows Servers, a client workstation, Active Directory Domain Services (AD DS), PowerShell automation, Group Policy enforcement, secure file sharing, and security testing with Kali Linux.

The goal was to replicate a corporate IT infrastructure while applying cybersecurity best practices: least privilege access, centralized authentication, redundancy, access control, and policy enforcement. Security testing validates the effectiveness of these controls and identifies vulnerabilities like weak passwords or misconfigured services.

---

## Key Technologies Used

- **Active Directory Domain Services (AD DS)** – Centralized authentication and management
- **Group Policy Objects (GPO)** – Security baselines, password policies, account lockout, department restrictions
- **PowerShell** – Automated user provisioning and reporting
- **NTFS & Share Permissions** – Least privilege access control
- **IIS with SSL/TLS** – Secure internal website deployment
- **Kali Linux** – Penetration testing (Nmap, Hydra) to validate security controls

---

## Network Architecture

### Virtual Environment Layout

| Hostname     | IP Address    | Function                |
|--------------|---------------|-------------------------|
| CA-DC1       | 10.240.92.221 | DNS / ADDS (Primary DC) |
| CA-DC2       | 10.240.92.224 | Redundancy (Secondary DC) |
| CA-FS1       | 10.240.92.223 | File Services           |
| CA-APP1      | 10.240.92.222 | Application Services (IIS) |
| CA-Client1   | 10.240.92.118 | Client Testing (Windows 11) |
| KALI         | 10.240.92.28  | Security Testing (Kali Linux) |

### Architecture Summary
- 2 Domain Controllers for redundancy
- 1 File Server with departmental shares
- 1 Application Server running IIS
- 1 Windows 11 Client for policy testing
- 1 Kali Linux testing machine

---

## Active Directory Infrastructure

### Domain Setup

**Domain Name:** `calmendares.local`

**Step-by-Step:**
1. Install Windows Server on CA-DC1 and CA-DC2
2. Set static IP addresses (10.240.92.221 and 10.240.92.224)
3. On CA-DC1, install AD DS role:
   - Server Manager → Add Roles and Features → Active Directory Domain Services
   - Promote server to domain controller
   - Create new forest: `calmendares.local`
   - Set Directory Services Restore Mode (DSRM) password
4. On CA-DC2, install AD DS role and join existing domain:
   - Promote to domain controller → Add domain controller to existing domain
   - Specify `calmendares.local` as parent domain
5. Configure DNS integration (automatic with AD DS promotion)
6. Verify replication between DCs using `repadmin /replsum`

---

### Organizational Unit Creation
**OU Structure**
calmendares.local/
├── Accounting
├── HR
├── Developers
└── SysAdmin

**Step-by-Step via GUI:**
1. Open Active Directory Users and Computers (ADUC)
2. Right-click domain → New → Organizational Unit
3. Name each department OU as listed above
4. Create sub-OUs for Users and Computers within each department (optional)

**Step-by-Step via PowerShell:**
1. Open Active Directory Users and Computers (ADUC)
2. Right-click domain → New → Organizational Unit
3. Name each department OU as listed above
4. Create sub-OUs for Users and Computers within each department (optional)

**Step-by-Step via PowerShell:**
```powershell
# Create OUs
New-ADOrganizationalUnit -Name "Accounting" -Path "DC=calmendares,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "DC=calmendares,DC=local"
New-ADOrganizationalUnit -Name "Developers" -Path "DC=calmendares,DC=local"
New-ADOrganizationalUnit -Name "SysAdmin" -Path "DC=calmendares,DC=local"

# Verify creation
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName

### User Automation

Users were bulk-created from a CSV file using PowerShell, simulating enterprise onboarding.

### PowerShell Reporting Script

Automated script exports AD objects (users, groups, OUs) into structured reports for auditing.

---

## Group Policy Implementation

### Security Baseline – Password Policy
| Setting           | Value        |
|-------------------|--------------|
| Minimum Length    | 12           |
| Complexity        | Enabled      |
| Maximum Age       | 90 days      |
| Minimum Age       | 30 days      |
| Password History  | 5 passwords  |

### Account Lockout Policy
| Setting             | Value        |
|---------------------|--------------|
| Lockout Threshold   | 5 attempts   |
| Lockout Duration    | 15 minutes   |
| Reset Counter       | 15 minutes   |

### Department-Specific GPOs
| Department | Policy                          |
|------------|---------------------------------|
| Accounting | Disable Command Prompt          |
| HR         | Disable Windows Defender        |
| Developers | Allow PowerShell                |
| SysAdmin   | Administrative Tools access     |

Validation: `gpupdate /force` and `gpresult /r` confirmed policy application.

---

## File Server & Permissions

Departmental shares configured with:
- **Share permissions** – broad access
- **NTFS permissions** – granular, least-privilege access

Users can only access their department’s folders, enforcing role-based access control (RBAC).

---

## IIS Website with SSL

- **Internal site:** `https://marketing.calmendares.local`
- **Platform:** IIS on Windows Server
- **Security:** Self-signed SSL/TLS certificate for encrypted internal traffic

---

## Security Testing & Validation (Kali Linux)

### Reconnaissance (Nmap)
TCP SYN scan revealed that firewall rules properly restricted inbound traffic to only essential services.

### Password Spraying Attack (Hydra)
```bash
hydra -L users.txt -P passwords.txt smb://10.240.92.223
