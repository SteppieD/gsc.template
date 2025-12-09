# Google Search Console + Claude Code Integration

A complete integration setup for connecting Google Search Console with Claude Code via the Model Context Protocol (MCP), enabling natural language queries and analysis of your SEO data.

## Overview

This project provides:
- **SOP Documentation** - Step-by-step setup guide for replication
- **Test Connection Script** - Validates your GSC authentication before Claude integration
- **Automated Setup** - Bash script to automate initial configuration
- **Project Templates** - Ready-to-use folder structures for new projects

## Quick Start

### 1. Verify Prerequisites
```bash
python3 --version  # Requires Python 3.8+
git --version
```

### 2. Run Setup Script
```bash
chmod +x setup_gsc_claude.sh
./setup_gsc_claude.sh
```

### 3. Test Connection
```bash
python3 test_gsc_connection.py --key-path ~/.gsc-credentials/service-account-key.json
```

### 4. Configure Claude
- Copy the MCP server configuration from the setup script output
- Edit your Claude Desktop config file
- Restart Claude and test with a query

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
