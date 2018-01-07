# import requests
# import semver
# import semantic_version
# import uuid
#
# from pypi_popular.core.models.package import Package
#
# def do(package_name):
#     url = 'https://pypi.python.org/pypi/{}/json'.format(package_name)
#     response = requests.get(
#         url=url
#     )
#
#     data = response.json()
#
#     return process_package_data(data)
#
#
# def process_package_data(data):
#
#     version_strs = data['releases'].keys()
#
#     # versions = []
#     # for version_str in version_strs:
#     #     try:
#     #         version = semantic_version.Version(version_str, partial=True)
#     #         versions.append(version)
#     #     except ValueError:
#     #         print 'Invalid version: {}'.format(version_str)
#     #         pass
#
#     versions = version_strs
#
#
#
#     versions = sorted(versions, reverse=True)
#     total_downloads = reduce(
#         reduce_download_count,
#         data['releases'].values(), 0)
#
#     package = Package()
#     package.id = uuid_hash(data['info']['name'])
#     package.name = data['info']['name']
#     package.total_downloads = total_downloads
#     package.save()
#
#     return package.to_json_dict()
#
#
# def uuid_hash(text):
#     text = text.encode('ascii', 'replace')
#     uuid_namespace = uuid.UUID('bec477f6-791e-408a-a8d8-d7527e0a121c')
#     return unicode(uuid.uuid5(uuid_namespace, text))
#
#
# def reduce_download_count(total, releases):
#     return total + sum([
#         r['downloads'] for r in releases
#     ])
#
#
# if __name__ == '__main__':
#     print do('ansible')
