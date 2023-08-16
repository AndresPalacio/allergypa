
import requests
from bs4 import BeautifulSoup
from lxml import etree

PATH_PARTICLE_RATE = "https://air.plumelabs.com/en/live/{}"

def particule2(lieu):
    """we search particule rate from plumelabs"""

    numbers = []
    liste = []

    path = PATH_PARTICLE_RATE.format(lieu)
    request = requests.get(path)
    print(path)
    page = request.content
    soup_html = BeautifulSoup(page, "html.parser")
    properties = soup_html.find_all("div", {'class':'report__pi-number'})
    aqui_level = soup_html.find_all("div", {'class':'report__pi-level'})
    xpath_expression = "//div[contains(@class, 'year-averages')]/div[contains(@class,'report-section')][1]/div/div[2]/span/span"
    xpath_expression_value_actually = "//div[contains(@class, 'report__pi-number')]/span"
    dom = etree.HTML (str(soup_html))
    print (properties)
    annual_average = dom.xpath (xpath_expression)[0].text
    actually_value= dom.xpath (xpath_expression_value_actually)[0].text
    for i in properties:
        liste.append(i.get_text())

    for i in liste:
        for j in i:
            try:
                j = int(j)
                if j == int(j):
                    numbers.append(str(j))
            except ValueError:
                pass 

    numbers = ''.join(numbers)
    numbers = int(numbers)

    recomendation = quality_table(float(actually_value))
    return {"numbers": numbers, "aqui_level": aqui_level[0].get_text(),
             "annual_average": annual_average, 
             "actually_value": actually_value,
             "recomendation": recomendation
             }


def quality_table(aqi:float):
    if aqi >=0 and aqi <= 20:
        print("Excellent")
        return "La calidad del aire es ideal para la maytoria de individuos; disfrute de sus actividades al aire libre."
    elif aqi >=21 and aqi <= 50:
        print("Fair")
        return "La calidad del aire es generalmente aceptable para la mayoria de individuos; sin embargo, los grupos sensibles pueden experimentar efectos en la salud."
    elif aqi >=51 and aqi <= 100:
        print("Poor")
        return "El aire ha alcanzado un nivel alto de contaminacion y es nocivo para la salud de los grupos sensibles."
    elif aqi >=101 and aqi <= 150:
        print("Unhealthy")
    elif aqi >=151 and aqi <= 200:
        print("Very Unhealthy")
    elif aqi >=201 and aqi <= 300:
        print("Dangerous")
    

if __name__ == "__main__":
    print(particule2("Medellin"))

# https://dev.to/aissalaribi/how-to-use-beautiful-soup-in-aws-lambda-for-web-scrapping-1gh8

# https://medium.com/@kagemusha_/scraping-on-a-schedule-with-aws-lambda-and-cloudwatch-caf65bc38848
