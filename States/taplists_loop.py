from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from pyvirtualdisplay import Display
      
display = Display(visible=0, size=(800, 600))
display.start()

driver = webdriver.Firefox()

with open('thesebars') as f:
    for bar in f:
        bar = bar.rstrip('\n')
        web = "http://www.nowtapped.com/" + bar
        driver.get(web)
        time.sleep(3)
#        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "officialList")))
        html_source = driver.page_source
        fout_name = "./html_" + bar
        fout1=open(fout_name, 'w+')
        fout1.write(html_source.encode('utf8'))

driver.quit()
display.stop()
