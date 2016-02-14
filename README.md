sf-imap-server extension provides complete IMAP server combined with fetchmail.

**What is the problem with existing email solutions?**

Imagine that you have multiple email accounts - some free on Gmail.com, some
other on Yahoo.com, some commercial ones etc. Say 17 accounts overall. And
imagine that you want to use them simultaneously. Now you have 3 options:

- log in separately to 17 webmails (hard even to imagine)
- add these 17 accounts to some email client, like Thunderbird, Outlook etc.
  (great, but all accounts have to support IMAP protocol, and adding another
  email client on another computer can be obnoxious, especially when you
  already forgot passwords and have them stored only in an existing client)
- choose one "master" account, that is able to fetch emails from remote
  accounts (eg. Gmail.com), then add 16 remote accounts to it and use only
  this account, either via webmail or desktop/mobile email client (does it
  solve all your problems? what if you lose exactly this "master" account?)

Now imagine that you have eg. 2432 email accounts instead of 17. Does any
of the above solutions still solve your problem?

Then optionally imagine that you are a part of group of people with the similar
problem (mostly a company), where each of you have a bunch of email accounts.

**What is the solution provided by sf-imap-server extension?**

It installs Courier IMAP server and fetchmail tool on your Debian/Ubuntu server.

Then it allows creating internal IMAP accounts - such account is the only one
that you have to connect to your email client. For each IMAP account you need to
define a set of delivery rules, from which each rule causes fetchmail to fetch
new messages from external account and deliver it to your internal account.

This way, you have your own "master" account on your own server, which cannot be
banned by some email provider, law enforcement authority etc., and cannot be
lost after eg. quitting your job. Of course you can still lose such address, but
only the address: you'll still have all your previously received messages in
place, and you don't need to worry about "slave" accounts plugged to your lost
"master" account.

**Why 3 different servers?**

sf-imap-server follows Server Farmer philosophy: there is a customer (which is
the end user), and there is an IT support company. The latter runs the central
management server, which is a central database of individual accounts and their
UIDs, and central storage server, which is responsible for backups, while
customer runs the production server.

**Commercial support**

This extension contains the full source code of the whole solution. However
if you're just looking for the working service, we can provide ready-to-use
physical or virtual machines with 24/7 email/phone support:

http://fajne.it/koniec-problemow-z-awariami-lacza.html
