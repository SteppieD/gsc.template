# Implementation Guide: GSC + Claude Code Integration

This guide walks you through the actual implementation process with real examples and decision points.

---

## Part 1: Pre-Implementation Review

### Is This Right For You?

This integration makes sense if you:
- ✓ Have Google Search Console access to your site(s)
- ✓ Use Claude Code or Claude Desktop regularly
- ✓ Want to analyze GSC data without manual exports
- ✓ Want natural language queries about your SEO performance
- ✓ Have administrative access to Google Cloud Console

### What You'll Gain

After implementation:
- Direct querying of GSC data from Claude
- Natural language SEO analysis ("What are my top keywords?")
- Quick insights without manual dashboard navigation
- Ability to combine GSC data with other analyses
- Replicable setup for multiple sites/teams

### Time Investment

- **Initial Setup:** 30-45 minutes
- **Testing:** 10 minutes
- **Future Replications:** 5-10 minutes (with SOP)

---

## Part 2: Before You Start - Requirements Checklist

### Access Requirements
- [ ] Admin access to Google Cloud Console
- [ ] Owner or Full access to GSC property (or ability to request it)
- [ ] Claude Desktop installed OR Claude Code CLI configured

### Technical Requirements
- [ ] Python 3.8+ installed (`python3 --version`)
- [ ] Git installed (`git --version`)
- [ ] Ability to run bash scripts (macOS/Linux) or PowerShell (Windows)
- [ ] ~200MB disk space for dependencies

