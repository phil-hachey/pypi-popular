import click

from pypi_popular.core.es import EsClient
from pypi_popular.core.models.es_mappings import mappings

@click.group()
def cli():
    pass


@cli.command('update-index')
def update_index():
    es_client = EsClient()
    for index_id, index_config in mappings.iteritems():
        if es_client.indices.exists(index=index_id):
            for doc_type_id, doc_type in index_config['mappings'].iteritems():
                es_client.indices.put_mapping(
                    doc_type=doc_type_id,
                    index=index_id,
                    body=doc_type
                )
        else:
            es_client.indices.create(
                index=index_id,
                body=index_config
            )





if __name__ == '__main__':
    cli()
