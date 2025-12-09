# Google Search Console + Claude Code Integration

A complete integration setup for connecting Google Search Console with Claude Code via the Model Context Protocol (MCP), enabling natural language queries and analysis of your SEO data.

## Overview

This project provides:
- **SOP Documentation** - Step-by-step setup guide for replication
- **Test Connection Script** - Validates your GSC authentication before Claude integration
- **Automated Setup** - Bash script to automate initial configuration
- **Project Templates** - Ready-to-use folder structures for new projects

## Quick Start (5 minutes)

### Option A: Automated Setup (Recommended)
```bash
chmod +x setup_gsc_claude.sh
./setup_gsc_claude.sh
```

### Option B: Manual Setup
Follow the detailed steps below.

---

## Complete Setup Guide (30-45 minutes)

### Step 1: Verify Prerequisites
```bash
python3 --version  # Requires Python 3.8+
git --version
```

You'll also need:
- [ ] Admin access to Google Cloud Console
- [ ] Owner/Full access to Google Search Console property
- [ ] Claude Desktop or Claude Code installed

### Step 2: Google Cloud Setup (10 minutes)

1. **Visit Google Cloud Console:** https://console.cloud.google.com
2. **Create a Project:**
   - Click project selector at top
   - Click "New Project"
   - Name: `claude-gsc-{your-site-name}` (e.g., `claude-gsc-example-com`)
   - Click "Create"
3. **Enable Search Console API:**
   - Search "Search Console API" in top search bar
   - Click the result
   - Click "Enable"

### Step 3: Create Service Account (10 minutes)

1. **Navigate to Credentials:**
   - Left sidebar → APIs & Services → Credentials
   - Click "Create Credentials" → "Service Account"
2. **Fill Service Account Form:**
   - Service account name: `claude-gsc-sa`
   - Description: "Claude Code integration for Search Console"
   - Click "Create and Continue"
3. **Grant Permissions:**
   - Click "Continue" (skip optional permissions for now)
   - Click "Done"
4. **Generate JSON Key:**
   - Click on the service account you created
   - Tab: "Keys"
   - "Add Key" → "Create new key"
   - Select "JSON"
   - Click "Create" (file will download automatically)
5. **Save the Key Securely:**
   ```bash
   mkdir -p ~/.gsc-credentials
   mv ~/Downloads/[service-account-key].json ~/.gsc-credentials/service-account-key.json
   chmod 600 ~/.gsc-credentials/service-account-key.json
   ```
