### TLS Support in `cx-server`

The TLS protocols provide an encryption of a traffic exchange in the transport layer.
The `cx-server` can be set up to use this encryption for additional security measures.
In order to enable TLS in your cx-server, you need a certificate either self-signed or issued by a CA along with an RSA private key which was used to generate the certificate signing request.
In the following guide, you will learn how to generate a self-signed certificate.

##### Install OpenSSL
OpenSSL is a general purpose cryptography library which we will use in the following steps to generate the self-signed certificate.
Please download and install it from the [downloads](https://www.openssl.org/source/) page. For Windows binaries, please check this [wiki](https://wiki.openssl.org/index.php/Binaries) page.
In order to ensure that OpenSSL is successfully installed, execute the below command and verify.

```
$ openssl version
OpenSSL 1.0.2g  1 Mar 2016
```

##### Generate private key
The first step is to create your RSA private key.
```
$ openssl genrsa -out jenkins.key 2048
Generating RSA private key, 2048 bit long modulus
......................+++
..........................................+++
e is 65537 (0x10001)
```
##### Generate Certificate Signing Request [(CSR)](https://en.wikipedia.org/wiki/Certificate_signing_request)
Once you have the private key, the next step is to create the CSR. Enter the below command to generate a CSR.
```
 openssl req -new -key jenkins.key -out jenkins.csr
```
You will be prompted to provide multiple pieces of information regarding the certificate that you will be creating.

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:Berlin
Locality Name (eg, city) []:Berlin
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example pvt ltd
Organizational Unit Name (eg, section) []:myUnit
Common Name (e.g. server FQDN or YOUR name) []:jenkins.example.com
Email Address []:my.email@example.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:.
An optional company name []:
```
Once you enter all the details, a `jenkins.csr` file will be created.

##### Generating a Self-Signed Certificate
You can now create a self-signed certificate using the CSR. Run the command given below. This will generate a certificate `jenkins.crt` with a validity of 1 year.

```
$ openssl x509 -req -days 365 -in jenkins.csr -signkey jenkins.key -out jenkins.crt
Signature ok
subject=/C=DE/ST=Berlin/L=Berlin/O=Example pvt Ltd/OU=myOrgUnit/CN=jenkins.example.com/emailAddress=my_email@example.com
Getting Private key
```
