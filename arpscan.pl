#!/usr/bin/perl -w

#######CONTROL PARAMETERS ############################
$debug = 1;                               ### turn debug controls on(1) or off(0)
$WORKDIR = "/home/bat/apps";	       	  ### desired location for "rawoutput" and "index.html"
$SNMPWALKPATH = "/usr/bin/ucd-snmp/bin";  ### path to ucd-snmp implementation of snmpwalk
$FINALWWW = "/var/www/html/arpscan";      ### path to final destination for arpscan.pl web report

##### BY Jason R. Battles #############################

$currdate = `date`;
if ($debug) {print"==>\$WORDIR: $WORKDIR\n==> arpscan.pl executed at $currdate\n\n";}

####	OPEN FILEHANDLES, ONE FOR OUTPUT AND ONE FOR OUTPUT
open (RTRLIST, "$WORKDIR/routerlist") || die "Unable to open input file!\n";
open (RAW, ">$WORKDIR/rawoutput") || die "Unable to open raw output file!\n";

while (<RTRLIST>) {				##  GRAP THE ARP TABLE FROM EACH ROUTER AND SEND TO RAW OUTPUT
   chomp;
   ($site,$ipaddr) = split(/,/);
   if ($debug) {print "Initiating arp scan at site $site using router ip address $ipaddr\n";}
   print (RAW "Site: $site\n");
   $results = `$SNMPWALKPATH/snmpwalk $ipaddr SNMP-COMMUNITY-RO-PASSWORD .1.3.6.1.2.1.3.1.1.2`;
   if ($debug) {print "Raw OID output:\n$results\n";}
   print (RAW "$results");
}
close(RAW);
close(RTRLIST);

$currdate2 = `date`;

if ($debug) {print"==> arp table scans completed at $currdate2\n\n";}

open (RAW2, "$WORKDIR/rawoutput") || die "Unable to open raw input file!\n";
open (HTML, ">$WORKDIR/index.html") || die "Unable to open HTML report file!\n";

