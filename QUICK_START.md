# ⚡ Quick Start - Deployment Setup

আপনার Office Management System automated deployment setup করতে এই commands গুলো step-by-step follow করুন।

---

## 📋 Step 1: Local Git Setup

PowerShell এ (Windows):

```powershell
# Project directory তে যান
cd c:\xampp\htdocs\my.speednetkhulna.comjs

# Git initialize করুন
git init

# Files add করুন
git add .

# First commit
git commit -m "Initial commit: Office Management System"
```

---

## 📋 Step 2: GitHub Repository

### ক) GitHub.com এ যান এবং:

1. উপরে ডান দিকে **+** icon → **New repository**
2. Repository name: `office-management-system`
3. Private/Public select করুন
4. **Create repository** বাটনে ক্লিক

### খ) Local code push করুন:

```powershell
# আপনার GitHub username দিয়ে replace করুন
git remote add origin https://github.com/YOUR_USERNAME/office-management-system.git
git branch -M main
git push -u origin main
```

---

## 📋 Step 3: Server SSH Setup

Server এ SSH login করুন এবং run করুন:

```bash
# SSH key তৈরি করুন
ssh-keygen -t rsa -b 4096 -C "github-actions"
# সব প্রশ্নে Enter চাপুন (no passphrase)

# Public key authorize করুন
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Private key copy করুন (GitHub Secrets এ লাগবে)
cat ~/.ssh/id_rsa
# এই পুরো output copy করে save করে রাখুন
```

---

## 📋 Step 4: Server Software

```bash
# Git install (যদি না থাকে)
sudo yum install git -y
# অথবা Ubuntu/Debian এ
sudo apt-get install git -y

# PM2 install
npm install -g pm2

# Application directory
mkdir -p ~/office_app
cd ~/office_app

# Repository clone করুন (YOUR_USERNAME replace করুন)
git clone https://github.com/YOUR_USERNAME/office-management-system.git .

# Server dependencies
cd ~/office_app/server
npm install --production
```

---

## 📋 Step 5: Environment Setup

```bash
# .env file তৈরি করুন
cd ~/office_app/server
nano .env
```

নিচের content paste করুন এবং আপনার values দিয়ে replace করুন:

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_db_username
DB_PASSWORD=your_db_password
DB_NAME=your_database_name
PORT=5000
NODE_ENV=production
JWT_SECRET=your_random_secret_key_minimum_32_characters
SESSION_SECRET=your_another_random_secret_minimum_32_chars
FRONTEND_URL=https://yourdomain.com
```

Save: `Ctrl+X` → `Y` → `Enter`

---

## 📋 Step 6: Start Application

```bash
cd ~/office_app/server

# PM2 দিয়ে start করুন
pm2 start index.js --name office-app

# Save configuration
pm2 save

# Auto-start on server reboot
pm2 startup
# এটা একটা command show করবে, সেটা copy করে run করুন
```

---

## 📋 Step 7: Get Server Path

```bash
# Current directory path
pwd
```

Example output: `/home/username/office_app` - এটা copy করুন

---

## 📋 Step 8: GitHub Secrets

### GitHub Repository → Settings → Secrets and variables → Actions

"New repository secret" ক্লিক করে এই সব secrets যোগ করুন:

| Name | Value | Where to Find |
|------|-------|---------------|
| `SSH_PRIVATE_KEY` | `-----BEGIN RSA PRIVATE KEY-----...` | Step 3 এর `cat ~/.ssh/id_rsa` output |
| `SSH_HOST` | `premium79.web-hosting.com` | আপনার server hostname |
| `SSH_USERNAME` | `your_username` | cPanel username |
| `SSH_PORT` | `22` | SSH port (usually 22) |
| `SERVER_PATH` | `/home/username/office_app` | Step 7 এর output |
| `DB_HOST` | `localhost` | .env file থেকে same |
| `DB_USER` | `your_db_user` | .env file থেকে same |
| `DB_PASSWORD` | `your_db_password` | .env file থেকে same |
| `DB_NAME` | `office_db` | .env file থেকে same |
| `JWT_SECRET` | `your_jwt_secret` | .env file থেকে same |
| `SESSION_SECRET` | `your_session_secret` | .env file থেকে same |
| `FRONTEND_URL` | `https://yourdomain.com` | .env file থেকে same |

---

## 📋 Step 9: Test Deployment

Local machine এ:

```powershell
# একটা ছোট change করুন
echo "# Office Management System" > README.md

# Commit এবং push করুন
git add .
git commit -m "Test: First deployment"
git push origin main
```

---

## 📋 Step 10: Monitor Deployment

1. GitHub → Repository → **Actions** tab
2. Latest workflow run ক্লিক করুন
3. Logs দেখুন
4. Green checkmark = Success ✅

---

## ✅ Verification

Browser এ check করুন:

```
https://yourdomain.com
https://yourdomain.com/api/health
```

---

## 🎯 Daily Usage

এখন থেকে শুধু:

```powershell
# Code change করুন
# তারপর:

git add .
git commit -m "Your commit message"
git push origin main

# Automatically deploy হবে! 🚀
```

---

## ❌ যদি সমস্যা হয়

### Deployment failed?

1. GitHub Actions logs দেখুন
2. Server এ check করুন: `pm2 logs office-app`
3. [DEPLOYMENT.md](./DEPLOYMENT.md) পড়ুন Troubleshooting section

### Need to rollback?

```bash
# Server এ
cd ~/office_app
git reset --hard HEAD~1
pm2 restart office-app
```

---

## 📞 Need Help?

বিস্তারিত documentation: [DEPLOYMENT.md](./DEPLOYMENT.md)

---

**Setup সম্পন্ন হলে এই file delete করতে পারেন বা reference এর জন্য রাখতে পারেন।**

**Happy Deploying! 🚀**
