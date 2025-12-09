#!/usr/bin/env python3
"""
Test Connection Script for Google Search Console + Claude Code Integration

This script validates that your GSC credentials are working correctly
before integrating with Claude Code.

Usage:
    python test_gsc_connection.py --key-path /path/to/service-account-key.json
"""

import json
import sys
import argparse
from pathlib import Path
from typing import Optional, Dict, Any

try:
    from google.oauth2 import service_account
    from google.auth.transport.requests import Request
    from googleapiclient.discovery import build
except ImportError:
    print("Error: Required Google API libraries not installed.")
    print("Install with: pip install google-auth-oauthlib google-auth-httplib2 google-api-python-client")
    sys.exit(1)


def load_credentials(key_path: str) -> Dict[str, Any]:
    """Load service account credentials from JSON file."""
    try:
        with open(key_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Credentials file not found at {key_path}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON in credentials file {key_path}")
        sys.exit(1)


def authenticate(credentials_dict: Dict[str, Any]):
    """Authenticate using service account credentials."""
    try:
        credentials = service_account.Credentials.from_service_account_info(
            credentials_dict,
            scopes=['https://www.googleapis.com/auth/webmasters.readonly']
        )
        credentials.refresh(Request())
        return credentials
    except Exception as e:
        print(f"Error: Authentication failed - {str(e)}")
        sys.exit(1)


def test_gsc_connection(credentials, service_account_email: str) -> Optional[Dict[str, Any]]:
    """Test connection to Google Search Console API."""
    try:
        service = build('webmasters', 'v3', credentials=credentials)

        # Attempt to list sites
        request = service.sites().list()
        response = request.execute()

        return response
    except Exception as e:
        print(f"Error: Failed to connect to GSC API - {str(e)}")
        return None


def print_test_results(creds_dict: Dict[str, Any], gsc_response: Optional[Dict[str, Any]]):
    """Print formatted test results."""
    print("\n" + "="*60)
    print("GOOGLE SEARCH CONSOLE CONNECTION TEST")
    print("="*60 + "\n")

    # 1. Credentials validation
    print("✓ Step 1: Credentials File")
    print(f"  Service Account Email: {creds_dict.get('client_email')}")
    print(f"  Project ID: {creds_dict.get('project_id')}")
    print(f"  Valid JSON: Yes\n")

    # 2. Authentication
    print("✓ Step 2: Google Authentication")
    print("  Successfully authenticated with Google API\n")

    # 3. GSC API Connection
    if gsc_response is None:
        print("✗ Step 3: GSC API Connection")
        print("  Failed to retrieve GSC properties\n")
        return False

    print("✓ Step 3: GSC API Connection")
    sites = gsc_response.get('siteEntry', [])
    print(f"  Connected successfully")
    print(f"  Properties accessible: {len(sites)}\n")

    # 4. List accessible properties
    if sites:
        print("✓ Step 4: Accessible Properties")
        for i, site in enumerate(sites, 1):
            permission = site.get('permissionLevel', 'UNKNOWN')
            site_url = site.get('siteUrl', 'UNKNOWN')
            print(f"  {i}. {site_url}")
            print(f"     Permission: {permission}")
    else:
        print("⚠ Step 4: No Properties Found")
        print("  The service account is authenticated but has no GSC properties.")
        print("  Make sure you've added the service account to your GSC property.\n")
        return True  # Still successful auth, just no properties

    print("\n" + "="*60)
    print("ALL TESTS PASSED ✓")
    print("="*60)
    print("\nYou're ready to integrate with Claude Code!")
    print("Next steps:")
    print("  1. Configure Claude Desktop/Code with your credentials path")
    print("  2. Restart Claude application")
    print("  3. Test with natural language queries in Claude\n")

    return True


def main():
    parser = argparse.ArgumentParser(
        description='Test Google Search Console connection for Claude integration'
    )
    parser.add_argument(
        '--key-path',
        type=str,
        help='Path to service account JSON key file',
        default=None
    )

    args = parser.parse_args()

    # Determine credentials path
    if args.key_path:
        creds_path = args.key_path
    else:
        # Try default locations
        default_paths = [
            Path.home() / '.gsc-credentials' / 'service-account-key.json',
            Path.cwd() / 'service-account-key.json',
            Path.cwd() / '.env.json'
        ]

        creds_path = None
        for path in default_paths:
            if path.exists():
                creds_path = str(path)
                break

        if not creds_path:
            print("Error: Could not find credentials file.")
            print("\nUsage: python test_gsc_connection.py --key-path /path/to/service-account-key.json")
            print("\nOr place your credentials at one of these locations:")
            for path in default_paths:
                print(f"  - {path}")
            sys.exit(1)

    print(f"Testing connection with credentials from: {creds_path}\n")

    # Load credentials
    creds_dict = load_credentials(creds_path)
    service_account_email = creds_dict.get('client_email')

    print(f"Credentials loaded for: {service_account_email}\n")

    # Authenticate
    print("Authenticating with Google API...")
    credentials = authenticate(creds_dict)
    print("✓ Authentication successful\n")

    # Test GSC connection
    print("Testing Google Search Console connection...")
    gsc_response = test_gsc_connection(credentials, service_account_email)

    # Print results
    print_test_results(creds_dict, gsc_response)

    return 0 if gsc_response is not None else 1


if __name__ == '__main__':
    sys.exit(main())
