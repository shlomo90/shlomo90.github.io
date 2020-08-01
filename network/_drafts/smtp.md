smtp (secure mail transfer protocol)


smtp is defined at rfc821.
extended smtp is defined rfc5321

commonly use the Transmission Control Protocol on port number 25

email clients typically use SMTP only for sending messges to a mail server for relaying
and submit outgoing email to the mail server on port 587 or 465 (rfc8314)

---

### Flow

MUA (Mail User Agent)
    MUA send the mail to MSA.

MSA (Mail Submission Agent) using SMTP on TCP port 587
(Most mailboc providers sitll allow submission on traditional port 25)
    MSA delivers the mail to its mail transfer agent(MTA)

    MSA, MTA are instances of the same software.
    but If they are each processing, they use SMTP to intercomunicate.


MTA uses the DNS to look up the mail exchanger record (MX record) for the recipient's domain (the right of @)
    MTA selects an exchange server...

Once the final hop accepts the incoming message, it hands it to a mail delivery agent (MDA)

SMTP defines message transport, not the message content. Thus it defines the mail envelope and its parameters.

---

### Protocol Overview

SMTP is connection-oriented, text-based protocol


---

UUCP (Unix to Unix Copy Program) is virtually disappeared

dispute