6. **Copy the Service Account Email:**
   - Open the downloaded JSON file
   - Find `"client_email": "xxx@xxx.iam.gserviceaccount.com"`
   - Copy this email (you'll need it next)

### Step 4: Add Service Account to Google Search Console (5 minutes)

1. **Go to Google Search Console:** https://search.google.com/search-console/
2. **Select Your Property:**
   - Click on the property you want to integrate
3. **Open Settings:**
   - Left sidebar → Settings
4. **Add User:**
   - Tab: "Users and Permissions"
   - Click "Add User"
   - Paste the service account email from Step 3
   - Permission level: Select "Owner"
   - Click "Add"
5. **Wait 5-10 minutes** for permissions to propagate

### Step 5: Test Connection (5 minutes)

```bash
python3 test_gsc_connection.py --key-path ~/.gsc-credentials/service-account-key.json
```

You should see: **"ALL TESTS PASSED ✓"**

If it fails:
- Verify service account email is in GSC Settings
- Check credentials file path is correct
- Wait 5-10 minutes for permissions to propagate
- Try again

### Step 6: Configure Claude (10 minutes)

**Option A: Automated (Recommended)**
```bash
chmod +x setup_gsc_claude.sh
./setup_gsc_claude.sh
```

**Option B: Manual Configuration**

1. **Clone MCP Server:**
   ```bash
   git clone https://github.com/AminForou/mcp-gsc.git
   cd mcp-gsc
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Find Claude Config Location:**
   - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Linux:** `~/.config/claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

3. **Edit the Config File:**

   If file doesn't exist, create it with:
   ```json
   {
     "mcpServers": {}
   }
   ```

   Add this configuration (adjust paths):
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

   **Important:** Use absolute paths (starting with `/`)

### Step 7: Test in Claude (5 minutes)

1. **Restart Claude completely** (quit and reopen)
2. **Wait 10-15 seconds** for MCP server to initialize
3. **Try a test query:**
   ```
   "Can you access my Google Search Console data?"
   ```
   or
   ```
   "What are my top search queries this week?"
   ```
4. **Check Results:**
   - Claude should return GSC data
   - If error: Check Claude logs (Help → Show Logs)

## File Structure

```
googlesearchconsole.test/
├── README.md                    # This file
├── GSC_CLAUDE_SOP.md           # Complete setup SOP (6 phases)
├── setup_gsc_claude.sh         # Automated setup script
├── test_gsc_connection.py      # Connection validation script
├── requirements.txt            # Python dependencies
└── templates/                  # Project templates
    ├── PROJECT_TEMPLATE.md     # Template for new projects
    ├── .env.example            # Example environment variables
    └── claude_config_template.json  # Claude config template
```

## Documentation

### GSC_CLAUDE_SOP.md
Complete 6-phase setup guide covering:
1. **Google Cloud Setup** - Create project & enable API
2. **Service Account Setup** - Generate credentials
3. **GSC Configuration** - Add service account to property
4. **Claude Integration** - Install MCP server & configure
5. **Testing** - Validate connection works
6. **Advanced** - Multiple properties, rate limiting, security

### Usage Examples

Once integrated, you can query Claude with:

```
"What are my top 10 search queries this week?"
"Show me pages with the highest CTR"
"Compare my performance between months"
"Which keywords have the most impressions?"
"List all indexed pages in my property"
```

## Project Replication

### For New Projects/Instances

1. **Copy the entire project folder** to new location
2. **Run setup script:**
   ```bash
   ./setup_gsc_claude.sh
   ```
3. **Provide new Google Cloud credentials** when prompted
4. **Configure Claude** with the generated config
5. **Test connection** with sample queries

### Checklist for Replication

Use `GSC_CLAUDE_SOP.md` "Replication Checklist" to track setup:
- [ ] Google Cloud project created
- [ ] Search Console API enabled
- [ ] Service account created
- [ ] JSON key downloaded and secured
- [ ] Service account added to GSC property
- [ ] MCP server installed/configured
- [ ] Claude config updated
- [ ] Connection tested

## Architecture

```
Claude Code
    ↓
Model Context Protocol (MCP)
    ↓
GSC MCP Server (Python/Node.js)
    ↓
Google Search Console API
    ↓
Your GSC Data
```

## Supported MCP Implementations

This setup is compatible with:
- **AminForou/mcp-gsc** (Recommended - Python-based)
- **ahonn/mcp-server-gsc** (Node.js-based)
- **guchey/mcp-server-google-search-console** (Alternative)

## Security

⚠️ **Important Security Notes:**
1. Never commit `service-account-key.json` to version control
2. Store keys in `~/.gsc-credentials/` with restricted permissions (`chmod 600`)
3. Use separate service accounts for different projects
4. Rotate keys every 90 days
5. Review access permissions regularly

## Troubleshooting

### Connection Issues
- Verify credentials file path is absolute (not relative)
- Check service account email is added to GSC with Owner/Full permissions
- Confirm Search Console API is enabled in Google Cloud
- Wait 5-10 minutes for permission changes to propagate

### MCP Server Not Showing
- Check JSON syntax in Claude config file
- Restart Claude Desktop/Code after config changes
- Review logs for Python/Node.js errors

### "Permission Denied"
- Confirm service account has correct permissions in GSC
- Check that JSON key file is readable: `chmod 600 ~/.gsc-credentials/service-account-key.json`

See `GSC_CLAUDE_SOP.md` for detailed troubleshooting.

## Useful Resources

- [Google Search Console API](https://developers.google.com/webmaster-tools)
- [MCP Documentation](https://modelcontextprotocol.io)
- [Claude Code Docs](https://claude.com/docs)
- [Google Cloud Service Accounts](https://cloud.google.com/iam/docs/service-accounts)

## Support

For issues:
1. Check `GSC_CLAUDE_SOP.md` troubleshooting section
2. Run `test_gsc_connection.py` to validate credentials
3. Review Claude logs for MCP errors
4. Check Google Cloud API quotas and limits

## Version History

- **v1.0.0** - Initial release with SOP, test script, and setup automation

## License

This integration setup is provided as-is for use with Google Search Console and Claude Code.
