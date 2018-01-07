from pypi_popular.core.es import EsClient


def search_packages(sname):
    es_client = EsClient()
    response = es_client.search(index='package', body={'query': {'match_all': {}}})
    return [p['_source'] for p in response['hits']['hits']]