print (HTML "<html>
<head>
<title>ACME Network Services - Network Device Type Scanner<\/title>
<\/head>
");


if ($debug) {
print "Location\tIPADDRESS\tMACADDR\tDNSPTR\t\tManufacturer\n";
print "========\t=========\t=======\t======\t\t============\n";
}

## Print the BODY statement and begin the table statements
print (HTML "<body BGCOLOR=\"#FFFFFF\" TEXT=\"#000000\" LINK=\"#003399\" VLINK=\"#404040\" ALINK=\"#FF0000\" style=\"font-family: Arial; font-size: 10pt\">

<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
  <tr>
    <td width=\"161\" valign=\"top\"><p align=\"left\">
    <img border=\"0\" src=\"\/icons\/NetworkServicesLogo.jpg\" width=\"150\" height=\"49\"><\/td>
    <td width=\"639\" valign=\"bottom\" align=\"right\"><b>
    <font face=\"ARIAL, HELVETICA\" size=\"4\">Network Services - Network Device 
    Type Scanner<\/font><\/b><\/td>
  <\/tr>
  <tr>
    <td width=\"800\" valign=\"top\" colspan=\"2\"><hr size=\"3\" color=\"FF0000\">
    <\/td>
  <\/tr>
  <tr>
    <td width=\"800\" valign=\"top\" bgcolor=\"#FFFFFF\" height=\"15\" colspan=\"2\">
    <p><\/p>
    <p><\/p>
    <p><i><font size=\"2\">Last remote arp scan performed - $currdate 
 <\/font><\/i><\/p>
    <p><font size=\"2\" color=\"#FF0000\">Red font with yellow background indicates unknown or unapproved network device.<\/font><\/p>
    <table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"799\" id=\"AutoNumber1\" style=\"border-left-style: none; border-right: .75pt solid navy; border-top: .75pt solid navy; border-bottom: .75pt solid navy; background-color: white\" fpstyle=\"23,011111100\">
      <tr>
        <td width=\"153\" style=\"font-weight: bold; color: white; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: navy\">
        <font size=\"2\">Location<\/font><\/td>
        <td width=\"79\" style=\"font-weight: bold; color: white; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: navy\">
        <font size=\"2\">IP Address<\/font><\/td>
        <td width=\"102\" style=\"font-weight: bold; color: white; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: navy\">
        <font size=\"2\">MAC Address<\/font><\/td>
        <td width=\"150\" style=\"font-weight: bold; color: white; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: navy\">
        <font size=\"2\">DNS PTR<\/font><\/td>
        <td width=\"309\" style=\"font-weight: bold; color: white; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: navy\">
        <font size=\"2\">Manufacturer<\/font><\/td>
      <\/tr>\n");

$currdate3 = `date`;
if ($debug) {print"==> now beginning mac vendor lookups at $currdate3\n\n";}
while (<RAW2>) {
   chomp;
   if(/Site:/) {
      $_ =~ s/Site: //g;
      if ($debug) {print $_;}
      if ($debug) {print "\n";}
      #### Print the row
      print (HTML "<tr>
        <td width=\"153\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <font size=\"1\"><b>$_<\/b><\/font><\/td>
        <td width=\"79\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <font size=\"1\">\&nbsp;<\/font><\/td>
        <td width=\"102\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <font size=\"1\">&nbsp;<\/font><\/td>
        <td style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\" width=\"150\">
        <font size=\"1\">&nbsp;<\/font><\/td>
        <td width=\"309\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <font size=\"1\">&nbsp;<\/font><\/td>
      <\/tr>");
   } else { 
      ($left,$right) = split(/=/);
      $left =~ s/at.atTable.atEntry.atPhysAddress.2.1.//g;
      $left =~ s/at.atTable.atEntry.atPhysAddress.3.1.//g;
      chop($right);
      $right =~ s/  Hex: //g;
      $right =~ s/ /-/g;
      @compsright = split(/-/, $right);
      $lookup = $compsright[0].$compsright[1].$compsright[2];
      $vendor = `grep $lookup $WORKDIR/vendormacs.txt`;
      #print "$vendor\n";
      @compsvendor = split(/\s+/, $vendor);
      $finalvendor = join "", $compsvendor[3]," ",$compsvendor[4]," ",$compsvendor[5];
      $dnsname = `dig \@10.10.5.10 -x $left +short`;
      chomp($dnsname);							# Remove the newline from response
      chop($dnsname);							# Remove the trailing dot

      if ($debug) {print "\t\t$left\t$right\t$dnsname\t$finalvendor\n";}
      
      ####  DETERMINE IF VENDOR IS APPROVED OR NOT 
      SWITCH: { 
         if ($finalvendor =~ /^cisco s/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^cisco /i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^hewlett/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^american power/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^zebra tech/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^agere/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^intermec/i) {$approve = 1; last SWITCH;} 
         if ($finalvendor =~ /^compaq/i) {$approve = 1; last SWITCH;} 
         $approve = 0;
      }
         

      #### Print the device information row
      if ($approve) {

         print (HTML "<tr>
        <td width=\"153\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <font size=\"1\"><b>\&nbsp;<\/b><\/font><\/td>
        <td width=\"79\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <b><font size=\"1\">$left<\/font><\/b><\/td>
        <td width=\"102\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <b><font size=\"1\">$right<\/font><\/b><\/td>
        <td style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\" width=\"150\">
        <font size=\"1\">$dnsname\&nbsp; <\/font><\/td>
        <td width=\"309\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: white\">
        <b><font size=\"1\">$finalvendor <\/font><\/b><\/td>
      <\/tr>\n");
     } else {
        print (HTML "<tr>
        <td width=\"153\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: #FFFF00\">
        <font size=\"1\" color=\"#FF0000\"><b>\&nbsp;<\/b><\/font><\/td>
        <td width=\"79\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: #FFFF00\">
        <b><font size=\"1\" color=\"#FF0000\">$left <\/font><\/b><\/td>
        <td width=\"102\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: #FFFF00\">
        <b><font size=\"1\" color=\"#FF0000\">$right<\/font><\/b><\/td>
        <td style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: #FFFF00\" width=\"150\">
        <b><font size=\"1\" color=\"#FF0000\">$dnsname\&nbsp<\/font><\/b><\/td>
        <td width=\"309\" style=\"font-weight: normal; color: black; border-left: .75pt solid navy; border-right-style: none; border-top-style: none; border-bottom: .75pt solid navy; background-color: #FFFF00\">
        <b><font size=\"1\" color=\"#FF0000\">$finalvendor\&nbsp<\/font><\/b><\/td>
      <\/tr>\n");
    }
   }
}
$currdate4 = `date`;
if ($debug) {print "===> arpscan.pl now completed at $currdate4\n";}
print (HTML "   <\/table>\n
    <\/td>
  <\/tr>
<\/table>\n
<p><i><font size=\"1\">arpscan.pl(v1.0) written by Jason R. Battles
 <\/font><\/i><\/p>\n<\/body>
<\/html>");
close RAW2;
close HTML;
system("mv -f $WORKDIR/index.html $FINALWWW/index.html");
