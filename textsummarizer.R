#load needed packages
library(xml2)
library(rvest)
library(lexRankr)

####  URL to scrape
auto_engines_blog = "https://www.forbes.com/sites/patrickmoorhead/2019/01/10/qualcomm-expands-presence-in-the-automotive-market-at-ces-2019/#40908ecd452b"
##### Read page html
page = xml2::read_html(auto_engines_blog)

##### Extract text from page html using selector
##page_text = rvest::html_text(rvest::html_nodes(page, ".speakableTextP2"))  #the Guardian
##page_text = rvest::html_text(rvest::html_nodes(page, ".content p"))            #hindustantimes
##page_text = rvest::html_text(rvest::html_nodes(page, ".drop-caps"))            # the hindu
##page_text = rvest::html_text(rvest::html_nodes(page, ".bullet p"))             #2B
page_text = rvest::html_text(rvest::html_nodes(page, ".article-body-image"))     #13B
##page_text = rvest::html_text(rvest::html_nodes(page, ".article-content-wrap"))



#perform lexrank for top 5 sentences
top_3 = lexRankr::lexRank(page_text,
                          #only 1 article; repeat same docid for all of input vector
                          docId = rep(1, length(page_text)),
                          #return 5 sentences to mimick /u/autotldr's output
                          n = 5,
                          continuous = TRUE)

# reorder the top 3 sentences to be in order of appearance in article
order_of_appearance = order(as.integer(gsub("_","",top_3$sentenceId)))
# extract sentences in order of appearance
ordered_top_5 = top_3[order_of_appearance, "sentence"]
auto_engines_blog_summ <- ordered_top_5
write(auto_engines_blog_summ,file="article_summary",append = TRUE)