# GSC + Claude Code Integration - Quick Reference

## 30-Second Setup Summary

1. **Google Cloud:** Create project → Enable Search Console API
2. **Service Account:** Create account → Download JSON key → Add to GSC
3. **Claude:** Run setup script → Copy config → Restart Claude
4. **Test:** Run test script → Query Claude

---

## Command Cheat Sheet

### Initial Setup
```bash
# Run automated setup
chmod +x setup_gsc_claude.sh
./setup_gsc_claude.sh

# Or manual Python environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Testing
```bash
# Test connection before Claude integration
python3 test_gsc_connection.py --key-path ~/.gsc-credentials/service-account-key.json

# Verify credentials file is secure
ls -la ~/.gsc-credentials/service-account-key.json
# Should show: -rw------- (600)
```

### Configuration
```bash
# Find Claude config file
# macOS:
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Linux:
cat ~/.config/claude/claude_desktop_config.json

# Windows:
type %APPDATA%\Claude\claude_desktop_config.json
```

### Troubleshooting
```bash
# Check if Python dependencies are installed
python3 -c "import google.oauth2; print('✓ Google Auth OK')"

# Check file permissions
ls -l ~/.gsc-credentials/

# View Claude logs
# macOS: Help → Show Logs → Look for MCP errors
# Linux: Check ~/.local/share/claude/
```

---

## Key File Locations

| Component | Location | Purpose |
|-----------|----------|---------|
| Service Account Key | `~/.gsc-credentials/service-account-key.json` | API authentication |
| Claude Config (macOS) | `~/Library/Application Support/Claude/claude_desktop_config.json` | MCP server config |
| Claude Config (Linux) | `~/.config/claude/claude_desktop_config.json` | MCP server config |
| Claude Config (Windows) | `%APPDATA%\Claude\claude_desktop_config.json` | MCP server config |
| Virtual Env | `.venv/` | Python dependencies |
| Test Script | `test_gsc_connection.py` | Connection validation |
| Setup Script | `setup_gsc_claude.sh` | Automated installation |

---

## Google Cloud URLs

| Task | URL |
|------|-----|
| Create Project | https://console.cloud.google.com/projectcreate |
| API Enablement | https://console.cloud.google.com/apis/library |
| Service Accounts | https://console.cloud.google.com/iam-admin/serviceaccounts |
| API Credentials | https://console.cloud.google.com/apis/credentials |
| GSC Property | https://search.google.com/search-console |
| GSC Settings | https://search.google.com/search-console/{property}/settings |

---

## Claude Query Examples

### Quick Tests
```
"Hello, are you connected to my GSC data?"
"Can you access my search analytics?"
"Show me something from my GSC property"
```

### Performance Queries
```
"What are my top 10 keywords this week?"
"Which pages get the most impressions?"
"What's my average CTR across all queries?"
"Show me my top pages by click-through rate"
```

### Trend Analysis
```
"How has my traffic changed in the last 30 days?"
"Compare my performance: last month vs. this month"
"Show me the top growing keywords"
"Which pages have improved the most?"
```

### Technical SEO
```
"Are there any indexing errors I should know about?"
"What's the status of my sitemaps?"
"Show me pages with the lowest average position"
"List any mobile usability issues"
```

### Insights
```
"Which of my pages rank best?"
"What keywords drive the most traffic?"
"Analyze my search performance by device"
"Give me actionable insights for SEO"
```

---

## Troubleshooting Decision Tree

```
Problem: MCP Server Not Showing in Claude
├─ Check: Is Claude config file valid JSON?
│  └─ Fix: Validate JSON syntax at jsonlint.com
├─ Check: Are file paths absolute (not relative)?
│  └─ Fix: Use full paths like /Users/name/.venv/bin/python
├─ Check: Does Python executable exist?
│  └─ Fix: which python3 (should return path)
└─ Action: Restart Claude Desktop completely

Problem: Authentication Failed
├─ Check: Does credentials file exist and is readable?
│  └─ Fix: ls -la ~/.gsc-credentials/service-account-key.json
├─ Check: Is service account added to GSC property?
│  └─ Fix: GSC Settings → Users & Permissions (check for email)
├─ Check: Is Search Console API enabled?
│  └─ Fix: Google Cloud Console → APIs & Services → Enable Search Console API
└─ Action: Run test_gsc_connection.py to diagnose

Problem: "Permission Denied" Error
├─ Check: File permissions on credentials
│  └─ Fix: chmod 600 ~/.gsc-credentials/service-account-key.json
├─ Check: Service account permission level in GSC
│  └─ Fix: Set to Owner or Full access
└─ Action: Wait 5-10 minutes for permissions to propagate

Problem: No Results from Queries
├─ Check: Is GSC property verified in GSC account?
│  └─ Fix: Go to GSC → Property Settings → Verify ownership
├─ Check: Does property have search data?
│  └─ Fix: Wait 24-48 hours after adding property
└─ Action: Run test_gsc_connection.py to verify connection
```

---

## Security Checklist

- [ ] Service account key NOT in version control
- [ ] Key file permissions set to 600: `chmod 600 ~/.gsc-credentials/service-account-key.json`
- [ ] Separate service accounts for different projects
- [ ] Key rotation scheduled (every 90 days recommended)
- [ ] Audit logs reviewed recently
- [ ] .env file added to .gitignore
- [ ] Backup of credentials stored securely
- [ ] Team members documented in PROJECT_TEMPLATE.md

---

## Common Queries for Your First Test

### Test #1: Basic Connection
```
"Hi! Can you access my Google Search Console data?"
```
Expected: Claude should acknowledge and be ready to query GSC.

### Test #2: Top Keywords
```
"What are my top 5 search queries from the last 7 days?"
```
Expected: List of keywords with impressions/clicks.

### Test #3: Performance
```
"Show me my total clicks and impressions for this month"
```
Expected: Numeric metrics for current month.

### Test #4: Page Analysis
```
"Which of my pages get the most organic traffic?"
```
Expected: List of top-performing pages.

---

## Key Concepts to Remember

| Term | Meaning | In Claude Queries |
|------|---------|------------------|
| **Impressions** | Times your site appeared in search results | "Show impressions" |
| **Clicks** | Times users clicked your result | "Show clicks" |
| **CTR** | Click-through rate (clicks ÷ impressions) | "What's my CTR?" |
| **Position** | Average rank in search results | "Average position" |
| **Query** | The search term entered by user | "Top queries" |
| **Property** | Your site in GSC (domain or URL) | Auto-selected by service account |

---

## Performance Notes

- **Data Freshness:** GSC updates every 24-48 hours
- **Rate Limits:** 25,000 queries/day, 100 queries/100 seconds
- **Response Time:** Usually <2 seconds per query
- **Caching:** Consider caching if running many queries

---

## Getting Help

1. **Check logs:** Claude Help → Show Logs (search for "MCP" or error message)
2. **Run test:** `python3 test_gsc_connection.py`
3. **See SOP:** Detailed guide in `GSC_CLAUDE_SOP.md`
4. **Check permissions:** Verify service account in GSC Settings
5. **Verify API:** Search Console API enabled in Google Cloud Console

---

## Pro Tips

1. **Use date shortcuts:** Claude understands "last week", "last month", "last 90 days"
2. **Ask for comparisons:** "Compare January vs. February"
3. **Request exports:** Some setups support CSV/JSON export
4. **Batch queries:** Ask multiple questions in one message
5. **Ask for analysis:** Claude can provide insights, not just raw data
6. **Use natural language:** "My top pages" works as well as "Show me pages sorted by clicks"

---

**Last Updated:** December 2025
**Version:** 1.0.0
