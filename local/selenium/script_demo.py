# coding=utf-8
import unittest,time,os
import HTMLTestReportCN
from selenium import webdriver

class Test_search(unittest.TestCase):
    def setUp(self):
        chromedriver = "/works/bins/chromedriver"
        self.driver = webdriver.Chrome(chromedriver)
        self.base_url = 'https://www.baidu.com'
        self.driver.implicitly_wait(30)
        self.driver.maximize_window()

    def tearDown(self):
        self.driver.quit()

    def test_baidu(self):
        '''百度搜索测试用例'''
        driver = self.driver
        driver.get(self.base_url)
        driver.find_element_by_css_selector('#kw').send_keys('demo')
        driver.find_element_by_css_selector('#su').click()
        time.sleep(3)
        title = driver.title
        self.assertEqual(title,u'demo_百度搜索')

    def test_youdao(self):
        '''有道搜索测试用例'''
        driver = self.driver
        driver.get('http://www.youdao.com/')
        driver.find_element_by_name("q").clear()
        driver.find_element_by_name("q").send_keys("webdriver")
        driver.find_element_by_xpath("//*[@id='form']/button").click()
        time.sleep(2)
        driver.find_element_by_xpath("html/body/div[7]/i/a[1]").click()
        text01 = driver.find_element_by_css_selector("span[class='keyword']").text
        self.assertEqual(text01,'webdriver')


def Suite():
    suiteTest = unittest.TestSuite()
    #测试用例
    suiteTest.addTest(Test_search("test_baidu"))
    suiteTest.addTest(Test_search("test_youdao"))
    return suiteTest

if __name__ == '__main__':
    now = time.strftime("%d_%H%M%S",time.localtime())   # %Y%m
    # unittest.main()   # 直接运行
    
    filePath ='Report_{}(CN).html'.format(now)    #确定生成报告的路径
    fp = open(filePath,'wb')
    runner = HTMLTestReportCN.HTMLTestRunner(
        stream=fp,
        title='关键字搜索测试【百度+有道】',
        description='详细测试用例结果',
        tester='xndery'
        )
    runner.run(Suite())
    fp.close()