(define-module (chur recon)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system perl)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages graph)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml))

(define-public ctfr
  (let ((commit "6c7fecdc6346c4f5322049e38f415d5bddaa420d")
        (revision "1"))
    (package
      (name "ctfr")
      (version (git-version "1.2" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/UnaPibaGeek/ctfr.git")
                      (commit "6c7fecdc6346c4f5322049e38f415d5bddaa420d")))
                (sha256
                 (base32 "16facm1wcd1zk9h89q7m5hgpasqzmxm8sbl18ffiyg6zm4glib4p"))))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))
           (let* ((src (assoc-ref %build-inputs "source"))
                  (out (assoc-ref %outputs "out"))
                  (bin (string-append out "/bin")))
             (mkdir-p bin)
             (copy-recursively src out)
             (with-directory-excursion bin
               (call-with-output-file "ctfr"
                 (lambda (p)
                   (format p "#!~a
exec ~a ~a/ctfr.py \"$@\""
                           (string-append (assoc-ref %build-inputs "bash") "/bin/bash")
                           (string-append (assoc-ref %build-inputs "python") "/bin/python3")
                           out)))
               (chmod "ctfr" #o555)
               #t)))))
      (inputs `(("bash" ,bash)
                ("python" ,python)))
      (propagated-inputs `(("python-requests" ,python-requests)))
      (synopsis
       "Abusing Certificate Transparency logs for getting HTTPS websites subdomains.")
      (description "Do you miss AXFR technique? This tool allows to get the subdomains from a HTTPS website in a few seconds.
How it works? CTFR does not use neither dictionary attack nor brute-force, it just abuses of Certificate Transparency logs.
For more information about CT logs, check www.certificate-transparency.org and crt.sh.")
      (home-page "https://github.com/UnaPibaGeek/ctfr")
      (license license:gpl3))))

(define-public perl-rpc-xml
  (package
    (name "perl-rpc-xml")
    (version "0.80")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1xvy9hs7bqsjnk0663kf7zk2qjg0pzv96n6z2wlc2w5bgal7q3ga"))))
    (build-system perl-build-system)
    (propagated-inputs
     `(("perl-datetime" ,perl-datetime)
       ("perl-datetime-format-iso8601"
        ,perl-datetime-format-iso8601)
       ("perl-libwww" ,perl-libwww)
       ("perl-xml-libxml" ,perl-xml-libxml)
       ("perl-xml-parser" ,perl-xml-parser)))
    (home-page
     "https://metacpan.org/release/RPC-XML")
    (synopsis
     "Data, client and server classes for XML-RPC")
    (description "This package is an implementation of the XML-RPC standard in Perl.
The goal is to provide a client, a stand-alone server and an Apache/mod_perl content-handler class.")
    (license license:perl-license)))

(define-public nikto
  (let ((commit "d8eb05496f69c0dc703d19dc012d2547d0467705")
        (revision "1"))
    (package
      (name "nikto")
      (version (git-version "2.1.6" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/sullo/nikto.git")
                      (commit commit)))
                (sha256
                 (base32 "0pkiw9chm3yn3s5bw5a07kq1rvyz6ij8k03i4p7syvgamzfsida4"))))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
         #:builder (begin
                     (use-modules (guix build utils))
                     (let* ((src (assoc-ref %build-inputs "source"))
                            (out (assoc-ref %outputs "out"))
                            (bin (string-append out "/bin"))
                            (bash (string-append (assoc-ref %build-inputs "bash") "/bin/bash"))
                            (perl (string-append (assoc-ref %build-inputs "perl") "/bin/perl")))
                       (mkdir-p bin)
                       (copy-recursively src out)
                       (with-directory-excursion bin
                         (call-with-output-file "nikto"
                           (lambda (p)
                             (format p "#!~a
exec ~a ~a/program/nikto.pl \"$@\"" bash perl out)))
                         (chmod "nikto" #o555)
                         #t)))))
      (inputs `(("bash" ,bash)
                ("perl" ,perl)))
      (propagated-inputs `(("perl-net-ssleay" ,perl-net-ssleay)
                           ("perl-rpc-xml" ,perl-rpc-xml)))
      (synopsis "Nikto web server scanner")
      (description "Nikto is a web server assessment tool. It is designed to find various default and insecure files, configurations and programs on any type of web server.")
      (home-page "https://cirt.net/Nikto2")
      (license license:gpl2))))

(define-public python-xlsxwriter
  (package
    (name "python-xlsxwriter")
    (version "1.2.8")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "XlsxWriter" version))
       (sha256
        (base32
         "0sv553dj5h3qxbn8xfaqxr3bx2lglp85cxlcsnf3mzqnmf41k3j8"))))
    (build-system python-build-system)
    (home-page "https://github.com/jmcnamara/XlsxWriter")
    (synopsis "A Python module for creating Excel XLSX files.")
    (description "A Python module for creating Excel XLSX files.")
    (license license:bsd-3)))

(define-public python-shodan
  (package
    (name "python-shodan")
    (version "1.23.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "shodan" version))
       (sha256
        (base32
         "16rkbhdj7al7p8s1pfsjx9agxpvisbvyvcd04rm1kigpz87p9c1i"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases (delete 'check))))
    (propagated-inputs
     `(("python-click" ,python-click)
       ("python-click-plugins" ,python-click-plugins)
       ("python-colorama" ,python-colorama)
       ("python-requests" ,python-requests)
       ("python-xlsxwriter" ,python-xlsxwriter)
       ("python-pytest" ,python-pytest)
       ("python-aiodns" ,python-aiodns)
       ("python-beautifulsoup4" ,python-beautifulsoup4)))
    (home-page
     "http://github.com/achillean/shodan-python/tree/master")
    (synopsis
     "Python library and command-line utility for Shodan (https://developer.shodan.io)")
    (description
     "Python library and command-line utility for Shodan (https://developer.shodan.io)")
    (license #f)))

(define-public theharvester
  (let ((commit "ceb4c3b1527aa05eb92a028036a4b73d78eb389b")
        (revision "1"))
    (package
      (name "theharvester")
      (version (git-version "3.1.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/laramies/theHarvester.git")
                      (commit commit)))
                (sha256
                 (base32 "0lxzxfa9wbzim50d2jmd27i57szd0grm1dfayhnym86jn01qpvn3"))))
      (build-system python-build-system)
      (inputs `(("python-gevent" ,python-gevent)
                ("python-pyyaml" ,python-pyyaml)
                ("python-grequests" ,python-grequests)
                ("python-dnspython" ,python-dnspython)
                ("python-shodan" ,python-shodan)
                ("python-plotly" ,python-plotly)
                ("python-pycares" ,python-pycares)
                ("python-netaddr" ,python-netaddr)))
      (synopsis "E-mails, subdomains and names Harvester - OSINT ")
      (description "theHarvester is a very simple to use, yet powerful and effective tool designed to be used in the early stages of a
penetration test or red team engagement. Use it for open source intelligence (OSINT) gathering to help determine a
company's external threat landscape on the internet. The tool gathers emails, names, subdomains, IPs and URLs using
multiple public data sources that include:")
      (home-page "http://www.edge-security.com/")
      (license license:gpl2))))
