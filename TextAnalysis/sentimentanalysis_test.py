from textblob import TextBlob #import the textblob module, which can perform sentiment analysis on a blob of a text
import requests #import the requests module, which can grab html text from a url
from bs4 import BeautifulSoup #import the beautifulsoup module, which parses through html text to make it readable and searchable
import csv #for reading and writing to csv
from collections import defaultdict #to create a dictionary when reading in the project file

columns = defaultdict(list) #create a dictionary of lists to hold all of the data from the AWEA Wind Project Database
unique_projects_list = list() #this list is for every unique project
states_list = list() #this list is for each state corresponding to the project
sentiment_list = list() #this list is for each unique project's sentiment
subjectivity_list = list() #this list is for each unique project's subjectivity

with open(r'G:\TextAnalysis\WindbeltProjectDatabase.csv','r') as csvfile: #open the wind project database
    reader = csv.DictReader(csvfile) #create reader variable to read csv file
    for row in reader: #loop through every row
        for (key,value) in row.items(): #loop through every item
            columns[key].append(value) #add each value to the corresponding key (which will be the column name)
            #For instance, add the value "Bitworks" to the key "Master Project Name"

class Analysis: #create a class for running the analysis on each project
    def __init__(self,term): #define the initilization function
        self.term = term #the search term
        self.subjectivity = 0 #subjectivity variable
        self.sentiment = 0 #sentiment variable
        self.url = 'https://www.google.com/search?q={0}&source=lnms&tbm=nws'.format(self.term) #baseline URL, with the search term passed in to where the "0" is

    def run(self): #define the main run function
        response = requests.get(self.url) #get the HTML text from the url
        print(response.status_code)
        print(response)
        soup = BeautifulSoup(response.text,'html.parser') #run BS4 on text, making it searchable
        #search_results = soup.find_all('a')
        #for link in search_results:
            #print(link.get('href'))

        headline_results = soup.find_all('div',class_='st') #grab all headlines and subtext from the html file
        print(headline_results)
        for h in headline_results: #loop through all these headlines / text for each search result
            blob = TextBlob(h.get_text()) #turn the text into a textblob for sentiment analysis
            self.sentiment += blob.sentiment.polarity / len(headline_results) #determine sentiment of search result (float from -1 to 1)
            self.subjectivity += blob.sentiment.subjectivity / len(headline_results) #determine subjectivity of search result (float from 0 to 1)
            print(h)

        #print(soup.get_text())
        #print(response.text)

##for i in range(len(columns['Master Project Name'])):#loop through all the project names (dublicates included)
##    project = columns['Master Project Name'][i] #each project name
##    proj_name = project.replace(",",'')
##    if proj_name not in unique_projects_list: #check if project is in list already
##        unique_projects_list.append(project) #if not, add it to list
##        states_list.append(columns['State'][i]) #and also add state of project
##
##for project in range(len(unique_projects_list)): #for every unique project
##    w = "wind project"
##    a = Analysis(unique_projects_list[project] + f' "{w}" ' + states_list[project]) #define analysis variable with given search term
##    #print(unique_projects_list[project] + f' "{w}" ' + states_list[project])
##    a.run() #run analysis
##    sentiment_list.append(a.sentiment) #add sentiment result to final list
##    subjectivity_list.append(a.subjectivity) #add subjectivity result to final list

wind = "wind project"
#a = Analysis("Lincoln County" + f' "{wind}" ' + "Minnesota")
a = Analysis("test")
a.run()
    
print(a.term, ' Subjectivity: ', a.subjectivity, 'Sentiment: ', a.sentiment)
#print(columns['Master Project Name'])

##with open('sentiment_analysis.csv', 'w') as csvfile:
##    filewriter = csv.writer(csvfile, delimiter=',',
##                            quotechar='|', lineterminator='\n', quoting=csv.QUOTE_MINIMAL)
##    print("writing to file...")
##    filewriter.writerow(['ProjectName','State','Sentiment','Subjectivity'])
##    for i in range(len(unique_projects_list)):
##        filewriter.writerow([unique_projects_list[i],states_list[i],sentiment_list[i],subjectivity_list[i]])
##    print("Writing complete")
        
