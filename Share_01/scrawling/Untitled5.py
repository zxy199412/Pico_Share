
# coding: utf-8

# In[3]:

import urllib2
from urllib2 import urlopen
from bs4 import BeautifulSoup as bs


# In[2]:

url='file:///C:/Users/Administrator/Desktop/html&crawling/Html/test.html'


# In[4]:

html=urlopen(url)


# In[5]:

print html.read()


# In[9]:

print html.headers


# In[10]:

print html.url


# In[28]:

html1=urllib2.Request(url)


# In[29]:

html1.add_header('User-Agent','Mozilla/5.0')


# In[30]:

html2=urlopen(html1)


# In[31]:

print html2.read()


# In[33]:

import cookielib


# In[34]:

js=cookielib.CookieJar()


# In[35]:

opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(js))


# In[36]:

urllib2.install_opener(opener)


# In[37]:

html3=urlopen(url)


# In[38]:

print html3.read()


# In[11]:

html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>

<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>

<p class="story">...</p>
"""


# In[12]:

soup=bs(html_doc)


# In[13]:

soup.title


# In[14]:

soup.title.name


# In[15]:

soup.title.string


# In[16]:

soup.p


# In[17]:

soup.find_all('p')


# In[18]:

soup.find('p')


# In[19]:

import re


# In[20]:

soup.find_all('a')


# In[22]:

soup.find_all('a',id='link2')


# In[24]:

soup.find_all('a',href=re.compile(r'lacie'))


# In[26]:

print soup.prettify()


# In[27]:

print soup.get_text()

