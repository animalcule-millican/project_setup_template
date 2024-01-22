#!/usr/bin/env python3
import argparse
from os import environ
import requests

#### post command
def git_post(name, descrip, token):
    url = 'https://api.github.com/user/repos'
    data = {
        'name': f'{name}',
        'description': f'{descrip}',
        'homepage': 'https://github.com',
        'private': False,
        'is_template': False,
    }
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    response = requests.post(url, headers=headers, json=data)
    # Print response if you want to see the result
    print(response.text["html_url"])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create a new repo on github')
    args = parser.parse_args()
    # import variables
    project_name = environ.get('project_name')
    repo_descrip = environ.get('repo_descrip')
    git_tokin = environ.get('GET_TOKIN')
    git_post(project_name, repo_descrip, git_tokin)
    