### Information You'll Need
- [ ] Your GSC property URL (https://example.com)
- [ ] Google Cloud project name (or willing to create one)
- [ ] Secure location for credentials (~/.gsc-credentials/)

---

## Part 3: Implementation Steps

### Step 1: Prepare Your Environment (5 minutes)

**What to do:**
1. Create a working directory for this project:
```bash
mkdir ~/gsc-claude-integration
cd ~/gsc-claude-integration
```

2. Copy all files from this repository:
```bash
# Copy the SOP, scripts, and templates
cp GSC_CLAUDE_SOP.md .
cp setup_gsc_claude.sh .
cp test_gsc_connection.py .
cp requirements.txt .
# ... etc
```

3. Review the SOP:
```bash
less GSC_CLAUDE_SOP.md
```

**Why:** Sets up organized structure and ensures you understand the process.

---

### Step 2: Google Cloud Setup (10 minutes)

**What to do:**

1. **Visit Google Cloud Console**
   - Go to: https://console.cloud.google.com
   - Sign in with your Google account (use the same account that manages your GSC property)

2. **Create a Project**
   - Click project selector at the top
   - Click "New Project"
   - Name: `claude-gsc-{your-site-name}` (e.g., `claude-gsc-example-com`)
   - Click "Create"
   - Wait for creation to complete (might take 1-2 minutes)

3. **Enable Search Console API**
   - Search bar at top: type "Search Console API"
   - Click the result
   - Click "Enable"
   - Wait for it to enable

**Expected outcome:** You should see "API Enabled" status.

---

### Step 3: Create Service Account (10 minutes)

**What to do:**

1. **Navigate to Credentials**
   - Left sidebar → APIs & Services → Credentials
   - Click "Create Credentials" → "Service Account"

2. **Fill Service Account Form**
   - Service account name: `claude-gsc-sa`
   - Description: "Claude Code integration for Search Console"
   - Click "Create and Continue"

3. **Grant Permissions**
   - Click "Continue" (skip the optional permissions step for now)
   - Click "Done"

4. **Generate JSON Key**
   - Click on the service account you just created
   - Tab: "Keys"
   - "Add Key" → "Create new key"
   - Select "JSON"
   - Click "Create"

5. **Save the Key Securely**
   - File will download automatically
   - Move it to secure location:
   ```bash
   mkdir -p ~/.gsc-credentials
   mv ~/Downloads/[service-account-key].json ~/.gsc-credentials/service-account-key.json
   chmod 600 ~/.gsc-credentials/service-account-key.json
   ```

6. **Copy the Service Account Email**
   - Open the downloaded JSON file
   - Find `"client_email": "xxx@xxx.iam.gserviceaccount.com"`
   - Copy this email (you'll need it next)

**Expected outcome:** You have a JSON key file at `~/.gsc-credentials/service-account-key.json`

---

### Step 4: Add Service Account to GSC (5 minutes)

**What to do:**

1. **Go to Google Search Console**
   - https://search.google.com/search-console/

2. **Select Your Property**
   - Click on the property you want to integrate (or add new one if needed)

3. **Open Settings**
   - Left sidebar → Settings

4. **Add User**
   - Tab: "Users and Permissions"
   - Click "Add User"
   - Paste the service account email from Step 3
   - Permission level: Select "Owner" (most permissive)
   - Click "Add"

5. **Verify Addition**
   - You should see the email listed under "Users and Permissions"
   - Status: May take 5-10 minutes to fully activate

**Expected outcome:** Service account email appears in GSC Users list

---

### Step 5: Test Connection (10 minutes)

**What to do:**

1. **Run the Test Script**
```bash
python3 test_gsc_connection.py --key-path ~/.gsc-credentials/service-account-key.json
```

2. **Review Output**
   - Look for ✓ checkmarks (successful tests)
   - Look for errors (resolve before proceeding)
   - Script will show accessible properties

3. **Fix If Needed**
   - If authentication fails:
     - Verify credentials file path
     - Check service account email in GSC
     - Wait 5-10 minutes for permissions to propagate
     - Try again

**Expected outcome:** Script completes with "ALL TESTS PASSED ✓"

---

### Step 6: Configure Claude (10 minutes)

**Choose your approach:**

#### Option A: Use Automated Setup (Recommended)
```bash
chmod +x setup_gsc_claude.sh
./setup_gsc_claude.sh
```

The script will:
- Create Python virtual environment
- Install dependencies
- Test connection
- Generate Claude config snippet
- Save to `~/.gsc-credentials/claude-config-snippet.json`

#### Option B: Manual Configuration

1. **Clone MCP Server Repository**
```bash
git clone https://github.com/AminForou/mcp-gsc.git
cd mcp-gsc
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. **Find Claude Config Location**
   - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Linux:** `~/.config/claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

3. **Edit the Config File**

If the file doesn't exist, create it with:
```json
{
  "mcpServers": {}
}
```

Add this MCP server configuration (adjust paths):
```json
{
  "mcpServers": {
    "gsc": {
      "command": "/usr/local/bin/python3",
      "args": ["/path/to/mcp-gsc/gsc_server.py"],
      "env": {
        "GSC_CREDENTIALS_PATH": "/Users/yourname/.gsc-credentials/service-account-key.json"
      }
    }
  }
}
```

**Important:** Use absolute paths (starting with `/`), not relative paths.

---

### Step 7: Test in Claude (5 minutes)

**What to do:**

1. **Restart Claude**
   - Quit Claude completely (not just close window)
   - Reopen Claude Desktop or restart Claude Code

2. **Wait for Server to Initialize**
   - Wait 10-15 seconds for MCP server to start

3. **Try a Test Query**
   - In Claude, ask: "Can you access my Google Search Console data?"
   - Or: "What are my top search queries this week?"

4. **Check Results**
   - Claude should respond with data from GSC
   - If error: Check Claude logs (Help → Show Logs)

**Expected outcome:** Claude returns GSC data without errors

---

## Part 4: Validation & Sign-Off

### Final Validation Checklist

- [ ] Test script shows "ALL TESTS PASSED ✓"
- [ ] Claude config file updated with correct paths
- [ ] Claude/Claude Code restarted
- [ ] Sample query returns GSC data
- [ ] No errors in Claude logs
- [ ] Credentials file securely stored and readable

### Success Criteria

You've successfully implemented the integration when:
1. ✓ Authentication test passes
2. ✓ Claude shows MCP server as available
3. ✓ Natural language queries return GSC data
4. ✓ No error messages in logs

---

## Part 5: Next Steps

### Immediate (Today)
- [ ] Document your setup in PROJECT_TEMPLATE.md
- [ ] Test 3-5 different query types
- [ ] Verify data accuracy against GSC dashboard

### This Week
- [ ] Share setup with team members
- [ ] Create team-specific queries/analyses
- [ ] Set up automation (if needed)

### Ongoing
- [ ] Rotate credentials every 90 days
- [ ] Review access logs monthly
- [ ] Document insights/queries for future use

---

## Part 6: Troubleshooting During Implementation

### Common Issues & Fixes

**Issue: "Python 3 not found"**
```bash
# Install Python 3
# macOS: brew install python3
# Ubuntu/Debian: sudo apt-get install python3 python3-pip
# Windows: Download from python.org

# Verify installation
python3 --version
```

**Issue: "JSON key file not found"**
```bash
# Check file location
ls -la ~/.gsc-credentials/

# If empty, download new key from Google Cloud Console
# Then move it to correct location
```

**Issue: "Authentication failed" error**
1. Verify service account email in GSC Settings
2. Check that JSON key file is correct
3. Wait 5-10 minutes for permissions to propagate
4. Try test script again

**Issue: "MCP Server not showing in Claude"**
1. Check Claude config file is valid JSON (use jsonlint.com)
2. Verify paths are absolute (start with `/`)
3. Restart Claude completely
4. Check Claude logs for Python errors

**Issue: "Permission denied" when reading credentials**
```bash
# Fix file permissions
chmod 600 ~/.gsc-credentials/service-account-key.json

# Verify
ls -la ~/.gsc-credentials/service-account-key.json
# Should show: -rw------- (600)
```

---

## Part 7: Documentation for Your Project

Once implementation is complete, save this information:

**In PROJECT_TEMPLATE.md:**
- [ ] Google Cloud Project ID
- [ ] Service Account Email
- [ ] GSC Property URL
- [ ] Date of setup
- [ ] Key rotation schedule
- [ ] Team members with access

**Secure Backup:**
- [ ] Save credentials backup in secure location
- [ ] Document backup location
- [ ] Note secondary credentials holder

---

## Part 8: Team Rollout

### For Each Additional User/Project:

1. Refer them to the SOP (GSC_CLAUDE_SOP.md)
2. Have them follow this Implementation Guide
3. Each user gets:
   - Own service account OR
   - Shared service account with documented access
   - Own credentials file
   - Own PROJECT_TEMPLATE.md for tracking

### For Multiple Projects:

1. Create separate service accounts per project (recommended)
2. Use this pattern: `~/.gsc-credentials/[project-name]-key.json`
3. Configure separate MCP servers in Claude if needed

---

## Congratulations!

You've successfully integrated Google Search Console with Claude Code. You now have:
- ✓ Natural language access to your SEO data
- ✓ Ability to share this setup with your team
- ✓ Replicable process for new projects
- ✓ Secure credential management
- ✓ Comprehensive documentation

**Next:** Start exploring what Claude can do with your GSC data!

---

## Support Resources

- Full SOP: `GSC_CLAUDE_SOP.md`
- Quick Reference: `QUICK_REFERENCE.md`
- Test Script: `test_gsc_connection.py`
- Google API Docs: https://developers.google.com/webmaster-tools

---

**Document Version:** 1.0.0
**Last Updated:** December 2025
