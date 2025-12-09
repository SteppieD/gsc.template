# Google Search Console + Claude Code Integration SOP

## Overview
This Standard Operating Procedure (SOP) enables seamless integration between Google Search Console (GSC) and Claude Code via the Model Context Protocol (MCP). This allows you to query and analyze your SEO data using natural language through Claude.

---

## Phase 1: Google Cloud Setup

### Step 1.1 - Create Google Cloud Project
1. Visit [Google Cloud Console](https://console.cloud.google.com)
2. Click the project dropdown at the top
3. Click "New Project"
4. Enter project name: `claude-gsc-{your-site-name}`
5. Click "Create" and wait for project to initialize

### Step 1.2 - Enable Search Console API
1. In Google Cloud Console, click the search bar at the top
2. Search for "Search Console API"
3. Click on the result
4. Click "Enable" button
5. Wait for API to enable (takes ~30 seconds)

---

## Phase 2: Service Account Setup

### Step 2.1 - Create Service Account
1. In Google Cloud Console, go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "Service Account"
3. Fill in service account name: `claude-gsc-sa`
4. Click "Create and Continue"
5. Skip optional steps, click "Done"

### Step 2.2 - Generate JSON Key
1. Click on the service account you just created
2. Go to the "Keys" tab
3. Click "Add Key" → "Create New Key"
4. Select "JSON" format
5. Click "Create"
6. **Important:** Save this JSON file in a secure location (you'll need it later)
   - Suggested path: `~/.gsc-credentials/service-account-key.json`
   - Never commit this file to version control

---

## Phase 3: Google Search Console Setup

### Step 3.1 - Add Service Account to GSC Property
1. Go to [Google Search Console](https://search.google.com/search-console/)
2. Select your property (or add one if needed)
3. Go to "Settings" → "Users and Permissions"
4. Click "Add User"
5. Paste the service account email (found in the JSON key file: `client_email`)
6. Set permission level: **Owner** or **Full**
7. Click "Add"

---

## Phase 4: Claude Code Integration

### Step 4.1 - Install MCP Server
Choose one of the following implementations (recommended: `mcp-gsc`):

#### Option A: Using mcp-gsc (Recommended)
```bash
# Clone the repository
git clone https://github.com/AminForou/mcp-gsc.git
cd mcp-gsc

# Create Python virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

#### Option B: Using ahonn/mcp-server-gsc
```bash
git clone https://github.com/ahonn/mcp-server-gsc.git
cd mcp-server-gsc
npm install
```

### Step 4.2 - Configure Claude Code

#### For Claude Desktop:
1. Find your Claude Desktop config file:
   - **Mac:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

2. Add MCP server configuration (adjust paths to your setup):
```json
{
  "mcpServers": {
    "gsc": {
      "command": "/path/to/.venv/bin/python",
      "args": ["/path/to/gsc_server.py"],
      "env": {
        "GSC_CREDENTIALS_PATH": "/path/to/service-account-key.json"
      }
    }
  }
}
```

#### For Claude Code (CLI):
```bash
claude mcp add-json "gsc-server" \
  --command "python" \
  --args "/path/to/gsc_server.py" \
  --env "GSC_CREDENTIALS_PATH=/path/to/service-account-key.json"
```

### Step 4.3 - Restart Claude
- **Claude Desktop:** Quit and reopen the application
- **Claude Code:** Restart the session or reload the MCP server

---

## Phase 5: Test Connection

### Step 5.1 - Verify MCP Server Connection
1. Open Claude Code or Claude Desktop
2. Try one of these test queries:
   - "What are my top performing keywords this week?"
   - "Show me search analytics for my site"
   - "List all indexed pages in my GSC property"

### Step 5.2 - Check Logs
If connection fails, check logs:
- **Claude Desktop:** Help → Show Logs
- **Claude Code:** Check terminal output for MCP errors

---

## Phase 6: Usage Examples

### Query Top Keywords
```
Show me the top 10 search queries for my site in the last 30 days
```

### Analyze Performance Trends
```
Compare my CTR and impressions between this month and last month
```

### Check Indexing Status
```
What's the current indexing status for my site?
```

### Generate Insights
```
What are my top performing pages and what keywords drive traffic to them?
```

---

## Troubleshooting

### Issue: "Authentication Failed"
- Verify service account JSON file path is correct
- Confirm service account email is added to GSC property with Owner/Full permissions
- Check that Search Console API is enabled in Google Cloud

### Issue: "MCP Server Not Showing"
- Verify config file syntax (valid JSON)
- Check that paths are absolute, not relative
- Restart Claude Desktop/Code after config changes
- Check logs for Python errors

### Issue: "Permission Denied"
- Confirm service account has Owner or Full access in GSC
- Wait 5-10 minutes for permissions to propagate
- Re-verify service account email is correct in GSC settings

---

## Security Best Practices

1. **Never commit** `service-account-key.json` to version control
2. **Store securely** in `~/.gsc-credentials/` with restricted permissions (`chmod 600`)
3. **Rotate keys** regularly (every 90 days recommended)
4. **Use separate** service accounts for different projects/environments
5. **Audit access** periodically in Google Cloud Console under "Audit Logs"

---

## Replication Checklist

Use this checklist when setting up GSC + Claude in a new project:

- [ ] Google Cloud project created
- [ ] Search Console API enabled
- [ ] Service account created
- [ ] JSON key downloaded and secured
- [ ] Service account added to GSC property
- [ ] MCP server cloned/installed
- [ ] Claude config file updated with correct paths
- [ ] Claude Desktop/Code restarted
- [ ] Test query executed successfully
- [ ] Credentials backed up securely

---

## Advanced Configuration

### Multiple Properties/Accounts
To manage multiple GSC properties:

1. Create separate service accounts (one per property preferred)
2. Add each to respective GSC properties
3. Create separate MCP server instances or use environment-based switching

### Rate Limiting
GSC API has quotas:
- 25,000 queries per day (user)
- 100 queries per 100 seconds

Plan your automation accordingly.

---

## Support & Resources

- [Google Search Console API Docs](https://developers.google.com/webmaster-tools)
- [MCP-GSC Repository](https://github.com/AminForou/mcp-gsc)
- [Google Cloud Service Accounts](https://cloud.google.com/iam/docs/service-accounts)
- [Claude Code Documentation](https://claude.com/docs)
