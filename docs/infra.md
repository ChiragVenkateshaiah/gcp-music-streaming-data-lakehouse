# 🔐 Infrastructure, SSH Architecture & VM Migration

## 📌 Overview

This document explains the **infrastructure setup, SSH architecture, and project migration strategy** used in this repository. The goal is to reflect a **real-world, production-aligned engineering workflow**, rather than a compiler-only or notebook-only setup.

The project was initially developed in **Google Cloud Shell** and later migrated to a **dedicated Compute Engine VM** for long-term development and execution.

---

## 🖥️ Machines & Environments

| Environment                                 | Purpose                               | Characteristics                                 |
| ------------------------------------------- | ------------------------------------- | ----------------------------------------------- |
| **Cloud Shell**                             | Initial development & experimentation | Google-managed VM, ephemeral, `$HOME` persisted |
| **Compute Engine VM (`linux-workshop-vm`)** | Primary development & execution       | Full Linux VM, persistent disk                  |
| **Local Machine (VS Code)**                 | Daily access via Remote SSH           | Uses local SSH keys                             |

Each environment is treated as a **separate trust and execution domain**.

---

## 🔑 SSH Architecture (Critical Concept)

This setup intentionally separates **inbound** and **outbound** SSH flows, which mirrors how production servers are accessed and secured.

### 1️⃣ Inbound SSH (Developer → VM)

Used when logging **into** the Compute Engine VM.

* Access method: **VS Code Remote SSH**
* Authentication model:

  * **Private key** → Local machine
  * **Public key** → `/home/chira/.ssh/authorized_keys` on VM

**Purpose:** Secure, passwordless developer access

---

### 2️⃣ Outbound SSH (VM → GitHub)

Used when the VM connects **outward** to GitHub for Git operations.

* Required for: `git clone`, `git pull`, `git push`
* Authentication model:

  * **Private key** → `/home/chira/.ssh/id_ed25519` on VM
  * **Public key** → Registered in GitHub → *SSH and GPG keys*

**Purpose:** Secure Git authentication without passwords or PATs

---

## 🔄 Why VS Code SSH Worked but GitHub SSH Initially Failed

| Observation                                     | Root Cause                                        |
| ----------------------------------------------- | ------------------------------------------------- |
| VS Code could SSH into VM                       | Used **local machine’s SSH key**                  |
| GitHub returned `Permission denied (publickey)` | VM had **no outbound SSH key**                    |
| Resolution                                      | Generated VM-local SSH key and added it to GitHub |

This clarified a key distinction:

* `authorized_keys` → Who can **log into** the VM
* `id_ed25519` → How the VM **authenticates itself** to external services

---

## 📦 Project Migration Strategy

Instead of copying files between machines, the migration followed **Git-centric best practices**:

1. Push the project from Cloud Shell to GitHub
2. SSH into the Compute Engine VM via VS Code
3. Clone the repository from GitHub onto the VM
4. Create a **project-local Python virtual environment (`.venv`)**
5. Continue development exclusively on the VM

This approach ensures:

* Reproducibility
* Clean version history
* No environment coupling between machines

---

## 🧪 Python Environment Strategy

Each project maintains its own virtual environment:

```text
project-root/
├── .venv/
├── requirements.txt
├── ingestion/
├── orchestration/
```

**Why project-local `.venv`?**

* Dependency isolation
* Predictable builds
* VS Code auto-detection
* Portfolio & interview readiness

The `.venv` directory is excluded via `.gitignore`.

---

## 🧠 Key Takeaways

* SSH keys are **per user, per machine**
* Cloud Shell and Compute Engine are **not shared environments**
* Inbound SSH ≠ Outbound SSH
* GitHub should always be the **single source of truth**
* Local Linux users more closely resemble production systems than cloud-managed logins

---

## 🎯 Interview Perspective

This setup demonstrates:

* Strong Linux fundamentals
* Clear understanding of SSH security models
* Correct Git-based migration strategy
* Production-aligned cloud workflows

It intentionally avoids shortcuts (file copying, shared environments, OS-login-only access) to reflect how real engineering teams operate.
