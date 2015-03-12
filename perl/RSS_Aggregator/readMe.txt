Make sure following 8 files are present.
1) feeds
2) logo.jpg
3) tags_generator.pl
4) rss_aggregator.sh
5) page_template
6) html_writer.pl
7) parseFeed.awk
8) helpers.pl

1.How to add a feed or subscribe to a feed:
---------------------------------------------
Add the url of feed XML in the feeds file.Also make sure feed XML id rss version2.0.
There are already 3 predefined subscriptions in the feeds file.

Also we are adding few more feedXMLs below:

http://rss.sciam.com/ScientificAmerican-Global?format=xml
http://feeds.feedburner.com/time/topstories?format=xml
http://feeds.feedburner.com/OnlineMarketingSEOBlog?format=xml

Make sure 'feeds' file has no blank lines or unwanted spaces. 


2.How to run the aggreator?
-----------------------------------

Copy all the files to a directory.Make sure *.awk,*.pl,*.sh files have execute permissions.
Then execute 'rss_aggregator.sh'.
A new file 'rss_aggregator.html' is created.


3.How to check output?
--------------------------
Please open 'chrome browser'.Go to 'File'->'Open File' .Open 'rss_aggregator.html'.  
 


