"""
## Diving into Dispatched Worker
Or, look into [pbjgraph](https://mg.pov.lt/objgraph/)
#### Setup
pip install https://github.com/mgedmin/dozer/archive/0.8.zip
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

#### Investigation
[Instructions to guide, but not directly follow](https://stackoverflow.com/a/61260839/2276358)

Add code to where you want to investigate, such as
```python
def run_dozer():
    import wsgiref.simple_server
    import dozer
    app = dozer.Dozer(app=None, path='/')
    with wsgiref.simple_server.make_server('', 8000, app) as httpd:
        print('Serving Dozer on port 8000...')
        httpd.serve_forever()

import threading, time
threading.Thread(target=run_dozer, daemon=True).start()
while True:
    time.sleep(10)
```

Run what you need, open up [localhost](http://localhost:8000)

#### Teardown
pip uninstall WebOb, Dozer
echo 1 | sudo tee /proc/sys/kernel/yama/ptrace_scope
"""