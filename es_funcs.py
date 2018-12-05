from elasticsearch import Elasticsearch
import json,time,requests,os

#es = Elasticsearch (
#        [esurl],
#        http_auth = (esuser,espass),
#        scheme = "https",
#        port = port,
#    )

def get_indices(host='elastic-local-node'):
    fklogdir = os.getenv('FKLOGDIR')
    indexf = fklogdir + '/esresults/indices'
    os.makedirs(os.path.dirname(indexf),exist_ok = True)
    es = Elasticsearch(host=host)

    #for index in es.indices.get('*')
    #    print(index)

	# this HTTP WGET credentialling works here
    res = requests.get("http://elastic-local-node:9200/_cat/indices?v&h=index,docs.count&s=docs.count:desc")
    if res.headers['content-type'] == 'text/plain; charset=UTF-8':
        indices_ = filter(lambda x: not x.startswith('.') ,res.text.split('\n'))
        indices = [(e.split()[0],e.split()[1]) for e in indices_ if len(e.split()) == 2]
        outputf = open(indexf,'w')
        for index in indices[1:]:
            print(index)
            outputf.write("{} {}\n".format(index[0],index[1]))
        outputf.close()
    else:
        print("print res.json() instead?")

def get_docs(indexname,host='elastic-local-node'):
    fklogdir = os.getenv('FKLOGDIR')
    pathdir = fklogdir + '/esresults/{}/'.format(indexname)
    if not os.path.exists(pathdir):
        os.makedirs(pathdir,exist_ok = True) # avoid old python

    query = {
        'size': 10000,
        'query': {
            'match_all':{}
        }
    }

	# this requires correct way to pass credentials
    es = Elasticsearch(host=host)
    result = es.search(index=indexname,body={'query':{'match_all':{}}},size=0)
    total = result['hits']['total']

    fidx = 0
    got = 0
    res = es.search(index=indexname, body=query,scroll='1m')
    # https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-scroll.html
    # As documented, scroll id does not change in the while loop
    scroll = res['_scroll_id']  
    got = got + len(res['hits']['hits'])
    outputf = open(pathdir + '{}.json'.format(fidx),'w')
    outputf.write(json.dumps(res))
    outputf.close()
    while got < total:
        fidx = fidx + 1
        res = es.scroll(scroll_id = scroll, scroll = '1m')
        got = got + len(res['hits']['hits'])
        outputf = open(pathdir + '{}.json'.format(fidx),'w')
        outputf.write(json.dumps(res))
        outputf.close()
