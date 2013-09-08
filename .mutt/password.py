#!/usr/bin/python
from gi.repository import GObject, GnomeKeyring

GObject.set_application_name("mutt")

def keyring(user="", host="", proto="imap"):
	if "@" not in user:
		user = user+"@gmail.com"

	# SSO (gmail <- evolution, university <- chrome)
	if host in ("imap.gmail.com", "smtp.gmail.com"):
		result, values = GnomeKeyring.find_network_password_sync(None, None, "www.google.com", None, None, None, 0)
	elif host in ("imap.mathematik.uni-marburg.de", "smtp.mathematik.uni-marburg.de"):
		attrs = GnomeKeyring.Attribute.list_new()
		GnomeKeyring.Attribute.list_append_string(attrs, 'signon_realm', "https://www.mathematik.uni-marburg.de/")
		result, values = GnomeKeyring.find_items_sync(GnomeKeyring.ItemType.GENERIC_SECRET, attrs)
	elif host in ("imap.students.uni-marburg.de", "smtp.students.uni-marburg.de"):
		attrs = GnomeKeyring.Attribute.list_new()
		GnomeKeyring.Attribute.list_append_string(attrs, 'signon_realm', "https://home.students.uni-marburg.de/")
		result, values = GnomeKeyring.find_items_sync(GnomeKeyring.ItemType.GENERIC_SECRET, attrs)
	else:
		result, values = GnomeKeyring.find_network_password_sync(user, None, host, None, proto, None, 0)
  
	try:
		return values[0].secret
	except:
		return values[0].password
import sys
print keyring(*sys.argv[1:])
