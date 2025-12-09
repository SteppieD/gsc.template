# Project Template: GSC + Claude Code Integration

Use this template when setting up a new project that requires Google Search Console + Claude Code integration.

## Project Information

**Project Name:** [Your Project Name]
**GSC Property:** [Your Site URL]
**Created Date:** [Date]
**Created By:** [Your Name]

---

## Setup Checklist

### Phase 1: Google Cloud Setup
- [ ] Create new Google Cloud project
  - Name: `claude-gsc-{project-name}`
  - Project ID: `_________________`
- [ ] Enable Search Console API
- [ ] Navigate to Credentials page

### Phase 2: Service Account
- [ ] Create service account
  - Name: `claude-gsc-sa`
  - Service Account ID: `_________________`
- [ ] Generate JSON key
  - Downloaded to: `$HOME/.gsc-credentials/[project-name]-key.json`
  - Verified readable: `chmod 600` ✓
- [ ] Document service account email: `_________________`

### Phase 3: GSC Configuration
- [ ] Add service account to GSC property
- [ ] Set permission level: ☐ Owner ☐ Full ☐ Other
- [ ] Verify access in GSC Settings → Users & Permissions

### Phase 4: Claude Setup
- [ ] Clone MCP server repository
- [ ] Create Python virtual environment
- [ ] Install dependencies
- [ ] Update Claude config file
  - Platform: ☐ Claude Desktop ☐ Claude Code
  - Config location: `_________________`
- [ ] Restart Claude application

### Phase 5: Testing
- [ ] Run test connection script
  ```bash
  python3 test_gsc_connection.py --key-path ~/.gsc-credentials/[project-name]-key.json
  ```
- [ ] Test sample queries in Claude:
  - [ ] "Show top keywords this week"
  - [ ] "What's my recent performance?"
  - [ ] "List indexed pages"

### Phase 6: Documentation
- [ ] Document project-specific queries
- [ ] Create usage guidelines for team
- [ ] Set up credentials backup
- [ ] Document rotation schedule

---

## Configuration

### Service Account Details
```
Service Account Email: ____________________________
Project ID: ____________________________
Key Location: ~/.gsc-credentials/[project-name]-key.json
Key Created: ____________________________
Key Last Rotated: ____________________________
```

### Claude Configuration
```json
{
  "mcpServers": {
    "gsc-[project-name]": {
      "command": "/path/to/python",
      "args": ["/path/to/gsc_server.py"],
      "env": {
        "GSC_CREDENTIALS_PATH": "/path/to/key.json"
      }
    }
  }
}
```

### Environment Variables (if applicable)
```bash
GSC_SITE_URL=https://example.com
GSC_PROPERTY_ID=sc-domain:example.com
CREDENTIALS_PATH=~/.gsc-credentials/[project-name]-key.json
```

---

## Usage Guide

### Available Queries

**Performance Analysis**
```
"What are my top performing pages this month?"
"Show me the CTR trend for the last 90 days"
"Which queries have the highest average position?"
```

**Technical SEO**
```
"What's the current indexing status?"
"List pages with indexing errors"
"Show me security issues detected"
```

**Keyword Research**
```
"What are the top 20 search queries for my site?"
"Which keywords drive the most traffic?"
"Show me keywords by search volume"
```

### Tips
- Use date ranges: "last 7 days", "last month", "last quarter"
- Combine metrics: "Show clicks and impressions"
- Filter by: "on mobile", "desktop only"
- Compare periods: "vs. last month"

---

## Security Notes

- [ ] Key file stored in secure location: `$HOME/.gsc-credentials/`
- [ ] Permissions set correctly: `chmod 600`
- [ ] Key NOT committed to version control
- [ ] Key rotation schedule: Every _____ days
- [ ] Team members with access: _____________________
- [ ] Backup location: _____________________
- [ ] Last audit date: _____________________

---

## Team Access

### Users with Access
| Name | Role | Permissions | Added Date |
|------|------|-------------|-----------|
| | | | |
| | | | |

### Credentials Rotation Schedule
- **Next rotation:** _____________________
- **Responsible person:** _____________________
- **Backup holder:** _____________________

---

## Integration Notes

### API Rate Limits
- Queries per day: 25,000
- Queries per 100 seconds: 100
- Current usage: _____% of quota

### Connected Tools
- [ ] Claude Desktop
- [ ] Claude Code
- [ ] Other: _____________________

### Performance Baseline
- Initial setup date: _____________________
- Expected query response time: _____________________
- Data freshness: GSC updates every 24-48 hours

---

## Troubleshooting Log

| Date | Issue | Resolution | Status |
|------|-------|-----------|--------|
| | | | |
| | | | |

---

## References

- [GSC_CLAUDE_SOP.md](../GSC_CLAUDE_SOP.md) - Full setup guide
- [Google Search Console API](https://developers.google.com/webmaster-tools)
- [MCP Documentation](https://modelcontextprotocol.io)

---

## Sign-off

**Setup Completed By:** _____________________
**Date:** _____________________
**Verified By:** _____________________
**Date:** _____________________

---

**Last Updated:** _____________________
