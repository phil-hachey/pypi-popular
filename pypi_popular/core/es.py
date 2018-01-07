from elasticsearch import Elasticsearch

from pypi_popular.core.settings import settings


def EsClient():
    settings_dct = settings()
    es_client = Elasticsearch(settings_dct['ES_URL'])
    return es_client
