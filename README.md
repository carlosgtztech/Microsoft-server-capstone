# Enterprise Network Simulation: Active Directory & Security Testing

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

| Hostname     | IP Address    | Function                |
|--------------|---------------|-------------------------|
| CA-DC1       | 10.240.92.221 | DNS / ADDS              |
| CA-DC2       | 10.240.92.224 | Redundancy              |
| CA-FS1       | 10.240.92.223 | File Services           |
| CA-APP1      | 10.240.92.222 | Application Services    |
| CA-Client1   | 10.240.92.118 | Client Testing          |
| KALI         | 10.240.92.28  | Security Testing        |

- 2 Domain Controllers for redundancy
- 1 File Server with departmental shares
- 1 Application Server (IIS)
- 1 Windows 11 Client
- 1 Kali Linux attacker machine

---

## Active Directory Structure

**Domain:** `calmendares.local`

**Organizational Units (OUs):**
- Accounting
- HR
- Developers
- SysAdmin

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
