# parsing.py
import requests
from bs4 import BeautifulSoup

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0 Safari/537.36'
}

def get_info():
    url = 'https://spidermedia.ru/mustread'
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        names = []
        desc = []
        soup = BeautifulSoup(response.text, 'html.parser')

        for name_tag in soup.find_all('div', class_='moment-title'):
            name = name_tag.get_text(strip=True).replace('✓', '').strip()
            if name:
                names.append(name)

        for desc_tag in soup.find_all('div', class_='moment-content'):
            p = desc_tag.find('p')
            description = p.get_text(strip=True) if p else 'no description'
            desc.append(description)

        return names, [], desc  # даты пока не парсим точно
    else:
        print(f"Ошибка загрузки страницы: {response.status_code}")
        return [], [], []

info = get_info()
