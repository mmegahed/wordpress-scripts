**All code and information for educational purposes only**

Tools for Wordpress cms information gathering and penetration testing.

[wp_find_password](http://warolv.net/blog/2017/05/14/wordpress-brute-force-password-attack-using-xmlrpc-api/) - script to find password for specific username using [XML-RPC WordPress API](https://codex.wordpress.org/XML-RPC_WordPress_API/Users)

wp_info_gathering - wordpress info gathering like: wordpress version, xmlrpc API enabled or disabled, user enumeration.  
usage: wp_info_gathering -u 'http://127.0.0.1:8080' -wxe -n 2, will get version, XML-RPC disabled/enabled, enumeration with max enumeration number is 2

Password lists taken from [SecList](https://github.com/danielmiessler/SecLists/tree/master/Passwords).

[wp_single_page_analysis](http://warolv.net/blog/2017/05/22/wordpress-single-page-analysis-or-passive-information-gathering/) - wordpress single page analysis or passive information gathering, script to gather information about wordpress loading single page only

## License

Copyright (c) 2017 Igor Zhivilo @warolv. See [MIT-LICENSE](https://en.wikipedia.org/wiki/MIT_License) for further details.
