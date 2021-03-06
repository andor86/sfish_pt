#
# (C) Tenable Network Security, Inc.
#


include("compat.inc");


if(description)
{
 script_id(16044);
 script_version ("$Revision: 1.5 $");
 script_bugtraq_id(12048);
 script_xref(name:"OSVDB", value:"53699");
 
 script_name(english:"e_Board index2.cgi message Parameter Traversal Arbitrary File Access");
 script_summary(english:"Checks for e_Board");
 
 script_set_attribute(
   attribute:"synopsis",
   value:string(
     "A web application running on the remote host has a directory traversal\n",
     "vulnerability."
   )
 );
 script_set_attribute(
   attribute:"description", 
   value:string(
     "The remote host is running e_Board, a web-based bulletin board system\n",
     "written in Perl.\n\n",
     "The version of e_Board running on the remote web server has a\n",
     "directory traversal vulnerability in the 'message' parameter of\n",
     "'index2.cgi'.  A remote attacker could exploit this to read sensitive\n",
     "information from the system."
   )
 );
 script_set_attribute(
   attribute:"see_also",
   value:"http://packetstormsecurity.org/0412-exploits/eboard40.txt"
 );
 script_set_attribute(
   attribute:"solution", 
   value:"Upgrade to the latest version of e_Board or disable this software"
 );
 script_set_attribute(
   attribute:"cvss_vector", 
   value:"CVSS2#AV:N/AC:L/Au:N/C:P/I:N/A:N"
 );
 script_end_attributes();

 script_category(ACT_GATHER_INFO);
 script_family(english:"CGI abuses");

 script_copyright(english:"This script is Copyright (C) 2004-2009 Tenable Network Security, Inc.");

 script_dependencie("http_version.nasl");
 script_require_ports("Services/www", 80);
 script_exclude_keys("Settings/disable_cgi_scanning");

 exit(0);
}

#
# The script code starts here
#

include("global_settings.inc");
include("misc_func.inc");
include("http.inc");


port = get_http_port(default:80);

foreach dir (list_uniq(make_list("/cgi-bin/eboard40/", cgi_dirs())))
{
 req = string(dir,"/index2.cgi?frames=yes&board=demo&mode=Current&threads=Collapse&message=../../../../../../../../../../etc/passwd%00");
 buf = http_send_recv3(method:"GET", item:req, port:port);
 if(isnull(buf)) exit(0);

 if(egrep(pattern:".*root:.*:0:[01]:.*", string:buf[2])){
 	security_warning(port);
	exit(0);
	}
}
