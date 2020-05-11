---
layout: post
comments: true
---

# Send Patch With Git-Email

* Let's figure out how to send your friends patch files with git-send-email.

## Things you need to prepare

* git(v2.26)
* git-email(1:1.7.4.1-3)
* CERTIFICATES (optional)
* smtp server

## Make a patch file

Simply, you can make patch files by using a 'git-format-patch' command.

1. Edit the source code
2. Stage the changes
3. Make a commit
4. Make a patch file with git-format-patch

~~~ bash
#First, check the base point.
git format-patch <base point>

# After that, it generates patch files.
~~~

## Send email the patch file

* Before send email, We need to set .gitconfig file

~~~
...

[sendemail]
    smtpencryption = ssl                 #<-- you can use 'tls' instead of 'ssl'
    smtpserver = smtp.xxxxxx.com         #<-- set your smtp server
    smtpuser = xxxxxx@xxxxxxxxxxxxxx.com #<-- set your email address
    smtpserverport = 465                 #<-- ssl use the port 465

...
~~~

* And, We don't check the ssl verify param so, Let's edit the `/usr/libexec/git-core/git-send-email` file

~~~perl
1500         if ($smtp_encryption eq 'ssl') {                   #<--- we use the 'ssl'
1501             $smtp_server_port ||= 465; # ssmtp
1502             require IO::Socket::SSL;
1503
1504             # Suppress "variable accessed once" warning.
1505             {
1506                 no warnings 'once';
1507                 $IO::Socket::SSL::DEBUG = 1;
1508             }
1509
1510             # Net::SMTP::SSL->new() does not forward any SSL options   #<-- we don't use the verify
1511             #IO::Socket::SSL::set_client_defaults(                     #    Let's comment this
1512             #   ssl_verify_params());
1513
1514             if ($use_net_smtp_ssl) {
1515                 require Net::SMTP::SSL;
1516                 $smtp ||= Net::SMTP::SSL->new($smtp_server,
1517                                   Hello => $smtp_domain,
1518                                   Port => $smtp_server_port,
1519                                   Debug => $debug_net_smtp);
1520             }
1521             else {
1522                 $smtp ||= Net::SMTP->new($smtp_server,
1523                              Hello => $smtp_domain,
1524                              Port => $smtp_server_port,
1525                              Debug => $debug_net_smtp,
1526                              SSL => 1);
1527             }
1528         }
~~~

* Now, We are ready to send patch files. Run the command below.

~~~
sudo git send-email /path/to/patch/file --to=[dest email address]
~~~

* Done!
