import asyncio

import yaml

from elasticsearch_util.client import ElasticsearchClient
from elasticsearch_util.query import QueryBuilder


async def query_prod():
    query_builder = QueryBuilder()
    query_builder.add_query_string('"Received new image to process" AND *4870432*')
    query_builder.add_match('service_version', 'GCS-4059-hotfix-20201214-6bcf921e9')
    query = query_builder.build()
    query['size'] = 6000

    es_client = ElasticsearchClient('http://kibana.service.prod.gemini:80')
    count, matches = await es_client.query('logstash-obscura-*', query)

    print(f'There are {count} matches.')

    for hit in matches:
        message: str = hit['_source']['message']
        image_data = yaml.load(message[message.index('{'):message.rindex('}') + 1], yaml.SafeLoader)
        print(f'Image id: {image_data["image_id"]}')
        break

    es_client.session.close()


if __name__ == '__main__':
    asyncio.get_event_loop().run_until_complete(query_prod())
