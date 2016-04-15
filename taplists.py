from selenium import webdriver
driver = webdriver.Firefox()

f = open('bar', 'r')
bar = f.readline()[:-1]

web = "http://www.nowtapped.com/" + bar

driver.get(web)
html_source = driver.page_source

fout1=open('./html', 'w+')
fout1.write(html_source.encode('utf8'))

driver.quit()
