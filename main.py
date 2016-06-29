import multiprocessing
import glob
from nude import Nude

import logging
import shutil

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
fh = logging.FileHandler('result.log')
fh.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger.addHandler(fh)


porn_dir = '/Users/rocky/porn/is_porn/'
not_porn_dir = '/Users/rocky/porn/not_porn/'


def process(path):
    try:
        n = Nude(path)
        n.parse()
        logger.info('path:%s, result:%s, detail:%s', path, n.result, n.inspect())

        if n.result:
            shutil.copy(path, porn_dir)
        else:
            shutil.copy(path, not_porn_dir)

    except Exception as err:
        logger.error('image error')


p = multiprocessing.Pool()
folder = '/Users/rocky/porn/porn_img/'

for f in glob.glob(folder + "*.jpg"):
    p.apply_async(process, [f])

p.close()
p.join()
