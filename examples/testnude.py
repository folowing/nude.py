from __future__ import print_function

import time
import os
from nude import Nude

ROOT = os.path.dirname(os.path.abspath(__file__))

start = time.time()
n = Nude(os.path.join(ROOT, 'images/damita.jpg'))
n.parse()
print(time.time() - start)
print(n.result, n.inspect())

# start = time.time()
# n = Nude(os.path.join(ROOT, 'images/damita2.jpg'))
# n.parse()
# print(time.time() - start)
# print(n.result, n.inspect())
#
# start = time.time()
# n = Nude(os.path.join(ROOT, 'images/test6.jpg'))
# n.parse()
# print(time.time() - start)
# print(n.result, n.inspect())
#
# start = time.time()
# n = Nude(os.path.join(ROOT, 'images/test2.jpg'))
# n.parse()
# print(time.time() - start)
# print(n.result, n.inspect())
