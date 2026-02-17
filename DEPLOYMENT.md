# 🚀 Automated Deployment Guide

এই ডকুমেন্টে Office Management System এর জন্য GitHub Actions দিয়ে automated deployment setup করার সম্পূর্ণ প্রক্রিয়া বর্ণনা করা হয়েছে।

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [GitHub Repository Setup](#github-repository-setup)
4. [Server Preparation](#server-preparation)
5. [GitHub Secrets Configuration](#github-secrets-configuration)
6. [First Deployment](#first-deployment)
7. [Daily Workflow](#daily-workflow)
8. [Troubleshooting](#troubleshooting)
9. [Rollback Process](#rollback-process)

---

## Prerequisites

### আপনার কাছে থাকতে হবে:

- ✅ GitHub account
- ✅ SSH access সহ hosting server (premium79.web-hosting.com)
- ✅ Node.js v20+ support server এ
- ✅ PostgreSQL database setup
- ✅ Git installed (local machine এ)

---

## Initial Setup

### ১. Git Initialize করুন (Local Machine এ)

PowerShell এ:

```powershell
# Project root directory তে যান
cd c:\xampp\htdocs\my.speednetkhulna.comjs

# Git initialize করুন
git init

# সব files add করুন
git add .

# First commit করুন
git commit -m "Initial commit: Office Management System"
```

---

## GitHub Repository Setup

### ২. GitHub এ Repository তৈরি করুন

#### ক) GitHub.com এ login করুন

#### খ) New Repository তৈরি করুন:

1. উপরের ডান কোণে **+** icon → **New repository** ক্লিক করুন
2. **Repository name**: `office-management-system` (বা আপনার পছন্দের নাম)
3. **Description**: `Office Management System - PERN Stack Application`
4. **Visibility**: Private (recommended) বা Public
5. **Initialize**: কোনো file add করবেন না (README, .gitignore ইত্যাদি)
6. **Create repository** বাটনে ক্লিক করুন

#### গ) Local code GitHub এ push করুন:

Repository তৈরির পর GitHub একটা page দেখাবে। সেখান থেকে commands copy করুন অথবা নিচের commands run করুন:

```powershell
# আপনার GitHub username এবং repository name দিয়ে replace করুন
git remote add origin https://github.com/YOUR_USERNAME/office-management-system.git

# Main branch এ rename করুন (যদি master থাকে)
git branch -M main

# Code push করুন
git push -u origin main
```

**Note**: প্রথমবার push করলে GitHub আপনার credentials চাইবে।

---

## Server Preparation

### ৩. SSH Key তৈরি করুন (Server এ)

#### ক) Server এ SSH login করুন:

```bash
ssh your_username@premium79.web-hosting.com
```

#### খ) SSH Key pair তৈরি করুন:

```bash
# SSH key generate করুন
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy"

# Enter চাপুন (default location)
# Enter চাপুন (no passphrase - important!)
# আবার Enter চাপুন (confirm no passphrase)
```

#### গ) Public key authorized_keys এ যোগ করুন:

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

#### ঘ) Private key copy করুন (এটা GitHub Secrets এ লাগবে):

```bash
cat ~/.ssh/id_rsa
```

**এই পুরো output copy করুন** (সবকিছু সহ `-----BEGIN RSA PRIVATE KEY-----` থেকে `-----END RSA PRIVATE KEY-----` পর্যন্ত)

---

### ৪. Server Software Setup

#### ক) Git install করুন (যদি না থাকে):

```bash
# CentOS/RHEL
sudo yum install git -y

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git -y
```

#### খ) PM2 install করুন:

```bash
# Global installation
npm install -g pm2

# PM2 version check করুন
pm2 --version
```

#### গ) Application directory তৈরি করুন:

```bash
# Home directory তে যান
cd ~

# Application directory তৈরি করুন
mkdir -p office_app

# Git clone করুন (আপনার repository URL দিয়ে)
cd office_app
git clone https://github.com/YOUR_USERNAME/office-management-system.git .

# Git credentials configure করুন (optional, if needed)
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

#### ঘ) Server dependencies install করুন:

```bash
cd ~/office_app/server
npm install --production
```

#### ঙ) .env file তৈরি করুন (manual):

```bash
cd ~/office_app/server
nano .env
```

নিচের content paste করুন এবং আপনার actual values দিয়ে replace করুন:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_db_username
DB_PASSWORD=your_db_password
DB_NAME=your_database_name

# Server Configuration
PORT=5000
NODE_ENV=production

# JWT & Session Secrets
JWT_SECRET=your_super_secret_jwt_key_here_make_it_long_and_random
SESSION_SECRET=your_super_secret_session_key_here_also_random

# Frontend URL
FRONTEND_URL=https://yourdomain.com
```

Save করুন: `Ctrl+X`, তারপর `Y`, তারপর `Enter`

#### চ) PM2 দিয়ে application start করুন:

```bash
cd ~/office_app/server

# Application start করুন
pm2 start index.js --name office-app

# PM2 configuration save করুন
pm2 save

# Server restart এ auto-start enable করুন
pm2 startup
# এটা একটা command output দেবে, সেটা copy করে run করুন
```

#### ছ) Server path note করুন:

```bash
# আপনার full server path জানতে
pwd
```

Example output: `/home/username/office_app` - এটা note করে রাখুন।

---

## GitHub Secrets Configuration

### ৫. GitHub Repository তে Secrets যোগ করুন

#### ক) GitHub repository তে যান

#### খ) Settings → Secrets and variables → Actions এ যান

#### গ) "New repository secret" বাটনে ক্লিক করে নিচের সব secrets যোগ করুন:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `SSH_PRIVATE_KEY` | Server এর SSH private key (step ৩ঘ থেকে) | `-----BEGIN RSA PRIVATE KEY-----...` |
| `SSH_HOST` | Server hostname বা IP | `premium79.web-hosting.com` |
| `SSH_USERNAME` | Server username (cPanel) | `your_cpanel_username` |
| `SSH_PORT` | SSH port number | `22` |
| `SERVER_PATH` | Application এর full path | `/home/username/office_app` |
| `DB_HOST` | Database host | `localhost` |
| `DB_USER` | Database username | `your_db_user` |
| `DB_PASSWORD` | Database password | `your_db_password` |
| `DB_NAME` | Database name | `office_db` |
| `JWT_SECRET` | JWT secret key (.env থেকে same) | `your_super_secret_jwt_key...` |
| `SESSION_SECRET` | Session secret (.env থেকে same) | `your_super_secret_session...` |
| `FRONTEND_URL` | Production domain URL | `https://yourdomain.com` |

**প্রতিটা secret এর জন্য:**
1. "New repository secret" ক্লিক করুন
2. Name field এ secret name লিখুন (উপরের table থেকে)
3. Secret field এ value paste করুন
4. "Add secret" বাটনে ক্লিক করুন

---

## First Deployment

### ৬. প্রথমবার Deployment Test করুন

#### ক) Local machine এ একটা ছোট পরিবর্তন করুন:

```powershell
# README.md file edit করুন বা যেকোনো ছোট change করুন
# Example:
echo "# Office Management System" > README.md
```

#### খ) Commit এবং push করুন:

```powershell
git add .
git commit -m "Test: First automated deployment"
git push origin main
```

#### গ) Deployment monitor করুন:

1. GitHub repository তে যান
2. **Actions** tab ক্লিক করুন
3. সবচেয়ে recent workflow run দেখুন
4. Live logs দেখতে workflow name এ ক্লিক করুন

**Expected Duration**: 2-5 মিনিট

#### ঘ) Deployment verify করুন:

Workflow সফল হলে:

```bash
# Browser এ check করুন
https://yourdomain.com

# API health check
https://yourdomain.com/api/health
```

---

## Daily Workflow

### ৭. এখন থেকে যেভাবে কাজ করবেন

#### Development Workflow:

```powershell
# ১. Code update করুন (যেকোনো file edit করুন)

# ২. Changes commit করুন
git add .
git commit -m "Feature: Added new dashboard widget"

# ৩. GitHub এ push করুন
git push origin main

# ৪. GitHub Actions automatically deployment শুরু করবে
# ৫. 2-5 মিনিটে production এ live হবে
```

#### Deployment Status দেখুন:

- GitHub → Repository → Actions tab
- Latest workflow run এ ক্লিক করুন
- Green checkmark = Success ✅
- Red X = Failed ❌

---

## Troubleshooting

### সমস্যা ১: SSH Connection Failed

**Error**: `Permission denied (publickey)`

**Solution**:
```bash
# Server এ SSH করুন
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

---

### সমস্যা ২: PM2 Command Not Found

**Error**: `pm2: command not found`

**Solution**:
```bash
# PM2 reinstall করুন
npm install -g pm2

# PM2 path check করুন
which pm2

# যদি এখনো না পান, manually path যোগ করুন
export PATH=$PATH:/usr/local/bin
```

---

### সমস্যা ৩: Git Pull Failed

**Error**: `error: Your local changes would be overwritten by merge`

**Solution**:
```bash
# Server এ SSH করুন
cd ~/office_app
git stash
git pull origin main
```

---

### সমস্যা ৪: Build Failed

**Error**: `npm ci` বা `npm run build` failed

**Solution**:
- GitHub Actions logs চেক করুন
- `client/package.json` dependencies verify করুন
- Local এ build test করুন: `cd client; npm run build`

---

### সমস্যা ৫: Application Not Restarting

**Error**: PM2 restart command fails

**Solution**:
```bash
# Server এ SSH করুন
pm2 delete office-app
cd ~/office_app/server
pm2 start index.js --name office-app
pm2 save
```

---

## Rollback Process

### যদি deployment এ সমস্যা হয় এবং previous version এ ফিরে যেতে চান:

#### Option 1: Manual Rollback (Server থেকে)

```bash
# Server এ SSH করুন
ssh your_username@premium79.web-hosting.com

# Application directory তে যান
cd ~/office_app

# Previous commit এ ফিরে যান
git log --oneline  # Previous commit hash দেখুন
git reset --hard COMMIT_HASH  # Replace COMMIT_HASH with actual hash

# Application restart করুন
pm2 restart office-app
```

#### Option 2: Rollback via GitHub (Recommended)

```powershell
# Local machine এ
git log --oneline  # Previous commit hash দেখুন

# Reset to previous commit
git reset --hard COMMIT_HASH

# Force push to GitHub (এটা automatically deploy হবে)
git push origin main --force
```

---

## Additional Notes

### Frontend Update Only:

যদি শুধু frontend code change করেন, deployment process same থাকবে। GitHub Actions automatically:
1. Frontend build করবে
2. Built files server এ deploy করবে

### Backend Update Only:

যদি শুধু backend code change করেন:
1. Server code update হবে
2. Dependencies install হবে
3. PM2 restart হবে

### Database Migration:

যদি database schema change করেন:
1. Migration SQL file তৈরি করুন
2. Server এ manually run করুন (automated migration setup করা যায়)

```bash
# Server এ
psql -U db_user -d db_name -f migration.sql
```

---

## Security Best Practices

### ✅ Do's:

- ✅ Strong passwords ব্যবহার করুন (database, JWT secrets)
- ✅ `.env` file কখনো Git এ commit করবেন না
- ✅ GitHub Secrets এ sensitive data রাখুন
- ✅ Regular backups নিন (database এবং uploads folder)
- ✅ HTTPS ব্যবহার করুন production এ

### ❌ Don'ts:

- ❌ SSH private key public করবেন না
- ❌ GitHub Secrets screenshot share করবেন না
- ❌ Production credentials code এ hardcode করবেন না
- ❌ Same password multiple জায়গায় ব্যবহার করবেন না

---

## Support & Contact

যদি কোনো সমস্যা হয় বা help লাগে:

1. GitHub Actions logs চেক করুন
2. Server logs চেক করুন: `pm2 logs office-app`
3. এই documentation আবার পড়ুন
4. GitHub Issues তে প্রশ্ন করুন (যদি public repo হয়)

---

## 🎉 Success!

Congratulations! আপনার automated deployment setup সম্পূর্ণ হয়েছে। এখন থেকে শুধু `git push` করলেই আপনার code automatically production এ deploy হবে।

**Happy Coding! 🚀**
